// SRP: This model is solely responsible for JSON deserialization and Hive persistence.
// It extends MovieEntity to keep the domain contract stable (OCP).
// The TypeAdapter is hand-written — no code-gen required — to avoid
// the riverpod_generator / hive_generator source_gen conflict.
import 'package:hive/hive.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

// Hive typeId values must be globally unique across the entire app.
const _kMovieModelTypeId = 0;

/// Data model for a TMDB movie list item.
/// Extends [MovieEntity] so the domain layer receives typed objects.
class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.voteCount,
    required super.releaseDate,
    required super.genreIds,
    required super.popularity,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // Validate that 'id' is present — this is the TMDB contract.
    assert(json.containsKey('id'), 'TMDB movie response missing "id" field');
    return MovieModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      overview: (json['overview'] as String?) ?? '',
      posterPath: (json['poster_path'] as String?) ?? '',
      backdropPath: (json['backdrop_path'] as String?) ?? '',
      voteAverage: ((json['vote_average'] as num?) ?? 0).toDouble(),
      voteCount: (json['vote_count'] as int?) ?? 0,
      releaseDate: (json['release_date'] as String?) ?? '',
      genreIds: ((json['genre_ids'] as List<dynamic>?) ?? [])
          .map((e) => e as int)
          .toList(),
      popularity: ((json['popularity'] as num?) ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'overview': overview,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'release_date': releaseDate,
        'genre_ids': genreIds,
        'popularity': popularity,
      };

  MovieModel copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    int? voteCount,
    String? releaseDate,
    List<int>? genreIds,
    double? popularity,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      releaseDate: releaseDate ?? this.releaseDate,
      genreIds: genreIds ?? this.genreIds,
      popularity: popularity ?? this.popularity,
    );
  }
}

// ── Manual Hive TypeAdapter ────────────────────────────────────────────────
// DIP: The adapter depends on the abstract HiveAdapter contract, not on
// a generated class — keeping the Hive dependency isolated.
// TODO: review usability of adapter, research
class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = _kMovieModelTypeId;

  @override
  MovieModel read(BinaryReader reader) {
    return MovieModel(
      id: reader.readInt(),
      title: reader.readString(),
      overview: reader.readString(),
      posterPath: reader.readString(),
      backdropPath: reader.readString(),
      voteAverage: reader.readDouble(),
      voteCount: reader.readInt(),
      releaseDate: reader.readString(),
      genreIds: (reader.readList()).cast<int>(),
      popularity: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeInt(obj.id)
      ..writeString(obj.title)
      ..writeString(obj.overview)
      ..writeString(obj.posterPath)
      ..writeString(obj.backdropPath)
      ..writeDouble(obj.voteAverage)
      ..writeInt(obj.voteCount)
      ..writeString(obj.releaseDate)
      ..writeList(obj.genreIds)
      ..writeDouble(obj.popularity);
  }
}
