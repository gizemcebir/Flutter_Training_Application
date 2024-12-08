import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mevcut kullanıcıyı almak için getter
  User? get currentUser => _firebaseAuth.currentUser;

  // Auth durumu değişikliklerini dinlemek için stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Yeni kullanıcı oluşturma ve bilgileri Firestore'a ekleme
  Future<void> createUser({
    required String email,
    required String password,
    required String ad,        // Ad ve soyad gibi ek bilgiler
    required String soyad,
    required String dogumTarihi,
  }) async {
    try {
      // Firebase Authentication'da kullanıcı oluştur
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Kullanıcı oluşturulduktan sonra Firestore'a bilgileri ekle
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'ad': ad,
          'soyad': soyad,
          'dogumTarihi': dogumTarihi,
          'email': email,
          'uid': user.uid,
        });
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Kullanıcı oluşturulurken hata: ${e.message}');
    }
  }

  // Login
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

