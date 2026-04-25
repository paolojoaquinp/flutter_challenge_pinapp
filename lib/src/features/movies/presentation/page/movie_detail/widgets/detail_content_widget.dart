import 'package:flutter/material.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/recommendation_modal_widget.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_detail_entity.dart';
import 'backdrop_app_bar_widget.dart';
import 'meta_row_widget.dart';
import 'genre_chips_widget.dart';

class DetailContentWidget extends StatelessWidget {
  final MovieDetailEntity detail;
  const DetailContentWidget({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        BackdropAppBarWidget(detail: detail),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (detail.tagline.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    '"${detail.tagline}"',
                    style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                MetaRowWidget(detail: detail),
                const SizedBox(height: 20),
                GenreChipsWidget(
                  genres: detail.genres.map((g) => g.name).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  detail.overview.isEmpty
                      ? 'No overview available.'
                      : detail.overview,
                  style: const TextStyle(
                    color: Color(0xFFCCCCCC),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                // HU-03: Recommend button opens the modal.
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => RecommendationModalWidget.show(
                      context,
                      movieTitle: detail.title,
                    ),
                    icon: const Icon(
                      Icons.share_rounded,
                      color: Color(0xFFE50914),
                    ),
                    label: const Text(
                      'Recommend to a friend',
                      style: TextStyle(color: Color(0xFFE50914)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE50914)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
