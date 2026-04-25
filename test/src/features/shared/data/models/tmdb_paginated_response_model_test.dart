import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_model.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/tmdb_paginated_response_model.dart';

import '../../../../../helpers/fixtures/tmdb_response_fixtures.dart';

void main() {
  group('TmdbPaginatedResponseModel', () {
    test('fromJson parses page metadata and results', () {
      final result = TmdbPaginatedResponseModel.fromJson(tPaginatedJson);
      expect(result.page, 1);
      expect(result.totalPages, 5);
      expect(result.totalResults, 100);
      expect(result.results, isA<List<MovieModel>>());
      expect(result.results.length, 2);
      expect(result.results.first.id, 101);
    });

    test('fromJson handles empty results', () {
      final result = TmdbPaginatedResponseModel.fromJson(tEmptyPaginatedJson);
      expect(result.results, isEmpty);
      expect(result.totalResults, 0);
    });

    test('fromJson defaults missing fields', () {
      final result = TmdbPaginatedResponseModel.fromJson(<String, dynamic>{});
      expect(result.page, 1);
      expect(result.totalPages, 1);
      expect(result.totalResults, 0);
      expect(result.results, isEmpty);
    });
  });
}
