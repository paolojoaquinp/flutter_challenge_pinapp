import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/error_state_widget.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/movie_grid_widget.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

class PopularTabWidget extends ConsumerWidget {
  final void Function(MovieEntity) onMovieTap;

  const PopularTabWidget({super.key, required this.onMovieTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(popularMoviesProvider);
    return state.when(
      data: (movies) => MovieGridWidget(
        movies: movies,
        onMovieTap: onMovieTap,
        onLoadMore: () =>
            ref.read(popularMoviesProvider.notifier).loadNextPage(),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFE50914)),
      ),
      error: (e, _) => ErrorStateWidget(
        message: e.toString(),
        onRetry: () => ref.read(popularMoviesProvider.notifier).refresh(),
      ),
    );
  }
}
