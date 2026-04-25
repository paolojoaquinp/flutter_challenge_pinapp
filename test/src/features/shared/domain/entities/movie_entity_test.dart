import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/movie_entity.dart';

void main() {
  group('MovieEntity', () {
    const a = MovieEntity(
      id: 1,
      title: 'Title',
      overview: 'Overview',
      posterPath: '/p.jpg',
      backdropPath: '/b.jpg',
      voteAverage: 7.5,
      voteCount: 10,
      releaseDate: '2024-01-01',
      genreIds: [28],
      popularity: 5.0,
    );

    test('should expose all constructor fields', () {
      expect(a.id, 1);
      expect(a.title, 'Title');
      expect(a.overview, 'Overview');
      expect(a.posterPath, '/p.jpg');
      expect(a.backdropPath, '/b.jpg');
      expect(a.voteAverage, 7.5);
      expect(a.voteCount, 10);
      expect(a.releaseDate, '2024-01-01');
      expect(a.genreIds, [28]);
      expect(a.popularity, 5.0);
    });

    test('should support value equality', () {
      const b = MovieEntity(
        id: 1,
        title: 'Title',
        overview: 'Overview',
        posterPath: '/p.jpg',
        backdropPath: '/b.jpg',
        voteAverage: 7.5,
        voteCount: 10,
        releaseDate: '2024-01-01',
        genreIds: [28],
        popularity: 5.0,
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('should not be equal when properties differ', () {
      const c = MovieEntity(
        id: 2,
        title: 'Other',
        overview: 'Other',
        posterPath: '/o.jpg',
        backdropPath: '/o.jpg',
        voteAverage: 1,
        voteCount: 1,
        releaseDate: '2020-01-01',
        genreIds: [12],
        popularity: 1,
      );
      expect(a, isNot(equals(c)));
    });
  });
}
