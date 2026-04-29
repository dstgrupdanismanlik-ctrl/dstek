import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/student_profile_model.dart'; // Yeni modelimizi içe aktardık

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  bool _isLoading = false;

  AuthProvider() {
    // Firebase'deki oturum değişikliklerini anlık olarak dinler
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;

  // --- GİRİŞ YAPMA FONKSİYONU ---
  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- YENİ KAYIT OLMA FONKSİYONU ---
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    required String institutionCode,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1. Firebase Auth sisteminde (Kimlik Doğrulama) kullanıcıyı oluştur
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String currentUid = credential.user!.uid;

      // 2. Ana Kimlik Kartını (users) oluştur
      UserModel newUser = UserModel(
        uid: currentUid,
        name: name,
        email: email,
        role: role,
        institutionCode: institutionCode,
        isActive: false, // PRD kuralları gereği onaya kadar pasif
        kvkkApprovalDate: DateTime.now(),
      );

      // Ana kimliği veritabanına yaz
      await _firestore.collection('users').doc(currentUid).set(newUser.toJson());

      // 3. Eğer rol 'ogrenci' ise, Akademik Profili (student_profiles) oluştur
      if (role == 'ogrenci') {
        StudentProfileModel newStudentProfile = StudentProfileModel(
          phoneNumber: '', // Bu detaylar daha sonra profil ekranından doldurulacak
          parentName: '',
          parentPhoneNumber: '',
          educationLevel: '',
          targetExam: '',
          fieldOfStudy: '',
          initialScores: {},
          targetScores: {},
          topicCompletionThreshold: 85, // Varsayılan değerler
          questionSolveThreshold: 75,
          studySolveThreshold: 65,
          getSupportThreshold: 65,
          coachingStartDate: DateTime.now(),
        );

        // Aynı UID ile öğrenci dosyasını veritabanına yaz (İzolasyon mantığı)
        await _firestore
            .collection('student_profiles')
            .doc(currentUid)
            .set(newStudentProfile.toJson());
      }

    } catch (e) {
      rethrow; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- ÇIKIŞ YAPMA FONKSİYONU ---
  Future<void> signOut() async {
    await _auth.signOut();
  }
}