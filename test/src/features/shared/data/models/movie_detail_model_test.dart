import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_detail_model.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/genre_entity.dart';

import '../../../../../helpers/fixtures/movie_detail_fixtures.dart';

void main() {
  group('MovieDetailModel', () {
    test('fromJson returns a valid model with genres', () {
      final result = MovieDetailModel.fromJson(tMovieDetailJson);
      expect(result, isA<MovieDetailModel>());
      expect(result.id, 550);
      expect(result.title, 'Fight Club');
      expect(result.tagline, 'Mischief. Mayhem. Soap.');
      expect(result.runtime, 139);
      expect(result.status, 'Released');
      expect(result.popularity, 75.5);
      expect(result.genres.length, 2);
      expect(result.genres.first, const GenreEntity(id: 18, name: 'Drama'));
    });

    test('fromJson defaults missing optional fields', () {
      final result = MovieDetailModel.fromJson(<String, dynamic>{'id': 1});
      expect(result.id, 1);
      expect(result.title, '');
      expect(result.tagline, '');
      expect(result.overview, '');
      expect(result.posterPath, '');
      expect(result.backdropPath, '');
      expect(result.voteAverage, 0);
      expect(result.voteCount, 0);
      expect(result.releaseDate, '');
      expect(result.runtime, 0);
      expect(result.status, '');
      expect(result.popularity, 0);
      expect(result.genres, isEmpty);
    });

    test('fromJson handles genres with null name', () {
      final json = <String, dynamic>{
        'id': 1,
        'genres': <Map<String, dynamic>>[
          {'id': 99, 'name': null},
        ],
      };
      final result = MovieDetailModel.fromJson(json);
      expect(result.genres.first.id, 99);
      expect(result.genres.first.name, '');
    });

    test('supports value equality', () {
      final a = MovieDetailModel.fromJson(tMovieDetailJson);
      final b = MovieDetailModel.fromJson(tMovieDetailJson);
      expect(a, equals(b));
      expect(a, equals(tMovieDetailModel));
    });
  });
}
