import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GateRepository {
  final Dio _dio;
  static final _dioBaseOptions = BaseOptions(
    baseUrl: dotenv.env["API_VERIFY_URL"] ?? "",
  );

  // Singleton
  GateRepository._internal() : _dio = Dio(_dioBaseOptions);

  static final GateRepository _instance = GateRepository._internal();

  factory GateRepository() {
    return _instance;
  }

  Future<Response> verifyGate(String payload, String idToken) async {
    return _dio.post(
      "/verify",
      data: {"payload": payload, "userToken": idToken},
    );
  }
}
