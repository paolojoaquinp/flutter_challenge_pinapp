// DIP: All providers expose the [MovieRepository] abstraction.
// The concrete wiring of NetworkInfo + LocalDatasource lives here so
// every feature notifier stays decoupled from infrastructure.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_challenge_pinapp/src/core/network/network_info.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/data/datasources/local/movie_local_datasource.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/data/datasources/api/movie_repository_impl.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/domain/repositories/movie_repository.dart';

// TODO: review provider focus
/// Provides the [InternetConnectionChecker] singleton using the v3 factory API.
final internetCheckerProvider = Provider<InternetConnectionChecker>(
  (_) => InternetConnectionChecker.createInstance(),
);

/// Provides the [NetworkInfo] abstraction backed by the checker above.
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(internetCheckerProvider));
});

/// Provides the fully configured [MovieRepository] implementation.
/// The local datasource is opened asynchronously — callers await this.
final movieRepositoryProvider = FutureProvider<MovieRepository>((ref) async {
  final localDatasource = await MovieLocalDatasourceImpl.openBoxes();
  final networkInfo = ref.watch(networkInfoProvider);
  return MovieRepositoryImpl(
    networkInfo: networkInfo,
    localDatasource: localDatasource,
  );
});
