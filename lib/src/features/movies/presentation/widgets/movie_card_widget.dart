// SRP: This widget is solely responsible for rendering a single movie card.
// It accepts a [MovieEntity] (domain type) — never a raw Map.
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge_pinapp/src/core/utils/constants.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

// TODO: split widgets
class MovieCardWidget extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback? onTap;

  const MovieCardWidget({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1A1A1A),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'movie_poster_${movie.id}',
                 flightShuttleBuilder: (flightContext,
                      animation,
                      flightDirection,
                      fromHeroContext,
                      toHeroContext) {
                    Widget current;
                    if (flightDirection == HeroFlightDirection.push) {
                      current = toHeroContext.widget;
                    } else {
                      current = fromHeroContext.widget;
                    }
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, _) {
                        final newValue =
                            lerpDouble(0.0, 2 * pi, animation.value);
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(newValue ?? 0),
                          child: current,
                        );
                      },
                    );
                  },
                child: _PosterImage(posterPath: movie.posterPath),
              ),
            ),
            _MovieInfo(movie: movie),
          ],
        ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  final String posterPath;
  const _PosterImage({required this.posterPath});

  @override
  Widget build(BuildContext context) {
    if (posterPath.isEmpty) {
      return Container(
        color: const Color(0xFF2A2A2A),
        child: const Center(
          child: Icon(Icons.movie_outlined, color: Color(0xFF555555), size: 48),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: '$kTmdbImageBaseUrl$posterPath',
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (_, __) => Container(
        color: const Color(0xFF2A2A2A),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFFE50914),
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        color: const Color(0xFF2A2A2A),
        child: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: Color(0xFF555555),
            size: 40,
          ),
        ),
      ),
    );
  }
}

class _MovieInfo extends StatelessWidget {
  final MovieEntity movie;
  const _MovieInfo({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 14,
                color: Color(0xFFFFC107),
              ),
              const SizedBox(width: 4),
              Text(
                movie.voteAverage.toStringAsFixed(1),
                style: const TextStyle(
                  color: Color(0xFFFFC107),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
