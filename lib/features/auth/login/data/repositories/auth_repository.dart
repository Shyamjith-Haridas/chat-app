import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  // Get auth state changes - stream
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Login account
  Future<UserCredential> loginAccount({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthExceptions(e);
    } catch (e) {
      throw Exception('unknown-error: ${e.toString()}');
    }
  }

  // Create account
  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthExceptions(e);
    } catch (e) {
      throw Exception('unknown-error: ${e.toString()}');
    }
  }

  // Signout
  Future<void> signOutAccount() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthExceptions(e);
    } catch (e) {
      throw Exception('unknown-error: ${e.toString()}');
    }
  }

  // Delete account
  Future<void> deleteUserAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('no-user-signed-in');
      }
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthExceptions(e);
    } catch (e) {
      throw Exception('unknown-error: ${e.toString()}');
    }
  }

  // Save token

  // Handle firebase auth exception
  String _handleAuthExceptions(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'invalid-email';
      case 'user-disabled':
        return 'user-disabled';
      case 'user-not-found':
        return 'user-not-found';
      case 'wrong-password':
        return 'wrong-password';
      case 'email-already-in-use':
        return 'email-already-in-use';
      case 'operation-not-allowed':
        return 'operation-not-allowed';
      case 'weak-password':
        return 'weak-password';
      case 'network-request-failed':
        return 'network-request-failed';
      case 'too-many-requests':
        return 'too-many-requests';
      case 'invalid-credential':
        return 'invalid-credential';
      case 'requires-recent-login':
        return 'requires-recent-login';
      default:
        return e.message ?? 'auth-error';
    }
  }
}
