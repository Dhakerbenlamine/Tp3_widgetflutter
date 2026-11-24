# Journal IA

## Questions et réponses

### 1. Pourquoi stocke-t-on des chaînes JSON et pas directement des objets Destination ?

On stocke des chaînes JSON parce que `SharedPreferences` ne peut pas enregistrer directement des objets Dart personnalisés tels que `Destination`. Le JSON permet d’utiliser des fonctions simples de sérialisation, puis de reconstituer les objets avec `fromJson()` lorsque l’application en a besoin.

Cette solution convient au stockage local hors ligne, contrairement à une base de données plus structurée.

### 2. Que fait exactement `FavorisModel()..charger()` ? Que se passerait-il avec `FavorisModel().charger()` ?

`FavorisModel()..charger()` crée d’abord un objet `FavorisModel`, puis lance immédiatement la méthode `charger()` sur cet objet grâce à l’opérateur cascade.

`FavorisModel().charger()` lance `charger()` mais renvoie le `Future` obtenu par cette méthode, donc pas l’objet `FavorisModel` lui-même. Il ne peut donc pas être utilisé directement comme résultat d’un `Provider`.

### 3. Pourquoi oublier `notifyListeners()` à la fin de `charger()` serait-il un bug discret ?

Sans `notifyListeners()`, les données sont bien chargées dans `FavorisModel` ou `ReglagesModel`, mais les widgets qui suivent ces modèles ne sont pas prévenus. Leur ancienne interface peut donc rester affichée jusqu’à une autre reconstruction.

C’est un bug souvent discret, car il ne provoque pas nécessairement d’erreur, mais il rend l’état de l’application incohérent visuellement.

### 4. Pourquoi mémoriser le cache après avoir vérifié le `statusCode`, et pas avant ?

On mémorise le cache après avoir vérifié que le serveur répond avec `statusCode == 200`, afin d’éviter d’enregistrer une erreur HTML ou un message JSON invalide comme données valides.

Le cache doit toujours représenter une réponse réelle et exploitable contenant les destinations.

### 5. Que voit l’utilisateur qui ouvre Rihla pour la première fois sans serveur ? Pourquoi ?

Lors du premier lancement sans serveur et sans données déjà enregistrées, l’utilisateur voit l’écran d’erreur réseau avec le message « Vérifiez que json-server est lancé » et le bouton « Réessayer ».

Cela arrive parce qu’aucune connexion n’est possible et qu’aucun cache n’existe encore pour remplacer les données du serveur.

### 6. Que fait `rethrow`, et qui récupère l’erreur ensuite ?

`rethrow` renvoie l’exception d’origine lorsqu’il n’existe aucune donnée dans le cache.

L’erreur remonte ensuite jusqu’à l’appel à `ApiService.getDestinations()`, puis elle est récupérée par `FutureBuilder` grâce à `snapshot.hasError`. `FutureBuilder` affiche alors le widget `ErreurReseau` à l’utilisateur.
