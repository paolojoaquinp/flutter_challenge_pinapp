import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_challenge_pinapp/src/core/network/network_info.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockInternetConnectionChecker checker;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    checker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(checker);
  });

  group('NetworkInfoImpl.isConnected', () {
    test('returns true when checker reports connection', () async {
      when(() => checker.hasConnection).thenAnswer((_) async => true);
      expect(await networkInfo.isConnected, isTrue);
    });

    test('returns false when checker reports no connection', () async {
      when(() => checker.hasConnection).thenAnswer((_) async => false);
      expect(await networkInfo.isConnected, isFalse);
    });
  });
}
