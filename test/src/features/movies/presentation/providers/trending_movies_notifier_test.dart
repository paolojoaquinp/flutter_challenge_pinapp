import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oxidized/oxidized.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/repository_providers.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/trending_movies_notifier.dart';
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

  group('TrendingMoviesNotifier.build', () {
    test('emits AsyncData with movies on success', () async {
      when(() => repo.getTrendingMovies()).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.ok(tMovieList),
      );
      final container = _container(repo);

      final result = await container.read(trendingMoviesProvider.future);

      expect(result, tMovieList);
      expect(container.read(trendingMoviesProvider).value, tMovieList);
    });

    test('emits AsyncError when repository returns Err', () async {
      when(() => repo.getTrendingMovies()).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.err(Exception('boom')),
      );
      final container = _container(repo);

      await expectLater(
        container.read(trendingMoviesProvider.future),
        throwsA(isA<Exception>()),
      );
      expect(container.read(trendingMoviesProvider), isA<AsyncError>());
    });
  });

  group('TrendingMoviesNotifier.refresh', () {
    test('reloads data and ends in AsyncData', () async {
      when(() => repo.getTrendingMovies()).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.ok(tMovieList),
      );
      final container = _container(repo);
      await container.read(trendingMoviesProvider.future);

      await container.read(trendingMoviesProvider.notifier).refresh();

      expect(container.read(trendingMoviesProvider).value, tMovieList);
      verify(() => repo.getTrendingMovies()).called(2);
    });
  });
}
