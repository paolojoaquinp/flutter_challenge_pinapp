import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge_pinapp/src/core/utils/constants.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_detail_entity.dart';

class BackdropAppBarWidget extends StatelessWidget {
  final MovieDetailEntity detail;
  const BackdropAppBarWidget({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF0D0D0D),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (detail.backdropPath.isNotEmpty)
              Hero(
                tag: 'movie_poster_${detail.id}',
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
                child: CachedNetworkImage(
                  imageUrl: '$kTmdbImageBaseUrl${detail.backdropPath}',
                  fit: BoxFit.cover,
                ),
              )
            else
              Hero(
                tag: 'movie_poster_${detail.id}',
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
                child: Container(color: const Color(0xFF1A1A1A)),
              ),
            // Gradient overlay for readability.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xFF0D0D0D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
