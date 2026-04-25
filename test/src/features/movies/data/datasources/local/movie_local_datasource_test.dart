import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:flutter_challenge_pinapp/src/core/utils/constants.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/data/datasources/local/movie_local_datasource.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_model.dart';

import '../../../../../../helpers/fixtures/movie_fixtures.dart';
import '../../../../../../helpers/hive_test_setup.dart';

void main() {
  late Box<MovieModel> popularBox;
  late Box<MovieModel> trendingBox;
  late MovieLocalDatasourceImpl datasource;

  setUp(() async {
    await setUpHive();
    popularBox = await Hive.openBox<MovieModel>(HiveBoxNames.popularMovies);
    trendingBox = await Hive.openBox<MovieModel>(HiveBoxNames.trendingMovies);
    datasource = MovieLocalDatasourceImpl(
      popularBox: popularBox,
      trendingBox: trendingBox,
    );
  });

  tearDown(() async {
    await tearDownHive();
  });

  group('Popular box', () {
    test('returns empty list when box is empty', () {
      expect(datasource.getCachedPopularMovies(), isEmpty);
    });

    test('cache then read returns the same set', () async {
      await datasource.cachePopularMovies(tMovieList);
      final cached = datasource.getCachedPopularMovies();
      expect(cached.length, 2);
      expect(cached.first.id, tMovieModel.id);
    });

    test('cache replaces existing data (clear + addAll)', () async {
      await datasource.cachePopularMovies(tMovieList);
      await datasource.cachePopularMovies([tMovieModel]);
      final cached = datasource.getCachedPopularMovies();
      expect(cached.length, 1);
      expect(cached.first.id, tMovieModel.id);
    });
  });

  group('Trending box', () {
    test('returns empty list when box is empty', () {
      expect(datasource.getCachedTrendingMovies(), isEmpty);
    });

    test('cache then read returns the same set', () async {
      await datasource.cacheTrendingMovies(tMovieList);
      final cached = datasource.getCachedTrendingMovies();
      expect(cached.length, 2);
    });

    test('cache replaces existing data', () async {
      await datasource.cacheTrendingMovies(tMovieList);
      await datasource.cacheTrendingMovies([tMovieModelAlt]);
      final cached = datasource.getCachedTrendingMovies();
      expect(cached.length, 1);
      expect(cached.first.id, tMovieModelAlt.id);
    });
  });
}
