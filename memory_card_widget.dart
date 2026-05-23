import 'package:flutter/material.dart';
import '../card_model.dart';

class MemoryCardWidget extends StatelessWidget {

  final MemoryCard card;
  final Color backColor;
  final VoidCallback onTap;
  final int index;

  const MemoryCardWidget({
    super.key,
    required this.card,
    required this.backColor,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: AnimatedSwitcher(

        duration: const Duration(milliseconds: 300),

        transitionBuilder: (child, animation) {

          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },

        child: card.isFlipped || card.isMatched
            ? _buildFrontCard()
            : _buildBackCard(),
      ),
    );
  }

  Widget _buildFrontCard() {

    return Container(

      key: ValueKey('front_$index'),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: card.isMatched
            ? Border.all(
          color: Colors.green,
          width: 3,
        )
            : Border.all(
          color: Colors.grey.shade300,
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(8),

        child: Image.asset(
          card.imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildBackCard() {

    return Container(

      key: ValueKey('back_$index'),

      decoration: BoxDecoration(

        color: backColor,

        borderRadius: BorderRadius.circular(14),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),

      child: const Center(

        child: Text(
          '?',

          style: TextStyle(
            color: Color(0xFFFFF8E1),
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}