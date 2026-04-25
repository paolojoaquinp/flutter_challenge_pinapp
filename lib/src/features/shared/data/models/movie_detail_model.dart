// SRP: This model is solely responsible for JSON deserialization of the
// TMDB movie detail endpoint response.
// OCP: Extends MovieDetailEntity — adding serialisation without modifying the entity.
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/genre_entity.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_detail_entity.dart';

/// Data model for TMDB /movie/{id} response.
class MovieDetailModel extends MovieDetailEntity {
  const MovieDetailModel({
    required super.id,
    required super.title,
    required super.tagline,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.voteCount,
    required super.releaseDate,
    required super.runtime,
    required super.status,
    required super.popularity,
    required super.genres,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    final genreList = (json['genres'] as List<dynamic>? ?? [])
        .map(
          (g) => GenreEntity(
            id: g['id'] as int,
            name: (g['name'] as String?) ?? '',
          ),
        )
        .toList();

    return MovieDetailModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      tagline: (json['tagline'] as String?) ?? '',
      overview: (json['overview'] as String?) ?? '',
      posterPath: (json['poster_path'] as String?) ?? '',
      backdropPath: (json['backdrop_path'] as String?) ?? '',
      voteAverage: ((json['vote_average'] as num?) ?? 0).toDouble(),
      voteCount: (json['vote_count'] as int?) ?? 0,
      releaseDate: (json['release_date'] as String?) ?? '',
      runtime: (json['runtime'] as int?) ?? 0,
      status: (json['status'] as String?) ?? '',
      popularity: ((json['popularity'] as num?) ?? 0).toDouble(),
      genres: genreList,
    );
  }
}
