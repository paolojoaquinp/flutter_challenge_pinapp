import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_detail_model.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/genre_entity.dart';

const tMovieDetailJson = <String, dynamic>{
  'id': 550,
  'title': 'Fight Club',
  'tagline': 'Mischief. Mayhem. Soap.',
  'overview': 'A ticking-time-bomb insomniac...',
  'poster_path': '/poster.jpg',
  'backdrop_path': '/backdrop.jpg',
  'vote_average': 8.4,
  'vote_count': 27000,
  'release_date': '1999-10-15',
  'runtime': 139,
  'status': 'Released',
  'popularity': 75.5,
  'genres': <Map<String, dynamic>>[
    {'id': 18, 'name': 'Drama'},
    {'id': 53, 'name': 'Thriller'},
  ],
};

const tMovieDetailModel = MovieDetailModel(
  id: 550,
  title: 'Fight Club',
  tagline: 'Mischief. Mayhem. Soap.',
  overview: 'A ticking-time-bomb insomniac...',
  posterPath: '/poster.jpg',
  backdropPath: '/backdrop.jpg',
  voteAverage: 8.4,
  voteCount: 27000,
  releaseDate: '1999-10-15',
  runtime: 139,
  status: 'Released',
  popularity: 75.5,
  genres: [
    GenreEntity(id: 18, name: 'Drama'),
    GenreEntity(id: 53, name: 'Thriller'),
  ],
);
