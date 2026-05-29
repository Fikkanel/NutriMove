import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimove/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  late AuthRepositoryImpl repo;

  setUp(() {
    repo = AuthRepositoryImpl();
  });

  group('AuthRepositoryImpl', () {
    test('getCurrentUser returns null when not signed in', () async {
      final user = await repo.getCurrentUser();
      expect(user, isNull);
    });

    test('signIn returns user with correct email', () async {
      final user = await repo.signIn('test@example.com', 'password123');
      expect(user.email, 'test@example.com');
      expect(user.uid, isNotEmpty);
    });

    test('register returns user with displayName', () async {
      final user = await repo.register('Test User', 'test@example.com', 'password123');
      expect(user.displayName, 'Test User');
      expect(user.email, 'test@example.com');
    });

    test('resetPassword completes without error', () async {
      await expectLater(repo.resetPassword('test@example.com'), completes);
    });

    test('signOut completes without error', () async {
      await expectLater(repo.signOut(), completes);
    });
  });
}
