import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_challenge_pinapp/src/core/network/network_info.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/data/datasources/local/movie_local_datasource.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/domain/repositories/movie_repository.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockMovieLocalDatasource extends Mock implements MovieLocalDatasource {}

class MockDio extends Mock implements Dio {}

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

class MockDioException extends Mock implements DioException {}
