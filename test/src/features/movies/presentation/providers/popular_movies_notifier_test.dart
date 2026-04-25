import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oxidized/oxidized.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/repository_providers.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

import '../../../../../helpers/fixtures/movie_fixtures.dart';
import '../../../../../helpers/mocks.dart';

ProviderContainer _container(MockMovieRepository repo) {
  final container = ProviderContainer(
    overrides: [
      movieRepositoryProvider.overrideWith((ref) async => repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late MockMovieRepository repo;

  setUp(() {
    repo = MockMovieRepository();
  });

  group('PopularMoviesNotifier.build', () {
    test('emits AsyncData with page 1 on success', () async {
      when(() => repo.getPopularMovies(page: 1)).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.ok(tMovieList),
      );
      final container = _container(repo);

      final result = await container.read(popularMoviesProvider.future);

      expect(result, tMovieList);
      verify(() => repo.getPopularMovies(page: 1)).called(1);
    });

    test('emits AsyncError when repository returns Err', () async {
      when(() => repo.getPopularMovies(page: 1)).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.err(Exception('boom')),
      );
      final container = _container(repo);

      await expectLater(
        container.read(popularMoviesProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('PopularMoviesNotifier.loadNextPage', () {
    test('appends next page results to current state', () async {
      when(() => repo.getPopularMovies(page: 1)).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.ok([tMovieModel]),
      );
      when(() => repo.getPopularMovies(page: 2)).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.ok([tMovieModelAlt]),
      );
      final container = _container(repo);
      await container.read(popularMoviesProvider.future);

      await container.read(popularMoviesProvider.notifier).loadNextPage();

      final state = container.read(popularMoviesProvider).value!;
      expect(state.length, 2);
      expect(state[0], tMovieModel);
      expect(state[1], tMovieModelAlt);
    });

    test('does nothing when state has no current value', () async {
      when(() => repo.getPopularMovies(page: 1)).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.err(Exception('boom')),
      );
      final container = _container(repo);
      await expectLater(
        container.read(popularMoviesProvider.future),
        throwsA(isA<Exception>()),
      );

      await container.read(popularMoviesProvider.notifier).loadNextPage();

      verifyNever(() => repo.getPopularMovies(page: 2));
    });
  });

  group('PopularMoviesNotifier.refresh', () {
    test('resets current page and re-fetches page 1', () async {
      when(() => repo.getPopularMovies(page: 1)).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.ok([tMovieModel]),
      );
      when(() => repo.getPopularMovies(page: 2)).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.ok([tMovieModelAlt]),
      );
      final container = _container(repo);
      await container.read(popularMoviesProvider.future);
      await container.read(popularMoviesProvider.notifier).loadNextPage();

      await container.read(popularMoviesProvider.notifier).refresh();

      final state = container.read(popularMoviesProvider).value!;
      expect(state.length, 1);
      expect(state.first, tMovieModel);
      verify(() => repo.getPopularMovies(page: 1)).called(2);
    });
  });
}
