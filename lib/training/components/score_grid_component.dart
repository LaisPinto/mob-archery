import 'package:flutter/material.dart';

/// Grade 4×3 de botões de pontuação para tiro com arco.
/// As cores seguem o padrão FITA de zonas da mira.
class ScoreGridComponent extends StatelessWidget {
  const ScoreGridComponent({
    super.key,
    required this.onScoreSelected,
  });

  final void Function(String score) onScoreSelected;

  static const _scores = [
    'X', '10', '9', '8',
    '7', '6', '5', '4',
    '3', '2', '1', 'M',
  ];

  Color _buttonColor(String score) {
    switch (score) {
      case 'X':
      case '10':
      case '9':
        return const Color(0xFFFFCC15); // Zona ouro FITA
      case '8':
      case '7':
        return const Color(0xFFE32727); // Zona vermelha FITA
      case '6':
      case '5':
        return const Color(0xFF4280E8); // Zona azul FITA
      case '4':
      case '3':
        return const Color(0xFF121B31); // Zona preta FITA
      default:
        return const Color(0xFFE7EDF5); // M / 2 / 1 — branca/miss
    }
  }

  Color _buttonTextColor(String score) {
    switch (score) {
      case 'M':
      case '2':
      case '1':
        return const Color(0xFF1A2238);
      default:
        return Colors.white;
    }
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
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final score = _scores[index];
        return FilledButton(
          onPressed: () => onScoreSelected(score),
          style: FilledButton.styleFrom(
            backgroundColor: _buttonColor(score),
            foregroundColor: _buttonTextColor(score),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: _buttonTextColor(score),
                ),
              ),
              if (score == 'X')
                Text(
                  '10 pts',
                  style: TextStyle(fontSize: 11, color: _buttonTextColor(score)),
                ),
              if (score == 'M')
                const Text(
                  'Miss',
                  style: TextStyle(fontSize: 11, color: Color(0xFF7C8AA5)),
                ),
            ],
          ),
        );
      },
    );
  }
}