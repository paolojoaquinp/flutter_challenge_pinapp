// SRP: This page is solely responsible for displaying full movie details
// and routing the user to the Recommendation Modal (HU-03).
// It fetches detail data on demand — no data fetching in build().
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  const MovieDetailPage({super.key, required this.movieId});

  static const routeName = '/detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(_movieDetailProvider(movieId));

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: detailAsync.when(
        data: (detail) => DetailContentWidget(detail: detail),
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
