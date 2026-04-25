// SRP: This entity is solely responsible for representing a genre in the
// domain layer. Pure Dart — no framework imports.
import 'package:equatable/equatable.dart';

/// Domain entity representing a TMDB movie genre.
class GenreEntity extends Equatable {
  final int id;
  final String name;

  const GenreEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
