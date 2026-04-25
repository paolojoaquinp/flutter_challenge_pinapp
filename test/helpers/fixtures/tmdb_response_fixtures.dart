import 'movie_fixtures.dart';

final tPaginatedJson = <String, dynamic>{
  'page': 1,
  'results': <Map<String, dynamic>>[tMovieJson, tMovieJsonAlt],
  'total_pages': 5,
  'total_results': 100,
};

final tEmptyPaginatedJson = <String, dynamic>{
  'page': 1,
  'results': <Map<String, dynamic>>[],
  'total_pages': 1,
  'total_results': 0,
};
