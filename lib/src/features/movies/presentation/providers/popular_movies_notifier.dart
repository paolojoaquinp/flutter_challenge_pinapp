// SRP: This notifier is solely responsible for the popular movies list state.
// It holds page state for pagination and delegates fetching to the repository.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/repository_providers.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

class PopularMoviesNotifier extends AsyncNotifier<List<MovieEntity>> {
  int _currentPage = 1;

  @override
  Future<List<MovieEntity>> build() async => _fetchPage(page: 1);

  Future<List<MovieEntity>> _fetchPage({required int page}) async {
    final repoAsync = await ref.read(movieRepositoryProvider.future);
    final result = await repoAsync.getPopularMovies(page: page);
    return result.when(
      ok: (movies) => movies,
      err: (e) => throw e,
    );
  }

  Future<void> refresh() async {
    _currentPage = 1;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(page: 1));
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null) return;
    _currentPage++;
    final next = await AsyncValue.guard(() => _fetchPage(page: _currentPage));
    state = next.whenData((movies) => [...current, ...movies]);
  }
}

final popularMoviesProvider =
    AsyncNotifierProvider<PopularMoviesNotifier, List<MovieEntity>>(
  PopularMoviesNotifier.new,
);
