import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  AuthProvider() {
    // Firebase'deki oturum değişikliklerini (giriş/çıkış) anlık olarak dinler
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // Değişiklik olduğunda arayüzü günceller
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;

  // Giriş Yapma Fonksiyonu
  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow; // Hata durumunda UI katmanına hatayı fırlatırız
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Çıkış Yapma Fonksiyonu
  Future<void> signOut() async {
    await _auth.signOut();
  }
}