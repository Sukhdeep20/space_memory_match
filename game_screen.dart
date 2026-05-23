import 'package:flutter/material.dart';
import 'dart:async';

import 'card_model.dart';
import 'widgets/memory_card_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  final List<String> _animalImages = [
    'assets/images/animal.png',
    'assets/images/animal1.png',
    'assets/images/animal2.png',
    'assets/images/animals.png',
    'assets/images/bird.png',
    'assets/images/bull.png',
    'assets/images/chick.png',
    'assets/images/cow.png',
    'assets/images/elephant.png',
    'assets/images/listening.png',
  ];

  final List<Color> _cardColors = [
    const Color(0xFF66BB6A),
    const Color(0xFFEF5350),
    const Color(0xFF42A5F5),
    const Color(0xFFFFCA28),
    const Color(0xFF7E57C2),
    const Color(0xFF26A69A),
    const Color(0xFFEC407A),
    const Color(0xFFFFA726),
    const Color(0xFF26C6DA),
    const Color(0xFF8BC34A),
  ];

  List<MemoryCard> _cards = [];
  List<Color> _cardColorList = [];

  int? _firstFlippedIndex;
  int? _secondFlippedIndex;

  bool _isChecking = false;

  int _score = 0;
  int _matchesFound = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {

    List<MemoryCard> cardList = [];
    List<Color> colorList = [];

    for (int i = 0; i < _animalImages.length; i++) {
      cardList.add(MemoryCard(imagePath: _animalImages[i]));
      cardList.add(MemoryCard(imagePath: _animalImages[i]));

      colorList.add(_cardColors[i % _cardColors.length]);
      colorList.add(_cardColors[i % _cardColors.length]);
    }

    cardList.shuffle();
    colorList.shuffle();

    setState(() {
      _cards = cardList;
      _cardColorList = colorList;

      _firstFlippedIndex = null;
      _secondFlippedIndex = null;

      _isChecking = false;

      _score = 0;
      _matchesFound = 0;
    });
  }

  void _onCardTap(int index) {

    if (_isChecking) return;
    if (_cards[index].isFlipped) return;
    if (_cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstFlippedIndex == null) {
      _firstFlippedIndex = index;
    } else {
      _secondFlippedIndex = index;
      _isChecking = true;
      _checkForMatch();
    }
  }

  void _checkForMatch() {

    int first = _firstFlippedIndex!;
    int second = _secondFlippedIndex!;

    if (_cards[first].imagePath == _cards[second].imagePath) {

      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _cards[first].isMatched = true;
          _cards[second].isMatched = true;

          _score++;
          _matchesFound++;

          _firstFlippedIndex = null;
          _secondFlippedIndex = null;

          _isChecking = false;
        });

        if (_matchesFound == _animalImages.length) {
          _showWinDialog();
        }
      });

    } else {

      Timer(const Duration(milliseconds: 850), () {
        setState(() {
          _cards[first].isFlipped = false;
          _cards[second].isFlipped = false;

          _firstFlippedIndex = null;
          _secondFlippedIndex = null;

          _isChecking = false;
        });
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            '🎉 You Won!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          content: Text(
            'You matched all pairs successfully!\n\nScore: $_score',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _initGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Play Again'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Responsive column count based on screen width
    int crossAxisCount;
    if (screenWidth > 1100) {
      crossAxisCount = 5;
    } else if (screenWidth > 700) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 4;
    }

    // Total cards and row count
    int totalCards = _cards.length; // 20
    int rowCount = (totalCards / crossAxisCount).ceil();

    // Spacing between cards
    double spacing = 8;

    // Reserved UI height:
    // AppBar title (~56) + subtitle bar (34) + top padding (6)
    // + bottom button area (60) + bottom padding (16) + bottom safe area
    double reservedHeight = 172 + MediaQuery.of(context).padding.bottom;

    // Available space for the grid
    double availableHeight = screenHeight - reservedHeight;
    double availableWidth = screenWidth - 24; // 12 padding each side

    // Calculate exact card dimensions
    double cardHeight =
        (availableHeight - (spacing * (rowCount - 1))) / rowCount;
    double cardWidth =
        (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

    // Aspect ratio = width / height
    double aspectRatio = (cardWidth / cardHeight).clamp(0.5, 2.0);

    return Scaffold(

      backgroundColor: const Color(0xFFFFF9C4),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9C4),
        elevation: 0,

        leading: const BackButton(color: Colors.black),

        centerTitle: true,

        title: const Text(
          'Memory Match',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 14,
              top: 8,
              bottom: 8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.gps_fixed,
                  size: 18,
                  color: Colors.teal,
                ),
                const SizedBox(width: 5),
                Text(
                  '$_score',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(34),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Find all matching pairs! 🔍',
              style: TextStyle(
                color: Colors.green,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: GridView.builder(

                  // No scrolling — all cards calculated to fit perfectly
                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: _cards.length,

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: aspectRatio,
                  ),

                  itemBuilder: (context, index) {
                    return MemoryCardWidget(
                      card: _cards[index],
                      backColor: _cardColorList[index],
                      index: index,
                      onTap: () => _onCardTap(index),
                    );
                  },
                ),
              ),
            ),

            // Restart button at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton.icon(
                onPressed: _initGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Restart',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}