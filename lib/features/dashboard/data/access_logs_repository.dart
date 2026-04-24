import 'package:cloud_firestore/cloud_firestore.dart';

class AccessLogsRepository {
  // Singleton
  final FirebaseFirestore _firestore;

  AccessLogsRepository._internal() : _firestore = FirebaseFirestore.instance;

  static final AccessLogsRepository _accessRepository =
      AccessLogsRepository._internal();

  factory AccessLogsRepository() {
    return _accessRepository;
  }

  Stream<List<Map<String, dynamic>>> streamAccessLogs(String uid) {
    return _firestore
        .collection("access_logs")
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final log = doc.data();
        log["id"] = doc.id;
        return log;
      }).toList();
    });
  }
}
