import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/data/datasources/api/movie_repository_impl.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_model.dart';

import '../../../../../../helpers/fixtures/movie_detail_fixtures.dart';
import '../../../../../../helpers/fixtures/movie_fixtures.dart';
import '../../../../../../helpers/fixtures/tmdb_response_fixtures.dart';
import '../../../../../../helpers/mocks.dart';

Response<dynamic> _ok(Object? data, String path) => Response<dynamic>(
  requestOptions: RequestOptions(path: path),
  data: data,
  statusCode: 200,
);

DioException _dioErr(String path, [String message = 'boom']) => DioException(
  requestOptions: RequestOptions(path: path),
  message: message,
);

void main() {
  late MockNetworkInfo networkInfo;
  late MockMovieLocalDatasource localDatasource;
  late MockDio dio;
  late MovieRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(<MovieModel>[]);
  });

  setUp(() {
    networkInfo = MockNetworkInfo();
    localDatasource = MockMovieLocalDatasource();
    dio = MockDio();
    repository = MovieRepositoryImpl(
      networkInfo: networkInfo,
      localDatasource: localDatasource,
      dio: dio,
    );
  });

  group('getPopularMovies', () {
    const path = '/movie/popular';

    test('returns cached movies when offline', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => localDatasource.getCachedPopularMovies()).thenReturn(tMovieList);

      final result = await repository.getPopularMovies();

      expect(result.isOk(), isTrue);
      expect(result.unwrap(), tMovieList);
      verifyNever(() => dio.get(any(), queryParameters: any(named: 'queryParameters')));
    });

    test('fetches and caches when online', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => dio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _ok(tPaginatedJson, path));
      when(
        () => localDatasource.cachePopularMovies(any()),
      ).thenAnswer((_) async {});

      final result = await repository.getPopularMovies(page: 2);

      expect(result.isOk(), isTrue);
      expect(result.unwrap().length, 2);
      verify(() => localDatasource.cachePopularMovies(any())).called(1);
    });

    test('falls back to cache on DioException when cache is non-empty', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => dio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenThrow(_dioErr(path));
      when(() => localDatasource.getCachedPopularMovies()).thenReturn(tMovieList);

      final result = await repository.getPopularMovies();

      expect(result.isOk(), isTrue);
      expect(result.unwrap(), tMovieList);
    });

    test('returns Err on DioException when cache is empty', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => dio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenThrow(_dioErr(path, 'no internet'));
      when(() => localDatasource.getCachedPopularMovies()).thenReturn([]);

      final result = await repository.getPopularMovies();

      expect(result.isErr(), isTrue);
    });

    test('returns Err on generic exception', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => dio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenThrow(StateError('unexpected'));

      final result = await repository.getPopularMovies();

      expect(result.isErr(), isTrue);
    });
  });

  group('getTrendingMovies', () {
    const path = '/trending/movie/week';

    test('returns cached movies when offline', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => localDatasource.getCachedTrendingMovies()).thenReturn(tMovieList);

      final result = await repository.getTrendingMovies();

      expect(result.isOk(), isTrue);
      expect(result.unwrap(), tMovieList);
    });

    test('fetches and caches when online', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => dio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _ok(tPaginatedJson, path));
      when(
        () => localDatasource.cacheTrendingMovies(any()),
      ).thenAnswer((_) async {});

      final result = await repository.getTrendingMovies();

      expect(result.isOk(), isTrue);
      expect(result.unwrap().length, 2);
      verify(() => localDatasource.cacheTrendingMovies(any())).called(1);
    });

    test('falls back to cache on DioException with non-empty cache', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => dio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenThrow(_dioErr(path));
      when(() => localDatasource.getCachedTrendingMovies()).thenReturn(tMovieList);

      final result = await repository.getTrendingMovies();

      expect(result.isOk(), isTrue);
    });

    test('returns Err on DioException with empty cache', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => dio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenThrow(_dioErr(path));
      when(() => localDatasource.getCachedTrendingMovies()).thenReturn([]);

      final result = await repository.getTrendingMovies();

      expect(result.isErr(), isTrue);
    });
  });

  group('getMovieDetail', () {
    const id = 550;
    const path = '/movie/550';

    test('returns Ok on 200 response', () async {
      when(() => dio.get(path)).thenAnswer((_) async => _ok(tMovieDetailJson, path));

      final result = await repository.getMovieDetail(id);

      expect(result.isOk(), isTrue);
      expect(result.unwrap().id, 550);
      expect(result.unwrap().title, 'Fight Club');
    });

    test('returns Err on DioException', () async {
      when(() => dio.get(path)).thenThrow(_dioErr(path));

      final result = await repository.getMovieDetail(id);

      expect(result.isErr(), isTrue);
    });

    test('returns Err on generic exception', () async {
      when(() => dio.get(path)).thenThrow(StateError('boom'));

      final result = await repository.getMovieDetail(id);

      expect(result.isErr(), isTrue);
    });
  });

  group('searchMovies', () {
    const path = '/search/movie';

    test('returns Ok on 200 response', () async {
      when(
        () => dio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _ok(tPaginatedJson, path));

      final result = await repository.searchMovies('fight');

      expect(result.isOk(), isTrue);
      expect(result.unwrap().length, 2);
    });

    test('returns Err on DioException', () async {
      when(
        () => dio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenThrow(_dioErr(path));

      final result = await repository.searchMovies('fight');

      expect(result.isErr(), isTrue);
    });

    test('returns Err on generic exception', () async {
      when(
        () => dio.get(path, queryParameters: any(named: 'queryParameters')),
      ).thenThrow(StateError('boom'));

      final result = await repository.searchMovies('fight');

      expect(result.isErr(), isTrue);
    });
  });
}
