import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_model.dart';

const tMovieJson = <String, dynamic>{
  'id': 101,
  'title': 'Mock Movie 1',
  'overview': 'A test movie overview.',
  'poster_path': '/poster1.jpg',
  'backdrop_path': '/backdrop1.jpg',
  'vote_average': 7.5,
  'vote_count': 1200,
  'release_date': '2024-01-15',
  'genre_ids': <int>[28, 12],
  'popularity': 99.9,
};

const tMovieJsonAlt = <String, dynamic>{
  'id': 102,
  'title': 'Mock Movie 2',
  'overview': 'Another mock movie.',
  'poster_path': '/poster2.jpg',
  'backdrop_path': '/backdrop2.jpg',
  'vote_average': 6.1,
  'vote_count': 50,
  'release_date': '2023-09-01',
  'genre_ids': <int>[18],
  'popularity': 12.3,
};

const tMovieModel = MovieModel(
  id: 101,
  title: 'Mock Movie 1',
  overview: 'A test movie overview.',
  posterPath: '/poster1.jpg',
  backdropPath: '/backdrop1.jpg',
  voteAverage: 7.5,
  voteCount: 1200,
  releaseDate: '2024-01-15',
  genreIds: [28, 12],
  popularity: 99.9,
);

const tMovieModelAlt = MovieModel(
  id: 102,
  title: 'Mock Movie 2',
  overview: 'Another mock movie.',
  posterPath: '/poster2.jpg',
  backdropPath: '/backdrop2.jpg',
  voteAverage: 6.1,
  voteCount: 50,
  releaseDate: '2023-09-01',
  genreIds: [18],
  popularity: 12.3,
);

const tMovieList = <MovieModel>[tMovieModel, tMovieModelAlt];
