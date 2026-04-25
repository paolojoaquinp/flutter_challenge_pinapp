import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/domain/entities/genre_entity.dart';

void main() {
  group('GenreEntity', () {
    test('should expose constructor fields', () {
      const g = GenreEntity(id: 28, name: 'Action');
      expect(g.id, 28);
      expect(g.name, 'Action');
    });

    test('should support value equality', () {
      const a = GenreEntity(id: 28, name: 'Action');
      const b = GenreEntity(id: 28, name: 'Action');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('should not be equal when properties differ', () {
      const a = GenreEntity(id: 28, name: 'Action');
      const c = GenreEntity(id: 12, name: 'Adventure');
      expect(a, isNot(equals(c)));
    });
  });
}
