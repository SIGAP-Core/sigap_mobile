import 'package:cloud_firestore/cloud_firestore.dart';

class AccessLogModel {
  final String id;
  final DateTime? tanggal;
  final String uid;
  final dynamic rawTanggal;
  
  AccessLogModel({
    required this.id,
    required this.tanggal,
    required this.uid,
    required this.rawTanggal,
  });

  factory AccessLogModel.fromMap(Map<String, dynamic> map, String docId){
    DateTime? parsedDate;
    var rawDate = map['tanggal'];

    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      try {
        parsedDate = DateTime.parse(rawDate).toLocal();
      } catch (_) {}
    }

    return AccessLogModel(
      id: docId,
      tanggal: parsedDate,
      uid: map['uid'] ?? '',
      rawTanggal: rawDate,
    );
  }

}