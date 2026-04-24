// SRP: This widget is solely responsible for rendering a responsive grid
// of movie cards with an optional footer loader for pagination.
import 'package:flutter/material.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/widgets/movie_card_widget.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

class MovieGridWidget extends StatelessWidget {
  final List<MovieEntity> movies;
  final bool isLoadingMore;
  final Future<void> Function()? onLoadMore;
  final void Function(MovieEntity)? onMovieTap;

  const MovieGridWidget({
    super.key,
    required this.movies,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            onLoadMore != null) {
          onLoadMore!();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: movies.length + (isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= movies.length) {
            return _SkeletonCard();
          }
          final movie = movies[index];
          return MovieCardWidget(
            movie: movie,
            onTap: () => onMovieTap?.call(movie),
          );
        },
      ),
    );
  }
}

// TODO: review skeleton add shimmer instead
/// Skeleton loading card shown while the next page loads.
class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1E1E1E),
      ),
    );
  }
}
