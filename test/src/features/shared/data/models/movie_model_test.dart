import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_model.dart';

import '../../../../../helpers/fixtures/movie_fixtures.dart';

void main() {
  group('MovieModel', () {
    test('fromJson returns a valid model', () {
      final result = MovieModel.fromJson(tMovieJson);
      expect(result, isA<MovieModel>());
      expect(result.id, 101);
      expect(result.title, 'Mock Movie 1');
      expect(result.overview, 'A test movie overview.');
      expect(result.posterPath, '/poster1.jpg');
      expect(result.backdropPath, '/backdrop1.jpg');
      expect(result.voteAverage, 7.5);
      expect(result.voteCount, 1200);
      expect(result.releaseDate, '2024-01-15');
      expect(result.genreIds, [28, 12]);
      expect(result.popularity, 99.9);
    });

    test('fromJson defaults missing optional fields', () {
      final result = MovieModel.fromJson(<String, dynamic>{'id': 9});
      expect(result.id, 9);
      expect(result.title, '');
      expect(result.overview, '');
      expect(result.posterPath, '');
      expect(result.backdropPath, '');
      expect(result.voteAverage, 0);
      expect(result.voteCount, 0);
      expect(result.releaseDate, '');
      expect(result.genreIds, isEmpty);
      expect(result.popularity, 0);
    });

    test('toJson returns the proper map', () {
      final json = tMovieModel.toJson();
      expect(json, tMovieJson);
    });

    test('copyWith returns updated instance', () {
      final updated = tMovieModel.copyWith(title: 'New Title', voteAverage: 9);
      expect(updated.title, 'New Title');
      expect(updated.voteAverage, 9);
      expect(updated.id, tMovieModel.id);
      expect(updated.overview, tMovieModel.overview);
    });

    test('copyWith with no args returns equal copy', () {
      final updated = tMovieModel.copyWith();
      expect(updated, equals(tMovieModel));
    });

    test('supports value equality (via Equatable)', () {
      final a = MovieModel.fromJson(tMovieJson);
      final b = MovieModel.fromJson(tMovieJson);
      expect(a, equals(b));
    });
  });
}
