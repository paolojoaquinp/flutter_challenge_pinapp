// SRP: This notifier is solely responsible for search query state and results.
// Debounce is applied to avoid hammering the API on each keypress.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/repository_providers.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

class MovieSearchNotifier extends AsyncNotifier<List<MovieEntity>> {
  String _query = '';

  @override
  Future<List<MovieEntity>> build() async => [];

  Future<void> search(String query) async {
    _query = query.trim();
    if (_query.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Debounce: wait 350ms before issuing the API call.
      await Future<void>.delayed(const Duration(milliseconds: 350));
      final repo = await ref.read(movieRepositoryProvider.future);
      final result = await repo.searchMovies(_query);
      return result.when(ok: (m) => m, err: (e) => throw e);
    });
  }

  void clearSearch() {
    _query = '';
    state = const AsyncData([]);
  }
}

final movieSearchProvider =
    AsyncNotifierProvider<MovieSearchNotifier, List<MovieEntity>>(
      MovieSearchNotifier.new,
    );
