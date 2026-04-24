// DIP (Dependency Inversion): High-level modules (Repository) depend on this
// abstraction. The concrete internet_connection_checker implementation is
// never imported outside this file.
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Contract for checking device network connectivity.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Concrete implementation backed by [InternetConnectionChecker].
// SRP: This class is solely responsible for reporting connectivity status.
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  const NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
