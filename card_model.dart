class MemoryCard {
  final String imagePath;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.imagePath,
    this.isFlipped = false,
    this.isMatched = false,
  });
}