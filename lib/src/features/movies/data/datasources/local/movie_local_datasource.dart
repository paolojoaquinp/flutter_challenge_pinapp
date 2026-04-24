// SRP: This class is solely responsible for reading from and writing to
// Hive boxes. No network logic lives here. The Hive box is injected so
// this class can be unit-tested with a test box.
import 'package:hive/hive.dart';
import 'package:flutter_challenge_pinapp/src/core/utils/constants.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_model.dart';
// TODO: split in 2 files
/// Local persistence interface for movie collections.
// DIP: Higher layers depend on this abstraction, not on the Hive box directly.
abstract class MovieLocalDatasource {
  /// Returns the cached popular movies, or an empty list if none exist.
  List<MovieModel> getCachedPopularMovies();

  /// Persists [movies] into the popular movies box, replacing existing data.
  Future<void> cachePopularMovies(List<MovieModel> movies);

  /// Returns the cached trending movies, or an empty list if none exist.
  List<MovieModel> getCachedTrendingMovies();

  /// Persists [movies] into the trending movies box, replacing existing data.
  Future<void> cacheTrendingMovies(List<MovieModel> movies);
}

/// Concrete Hive-backed implementation of [MovieLocalDatasource].
class MovieLocalDatasourceImpl implements MovieLocalDatasource {
  final Box<MovieModel> _popularBox;
  final Box<MovieModel> _trendingBox;

  const MovieLocalDatasourceImpl({
    required Box<MovieModel> popularBox,
    required Box<MovieModel> trendingBox,
  })  : _popularBox = popularBox,
        _trendingBox = trendingBox;

  // ── Factory — opens the Hive boxes that are required by this datasource. ──
  // ADR-004: Hive is exclusively the store for heavy collections.
  static Future<MovieLocalDatasourceImpl> openBoxes() async {
    final popularBox = await Hive.openBox<MovieModel>(HiveBoxNames.popularMovies);
    final trendingBox =
        await Hive.openBox<MovieModel>(HiveBoxNames.trendingMovies);
    return MovieLocalDatasourceImpl(
      popularBox: popularBox,
      trendingBox: trendingBox,
    );
  }

  @override
  List<MovieModel> getCachedPopularMovies() => _popularBox.values.toList();

  @override
  Future<void> cachePopularMovies(List<MovieModel> movies) async {
    await _popularBox.clear();
    await _popularBox.addAll(movies);
  }

  @override
  List<MovieModel> getCachedTrendingMovies() => _trendingBox.values.toList();

  @override
  Future<void> cacheTrendingMovies(List<MovieModel> movies) async {
    await _trendingBox.clear();
    await _trendingBox.addAll(movies);
  }
}
