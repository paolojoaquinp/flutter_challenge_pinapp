import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oxidized/oxidized.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/movie_search_notifier.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/providers/repository_providers.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

import '../../../../../helpers/fixtures/movie_fixtures.dart';
import '../../../../../helpers/mocks.dart';

const _debounceWait = Duration(milliseconds: 450);

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

  group('MovieSearchNotifier.build', () {
    test('initial state is empty AsyncData', () async {
      final container = _container(repo);
      final result = await container.read(movieSearchProvider.future);
      expect(result, isEmpty);
    });
  });

  group('MovieSearchNotifier.search', () {
    test('empty query resets to AsyncData([]) without calling repo', () async {
      final container = _container(repo);
      await container.read(movieSearchProvider.future);

      await container.read(movieSearchProvider.notifier).search('   ');

      expect(container.read(movieSearchProvider).value, isEmpty);
      verifyNever(() => repo.searchMovies(any()));
    });

    test('non-empty query returns results after debounce', () async {
      when(() => repo.searchMovies('fight')).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.ok(tMovieList),
      );
      final container = _container(repo);
      await container.read(movieSearchProvider.future);

      await container.read(movieSearchProvider.notifier).search('fight');
      await Future<void>.delayed(_debounceWait);

      expect(container.read(movieSearchProvider).value, tMovieList);
      verify(() => repo.searchMovies('fight')).called(1);
    });

    test('emits AsyncError when repository returns Err', () async {
      when(() => repo.searchMovies('boom')).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.err(Exception('x')),
      );
      final container = _container(repo);
      await container.read(movieSearchProvider.future);

      await container.read(movieSearchProvider.notifier).search('boom');
      await Future<void>.delayed(_debounceWait);

      expect(container.read(movieSearchProvider), isA<AsyncError>());
    });
  });

  group('MovieSearchNotifier.clearSearch', () {
    test('resets state to AsyncData([])', () async {
      when(() => repo.searchMovies(any())).thenAnswer(
        (_) async => Result<List<MovieEntity>, Exception>.ok(tMovieList),
      );
      final container = _container(repo);
      await container.read(movieSearchProvider.future);
      await container.read(movieSearchProvider.notifier).search('fight');
      await Future<void>.delayed(_debounceWait);

      container.read(movieSearchProvider.notifier).clearSearch();

      expect(container.read(movieSearchProvider).value, isEmpty);
    });
  });
}
