import 'package:flutter/material.dart';

class ArrowScoreSelector extends StatelessWidget {
  const ArrowScoreSelector({
    super.key,
    required this.arrowIndex,
    required this.selectedScore,
    required this.scores,
    required this.onSelect,
  });

  final int arrowIndex;
  final String? selectedScore;
  final List<String> scores;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Arrow $arrowIndex'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: scores
                  .map(
                    (score) => ChoiceChip(
                      label: Text(score),
                      selected: selectedScore == score,
                      onSelected: (_) => onSelect(score),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
