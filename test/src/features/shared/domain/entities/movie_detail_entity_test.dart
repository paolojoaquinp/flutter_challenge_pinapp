import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/genre_entity.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_detail_entity.dart';

void main() {
  group('MovieDetailEntity', () {
    const a = MovieDetailEntity(
      id: 1,
      title: 'Title',
      tagline: 'Tagline',
      overview: 'Overview',
      posterPath: '/p.jpg',
      backdropPath: '/b.jpg',
      voteAverage: 7.5,
      voteCount: 10,
      releaseDate: '2024-01-01',
      runtime: 120,
      status: 'Released',
      popularity: 5.0,
      genres: [GenreEntity(id: 18, name: 'Drama')],
    );

    test('should expose all constructor fields', () {
      expect(a.id, 1);
      expect(a.title, 'Title');
      expect(a.tagline, 'Tagline');
      expect(a.overview, 'Overview');
      expect(a.posterPath, '/p.jpg');
      expect(a.backdropPath, '/b.jpg');
      expect(a.voteAverage, 7.5);
      expect(a.voteCount, 10);
      expect(a.releaseDate, '2024-01-01');
      expect(a.runtime, 120);
      expect(a.status, 'Released');
      expect(a.popularity, 5.0);
      expect(a.genres, [const GenreEntity(id: 18, name: 'Drama')]);
    });

    test('should support value equality', () {
      const b = MovieDetailEntity(
        id: 1,
        title: 'Title',
        tagline: 'Tagline',
        overview: 'Overview',
        posterPath: '/p.jpg',
        backdropPath: '/b.jpg',
        voteAverage: 7.5,
        voteCount: 10,
        releaseDate: '2024-01-01',
        runtime: 120,
        status: 'Released',
        popularity: 5.0,
        genres: [GenreEntity(id: 18, name: 'Drama')],
      );
      expect(a, equals(b));
    });

    test('should not be equal when properties differ', () {
      const c = MovieDetailEntity(
        id: 2,
        title: 'X',
        tagline: '',
        overview: '',
        posterPath: '',
        backdropPath: '',
        voteAverage: 0,
        voteCount: 0,
        releaseDate: '',
        runtime: 0,
        status: '',
        popularity: 0,
        genres: [],
      );
      expect(a, isNot(equals(c)));
    });
  });
}
