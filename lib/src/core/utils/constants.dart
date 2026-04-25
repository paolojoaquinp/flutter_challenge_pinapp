// SRP: This class is solely responsible for grouping compile-time constants
// sourced from environment configuration. No logic lives here.
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// TMDB API v3 base URL.
String get kTmdbBaseUrl =>
    dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';

/// TMDB image CDN base URL (w500 quality).
String get kTmdbImageBaseUrl =>
    dotenv.env['TMDB_IMAGE_BASE_URL'] ?? 'https://image.tmdb.org/t/p/w500';

/// TMDB API Read Access Token (Bearer).
/// Never log or expose this value outside of the AuthInterceptor.
String get kTmdbReadAccessToken => dotenv.env['TMDB_READ_ACCESS_TOKEN'] ?? '';

/// Hive box names — centralised to avoid magic strings.
// TODO: split hive class
class HiveBoxNames {
  // SRP: Constants class groups all Hive box identifiers.
  HiveBoxNames._();
  static const String popularMovies = 'popular_movies';
  static const String trendingMovies = 'trending_movies';
}
