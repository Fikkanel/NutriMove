import '../../data/models/user_model.dart';

/// Auth repository interface (domain layer).
abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signInWithGoogle();
  Future<UserModel> register(String name, String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  Stream<UserModel?> authStateChanges();
}
