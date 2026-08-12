import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/guest_session_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchUserData(user.uid);
      } else {
        _userModel = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
        notifyListeners();
      } else {
        // Fallback: If auth exists but Firestore doc is missing (e.g. permission error during signup)
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          final names = currentUser.displayName?.split(' ') ?? ['User', ''];
          final firstName = names.isNotEmpty ? names.first : 'User';
          final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';
          
          _userModel = UserModel(
            uid: uid,
            email: currentUser.email ?? '',
            firstName: firstName,
            lastName: lastName,
            avatarId: 'avatar-1.png',
            preferredLanguage: 'hindi',
          );
          
          // Try to save it back so they have a document
          try {
            await _firestore.collection('users').doc(uid).set(_userModel!.toMap());
          } catch (e) {
            debugPrint('Could not recreate user doc: $e');
          }
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Login failed';
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String avatarId = 'avatar-1.png',
    String preferredLanguage = 'hindi',
  }) async {
    _setLoading(true);
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Create user document in Firestore
      if (cred.user != null) {
        UserModel newUser = UserModel(
          uid: cred.user!.uid,
          email: email.trim(),
          firstName: firstName.trim(),
          lastName: lastName.trim(),
          avatarId: avatarId,
          preferredLanguage: preferredLanguage,
        );
        
        await _firestore.collection('users').doc(cred.user!.uid).set(newUser.toMap());
      }
      
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Signup failed';
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false; // User canceled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential cred = await _auth.signInWithCredential(credential);

      // Create user document if it's their first time logging in
      if (cred.user != null) {
        final uid = cred.user!.uid;
        final doc = await _firestore.collection('users').doc(uid).get();
        
        if (!doc.exists) {
          final names = googleUser.displayName?.split(' ') ?? ['Google', 'User'];
          final firstName = names.isNotEmpty ? names.first : 'Google';
          final lastName = names.length > 1 ? names.sublist(1).join(' ') : 'User';

          UserModel newUser = UserModel(
            uid: uid,
            email: googleUser.email,
            firstName: firstName,
            lastName: lastName,
            avatarId: 'avatar-1.png',
            preferredLanguage: 'hindi',
          );
          await _firestore.collection('users').doc(uid).set(newUser.toMap());
        }
      }

      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Google Sign-In failed';
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await GuestSessionService.clearGuestSession();
    await _auth.signOut();
  }

  Future<void> updateAvatar(String avatarId) async {
    final user = currentUser;
    if (user != null && _userModel != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'avatarId': avatarId,
        });
        
        _userModel = _userModel!.copyWith(avatarId: avatarId);
        notifyListeners();
      } catch (e) {
        debugPrint('Error updating avatar: $e');
      }
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
