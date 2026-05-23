import 'package:flutter/material.dart';
import 'game_screen.dart';

void main() {
  runApp(const MemoryMatchApp());
}

class MemoryMatchApp extends StatelessWidget {
  const MemoryMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Match',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const GameScreen(),
    );
  }
}