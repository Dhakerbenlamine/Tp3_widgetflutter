
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  // TODO 1 : état local du favori
  bool _favori = false;

  void _basculer() {
    setState(() {
      _favori = !_favori;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _favori
                ? 'Ajouté aux favoris'
                : 'Retiré des favoris',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // TODO 3 : IconButton qui appelle _basculer ;
    return IconButton(
      onPressed: _basculer,
      icon: Icon(
        _favori ? Icons.favorite : Icons.favorite_border,
        color: _favori ? Colors.red : null,
      ),
      tooltip: _favori ? 'Retirer des favoris' : 'Ajouter aux favoris',
    );
  }
}
