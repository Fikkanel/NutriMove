import 'package:flutter/material.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// Manages authentication state across the app.
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepositoryImpl();

  AuthStatus _status = AuthStatus.initial;
  String? _userId;
  String? _email;
  String? _displayName;
  String? _errorMessage;
  bool _isNewUser = false;

  AuthStatus get status => _status;
  String? get userId => _userId;
  String? get email => _email;
  String? get displayName => _displayName;
  String? get errorMessage => _errorMessage;
  bool get isNewUser => _isNewUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Check current auth state on app start.
  Future<void> checkAuthState() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        _userId = user.uid;
        _email = user.email;
        _displayName = user.displayName;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Sign in with email and password.
  Future<bool> signIn(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.signIn(email, password);
      _userId = user.uid;
      _email = user.email;
      _displayName = user.displayName;
      _isNewUser = false;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Login gagal. Periksa email/password.';
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Google.
  Future<bool> signInWithGoogle() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.signInWithGoogle();
      _userId = user.uid;
      _email = user.email;
      _displayName = user.displayName;
      _isNewUser = user.isNewUser; 
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Gagal masuk dengan Google.';
      notifyListeners();
      return false;
    }
  }

  /// Register with email and password.
  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.register(name, email, password);
      _userId = user.uid;
      _email = user.email;
      _displayName = user.displayName;
      _isNewUser = true;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Pendaftaran gagal.';
      notifyListeners();
      return false;
    }
  }

  /// Send password reset email.
  Future<bool> resetPassword(String email) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      await _repository.resetPassword(email);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Gagal mengirim email reset.';
      notifyListeners();
      return false;
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    await _repository.signOut();
    _userId = null;
    _email = null;
    _displayName = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
