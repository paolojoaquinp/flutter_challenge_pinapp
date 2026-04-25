import 'package:flutter/material.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_detail_entity.dart';

class MetaRowWidget extends StatelessWidget {
  final MovieDetailEntity detail;
  const MetaRowWidget({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFC107)),
        const SizedBox(width: 4),
        Text(
          detail.voteAverage.toStringAsFixed(1),
          style: const TextStyle(
            color: Color(0xFFFFC107),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.schedule_rounded, size: 16, color: Color(0xFF888888)),
        const SizedBox(width: 4),
        Text(
          '${detail.runtime} min',
          style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
        ),
        const SizedBox(width: 16),
        const Icon(
          Icons.calendar_today_rounded,
          size: 14,
          color: Color(0xFF888888),
        ),
        const SizedBox(width: 4),
        Text(
          detail.releaseDate.isNotEmpty
              ? detail.releaseDate.substring(0, 4)
              : '—',
          style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
        ),
      ],
    );
  }
}
