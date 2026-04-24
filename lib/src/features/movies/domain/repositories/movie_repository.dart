// DIP (Dependency Inversion): High-level modules (Notifiers, use-cases) depend
// on this abstract interface — never on the concrete MovieRepositoryImpl.
// OCP: New data sources (e.g., a GraphQL layer) can be added by creating a new
// implementation without modifying this contract.
import 'package:oxidized/oxidized.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_detail_entity.dart';

/// Domain contract for all movie-related data operations.
///
/// Returns [Result<T, Exception>] so callers handle errors explicitly —
/// no unchecked exceptions propagate into the UI layer.
abstract class MovieRepository {
  /// Fetches the popular movies list.
  /// Falls back to cached data when the device is offline (ADR-002).
  Future<Result<List<MovieEntity>, Exception>> getPopularMovies({int page = 1});

  /// Fetches the currently trending movies (week window).
  /// Falls back to cached data when offline.
  Future<Result<List<MovieEntity>, Exception>> getTrendingMovies({int page = 1});

  /// Fetches the full detail for a single movie by [id].
  Future<Result<MovieDetailEntity, Exception>> getMovieDetail(int id);

  /// Searches movies by [query] string.
  Future<Result<List<MovieEntity>, Exception>> searchMovies(String query, {int page = 1});
}
