import 'package:flutter/material.dart';

class ScoreKeyboardComponent extends StatelessWidget {
  const ScoreKeyboardComponent({super.key, required this.onScoreSelected});

  final void Function(String score) onScoreSelected;

  static const _scores = [
    'X',
    '10',
    '9',
    '8',
    '7',
    '6',
    '5',
    '4',
    '3',
    '2',
    '1',
    'M',
  ];

  Color _buttonColor(String score) {
    switch (score) {
      case 'X':
        return const Color(0xFF0F172A);
      case '10':
      case '9':
        return const Color(0xFFFACC15);
      case '8':
      case '7':
        return const Color(0xFFDC2626);
      case '6':
      case '5':
        return const Color(0xFF3B82F6);
      case '4':
      case '3':
        return const Color(0xFF0F172A);
      case 'M':
        return const Color(0xFFE2E8F0);
      case '2':
      case '1':
        return const Color(0xFFFFFFFF);
      default:
        return Colors.white;
    }
  }

  Color _buttonTextColor(String score) {
    if (score == 'M') return const Color(0xFF475569);
    if (score == '2' || score == '1') return const Color(0xFF0F172A);
    if (score == '10' || score == '9') return const Color(0xFF0F172A);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _scores.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final score = _scores[index];
        final bgColor = _buttonColor(score);
        final fgColor = _buttonTextColor(score);
        final isWhiteBtn = score == '1' || score == '2';

        return FilledButton(
          onPressed: () => onScoreSelected(score),
          style: FilledButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: fgColor,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: isWhiteBtn
                  ? const BorderSide(color: Color(0xFFE2E8F0))
                  : BorderSide.none,
            ),
            elevation: 0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: fgColor,
                ),
              ),
              if (score == 'X')
                Text(
                  '10 pts',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              if (score == 'M')
                const Text(
                  'Miss',
                  style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                ),
            ],
          ),
        );
      },
    );
  }
}
