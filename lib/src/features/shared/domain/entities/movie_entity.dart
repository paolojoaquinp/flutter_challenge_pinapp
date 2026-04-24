// SRP: This entity is solely responsible for representing the core movie
// data contract in the domain layer. No Hive, JSON, or Flutter imports.
// It is intentionally framework-agnostic (pure Dart).

/// Domain entity representing a movie list item.
class MovieEntity {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<int> genreIds;
  final double popularity;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genreIds,
    required this.popularity,
  });
}
