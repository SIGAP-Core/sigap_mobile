import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sigap_mobile/features/auth/models/driver_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // Singleton
  AuthRepository._internal()
    : _firebaseAuth = FirebaseAuth.instance,
      _firestore = FirebaseFirestore.instance;

  static final AuthRepository _authRepository = AuthRepository._internal();

  factory AuthRepository() {
    return _authRepository;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<DriverModel> login(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .where('email', isEqualTo: credential.user!.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Jika bukan driver, maka paksa logout dan lempar error
        await logout();
        throw Exception("Akun ini tidak terdaftar sebagai Driver SIGAP.");
      }

      final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
      DriverModel driver = DriverModel.fromMap(data);

      if (driver.status != 'active') {
        await logout();
        throw Exception("Akun Driver Anda sedang tidak aktif. Hubungi Admin.");
      }

      return driver;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<DriverModel?> getDriverData(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return DriverModel.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
