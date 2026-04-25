// SRP: This page is solely responsible for displaying full movie details
// and routing the user to the Recommendation Modal (HU-03).
// It fetches detail data on demand — no data fetching in build().
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/core/utils/constants.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/repository_providers.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/error_state_widget.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_detail_entity.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/page/movie_detail/widgets/detail_content_widget.dart';

// TODO: review relocate provider
// Provider scoped to a movie ID — auto-disposed when the page is popped.
final _movieDetailProvider = FutureProvider.family
    .autoDispose<MovieDetailEntity, int>((ref, id) async {
      final repo = await ref.read(movieRepositoryProvider.future);
      final result = await repo.getMovieDetail(id);
      return result.when(ok: (detail) => detail, err: (e) => throw e);
    });

class MovieDetailPage extends ConsumerWidget {
  final int movieId;
  // posterPath ensures the Hero tag is present immediately so the push
  // animation finds a matching destination before the API response arrives.
  final String? posterPath;
  const MovieDetailPage({super.key, required this.movieId, this.posterPath});

  static const routeName = '/detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(_movieDetailProvider(movieId));

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: detailAsync.when(
        data: (detail) => DetailContentWidget(detail: detail),
        loading: () => _LoadingWithHero(movieId: movieId, posterPath: posterPath),
        error: (e, _) => ErrorStateWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(_movieDetailProvider(movieId)),
        ),
      ),
    );
  }
}

class _LoadingWithHero extends StatelessWidget {
  final int movieId;
  final String? posterPath;
  const _LoadingWithHero({required this.movieId, this.posterPath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (posterPath != null && posterPath!.isNotEmpty)
          Hero(
            tag: 'movie_poster_$movieId',
            child: CachedNetworkImage(
              imageUrl: '$kTmdbImageBaseUrl$posterPath',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          )
        else
          Hero(
            tag: 'movie_poster_$movieId',
            child: const SizedBox.expand(),
          ),
        const ColoredBox(color: Color(0x88000000)),
        const Center(
          child: CircularProgressIndicator(color: Color(0xFFE50914)),
        ),
      ],
    );
  }
}
