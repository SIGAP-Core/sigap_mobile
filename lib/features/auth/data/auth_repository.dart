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
      data['uid'] = credential.user!.uid;
      DriverModel driver = DriverModel.fromMap(data);

      if (driver.status != 'active') {
        await logout();
        throw Exception("Akun Driver Anda sedang tidak aktif. Hubungi Admin.");
      }

      return driver;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'wrong-password') {
        throw Exception("Email atau password yang Anda masukkan salah.");
      } else if (e.code == 'invalid-email') {
        throw Exception("Format email tidak valid.");
      } else if (e.code == 'user-disabled') {
        throw Exception("Akun ini telah dinonaktifkan. Hubungi Admin.");
      } else if (e.code == 'network-request-failed') {
        throw Exception("Koneksi internet terputus. Periksa jaringan Anda.");
      } else {
        throw Exception(e.message ?? "Terjadi kesalahan pada autentikasi.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception("Sesi pengguna tidak ditemukan. Silakan login ulang.");
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      // login ulang di balik layar
      await user.reauthenticateWithCredential(credential);

      // UPDATE PASSWORD BARU
      await user.updatePassword(newPassword);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception("Password lama yang Anda masukkan salah.");
      } else if (e.code == 'weak-password') {
        throw Exception("Password baru terlalu lemah (minimal 6 karakter).");
      } else if (e.code == 'requires-recent-login') {
        throw Exception("Sesi Anda telah kedaluwarsa. Silakan login ulang aplikasi.");
      } else {
        throw Exception(e.message ?? "Terjadi kesalahan pada Firebase.");
      }
    } catch (e) {
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
        final driverMap =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        driverMap['uid'] = querySnapshot.docs.first.id;
        return DriverModel.fromMap(driverMap);
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
