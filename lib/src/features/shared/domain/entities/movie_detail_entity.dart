// SRP: This entity is solely responsible for representing the extended
// movie detail data in the domain layer. Pure Dart — no framework deps.
import 'package:equatable/equatable.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/genre_entity.dart';

/// Domain entity representing full movie details fetched from the detail endpoint.
class MovieDetailEntity extends Equatable {
  final int id;
  final String title;
  final String tagline;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final int runtime;
  final String status;
  final double popularity;
  final List<GenreEntity> genres;

  const MovieDetailEntity({
    required this.id,
    required this.title,
    required this.tagline,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.runtime,
    required this.status,
    required this.popularity,
    required this.genres,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    tagline,
    overview,
    posterPath,
    backdropPath,
    voteAverage,
    voteCount,
    releaseDate,
    runtime,
    status,
    popularity,
    genres,
  ];
}
