import 'package:flutter/material.dart';

class GenreChipsWidget extends StatelessWidget {
  final List<String> genres;
  const GenreChipsWidget({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: genres
          .map(
            (g) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                g,
                style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 12),
              ),
            ),
          )
          .toList(),
    );
  }
}
