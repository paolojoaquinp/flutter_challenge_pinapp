// SRP: This entity is solely responsible for representing a genre in the
// domain layer. Pure Dart — no framework imports.

/// Domain entity representing a TMDB movie genre.
class GenreEntity {
  final int id;
  final String name;

  const GenreEntity({required this.id, required this.name});
}
