// SRP: This class is solely responsible for coordinating between the remote
// API and the local Hive cache. It decides when to use each source.
// DIP: Depends on the [MovieLocalDatasource] and [NetworkInfo] abstractions,
// never on Hive or Dio directly.
// OCP: New data sources can be added (e.g., SQLite) by injecting a new
// datasource without modifying this implementation.
import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';
import 'package:flutter_challenge_pinapp/src/core/network/dio_client.dart';
import 'package:flutter_challenge_pinapp/src/core/network/network_info.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/data/datasources/local/movie_local_datasource.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/domain/repositories/movie_repository.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_detail_model.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_model.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/tmdb_paginated_response_model.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_detail_entity.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

class MovieRepositoryImpl implements MovieRepository {
  final NetworkInfo _networkInfo;
  final MovieLocalDatasource _localDatasource;
  final Dio _dio;

  MovieRepositoryImpl({
    required NetworkInfo networkInfo,
    required MovieLocalDatasource localDatasource,
    Dio? dio,
  })  : _networkInfo = networkInfo,
        _localDatasource = localDatasource,
        _dio = dio ?? DioClient.instance;

  // ── Popular Movies ─────────────────────────────────────────────────────────

  @override
  Future<Result<List<MovieEntity>, Exception>> getPopularMovies({
    int page = 1,
  }) async {
    if (!await _networkInfo.isConnected) {
      // Offline-first: surface cached data gracefully.
      final cached = _localDatasource.getCachedPopularMovies();
      return Ok(cached);
    }

    return _fetchAndCache(
      remoteFetch: () => _dio.get('/movie/popular', queryParameters: {'page': page}),
      fromJson: (json) => TmdbPaginatedResponseModel.fromJson(json).results,
      cacheWriter: (movies) => _localDatasource.cachePopularMovies(movies),
      fallbackCache: () => _localDatasource.getCachedPopularMovies(),
    );
  }

  // ── Trending Movies ────────────────────────────────────────────────────────

  @override
  Future<Result<List<MovieEntity>, Exception>> getTrendingMovies({
    int page = 1,
  }) async {
    if (!await _networkInfo.isConnected) {
      final cached = _localDatasource.getCachedTrendingMovies();
      return Ok(cached);
    }

    return _fetchAndCache(
      remoteFetch: () =>
          _dio.get('/trending/movie/week', queryParameters: {'page': page}),
      fromJson: (json) => TmdbPaginatedResponseModel.fromJson(json).results,
      cacheWriter: (movies) => _localDatasource.cacheTrendingMovies(movies),
      fallbackCache: () => _localDatasource.getCachedTrendingMovies(),
    );
  }

  // ── Movie Detail ───────────────────────────────────────────────────────────

  @override
  Future<Result<MovieDetailEntity, Exception>> getMovieDetail(int id) async {
    try {
      final response = await _dio.get('/movie/$id');
      final detail = MovieDetailModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Ok(detail);
    } on DioException catch (e) {
      return Err(Exception(e.message));
    } catch (e) {
      return Err(Exception(e.toString()));
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  @override
  Future<Result<List<MovieEntity>, Exception>> searchMovies(
    String query, {
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {'query': query, 'page': page},
      );
      final results =
          TmdbPaginatedResponseModel.fromJson(response.data as Map<String, dynamic>)
              .results;
      return Ok(results);
    } on DioException catch (e) {
      return Err(Exception(e.message));
    } catch (e) {
      return Err(Exception(e.toString()));
    }
  }

  // ── Private helper ─────────────────────────────────────────────────────────
  // Encapsulates the common fetch → deserialise → cache → return pattern.

  Future<Result<List<MovieEntity>, Exception>> _fetchAndCache({
    required Future<Response<dynamic>> Function() remoteFetch,
    required List<MovieModel> Function(Map<String, dynamic>) fromJson,
    required Future<void> Function(List<MovieModel>) cacheWriter,
    required List<MovieModel> Function() fallbackCache,
  }) async {
    try {
      final response = await remoteFetch();
      final movies = fromJson(response.data as Map<String, dynamic>);
      await cacheWriter(movies);
      return Ok(movies);
    } on DioException catch (e) {
      // Network error after connectivity check — serve stale cache.
      final cached = fallbackCache();
      if (cached.isNotEmpty) return Ok(cached);
      return Err(Exception(e.message));
    } catch (e) {
      return Err(Exception(e.toString()));
    }
  }
}
