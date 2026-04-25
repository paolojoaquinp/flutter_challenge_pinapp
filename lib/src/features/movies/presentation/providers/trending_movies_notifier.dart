// SRP: This notifier is solely responsible for the trending movies list state.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/repository_providers.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

// TODO: review provider focus
class TrendingMoviesNotifier extends AsyncNotifier<List<MovieEntity>> {
  @override
  Future<List<MovieEntity>> build() async {
    final repo = await ref.read(movieRepositoryProvider.future);
    final result = await repo.getTrendingMovies();
    return result.when(ok: (movies) => movies, err: (e) => throw e);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(movieRepositoryProvider.future);
      final result = await repo.getTrendingMovies();
      return result.when(ok: (m) => m, err: (e) => throw e);
    });
  }
}

final trendingMoviesProvider =
    AsyncNotifierProvider<TrendingMoviesNotifier, List<MovieEntity>>(
      TrendingMoviesNotifier.new,
    );
