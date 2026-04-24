// SRP: This page is solely responsible for displaying full movie details
// and routing the user to the Recommendation Modal (HU-03).
// It fetches detail data on demand — no data fetching in build().
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/core/utils/constants.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/repository_providers.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/error_state_widget.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/recommendation_modal_widget.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_detail_entity.dart';

// TODO: review relocate provider
// Provider scoped to a movie ID — auto-disposed when the page is popped.
final _movieDetailProvider =
    FutureProvider.family.autoDispose<MovieDetailEntity, int>((ref, id) async {
  final repo = await ref.read(movieRepositoryProvider.future);
  final result = await repo.getMovieDetail(id);
  return result.when(
    ok: (detail) => detail,
    err: (e) => throw e,
  );
});

class MovieDetailPage extends ConsumerWidget {
  final int movieId;
  const MovieDetailPage({super.key, required this.movieId});

  static const routeName = '/detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(_movieDetailProvider(movieId));

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: detailAsync.when(
        data: (detail) => _DetailContent(detail: detail),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFE50914)),
        ),
        error: (e, _) => ErrorStateWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(_movieDetailProvider(movieId)),
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final MovieDetailEntity detail;
  const _DetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _BackdropAppBar(detail: detail),
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
                _MetaRow(detail: detail),
                const SizedBox(height: 20),
                _GenreChips(genres: detail.genres.map((g) => g.name).toList()),
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
                  detail.overview.isEmpty ? 'No overview available.' : detail.overview,
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
                    icon: const Icon(Icons.share_rounded, color: Color(0xFFE50914)),
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

class _BackdropAppBar extends StatelessWidget {
  final MovieDetailEntity detail;
  const _BackdropAppBar({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF0D0D0D),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (detail.backdropPath.isNotEmpty)
              CachedNetworkImage(
                imageUrl: '$kTmdbImageBaseUrl${detail.backdropPath}',
                fit: BoxFit.cover,
              )
            else
              Container(color: const Color(0xFF1A1A1A)),
            // Gradient overlay for readability.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xFF0D0D0D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final MovieDetailEntity detail;
  const _MetaRow({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFC107)),
        const SizedBox(width: 4),
        Text(
          detail.voteAverage.toStringAsFixed(1),
          style: const TextStyle(color: Color(0xFFFFC107), fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.schedule_rounded, size: 16, color: Color(0xFF888888)),
        const SizedBox(width: 4),
        Text(
          '${detail.runtime} min',
          style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF888888)),
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

class _GenreChips extends StatelessWidget {
  final List<String> genres;
  const _GenreChips({required this.genres});

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
              child: Text(g,
                  style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 12)),
            ),
          )
          .toList(),
    );
  }
}
