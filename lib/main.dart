import 'package:flutter/material.dart';
import 'package:rihla/data/destinations.dart';
import 'package:rihla/models/destination.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'package:provider/provider.dart';
import 'providers/favoris_model.dart';
import 'providers/reglages_model.dart';
void main() { 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavorisModel()..charger()),
        ChangeNotifierProvider(create: (_) => ReglagesModel()..charger()),
      ],
      child: const RihlaApp(),
    ),
  ); 
} 
class RihlaApp extends StatelessWidget { 
  const RihlaApp({super.key}); 
  
  @override
  Widget build(BuildContext context) {
    final sombre = context.watch<ReglagesModel>().sombre;
    return MaterialApp(
    title: 'Rihla',
    debugShowCheckedModeBanner: false,
    themeMode: sombre ? ThemeMode.dark : ThemeMode.light,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0E7C86),
      ),
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0E7C86),
        brightness: Brightness.dark,
      ),
    ),
    home: const HomeScreen(),
  );
   } 
   

}
