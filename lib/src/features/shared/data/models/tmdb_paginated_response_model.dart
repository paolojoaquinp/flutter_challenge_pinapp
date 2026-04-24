// SRP: This model is solely responsible for wrapping the TMDB paginated
// list response envelope (results, page, total_pages, total_results).
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_model.dart';

/// Generic paginated response wrapper for TMDB list endpoints.
// TODO: split in entity layer
class TmdbPaginatedResponseModel {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  const TmdbPaginatedResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TmdbPaginatedResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResults = (json['results'] as List<dynamic>?) ?? [];
    return TmdbPaginatedResponseModel(
      page: (json['page'] as int?) ?? 1,
      results: rawResults
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as int?) ?? 1,
      totalResults: (json['total_results'] as int?) ?? 0,
    );
  }
}
