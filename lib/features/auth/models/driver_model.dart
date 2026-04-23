class DriverModel {
  final String email;
  final String license;
  final String name;
  final String status;

  DriverModel({
    required this.email,
    required this.license,
    required this.name,
    required this.status,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      email: map['email'] ?? '',
      license: map['license'] ?? '',
      name: map['name'] ?? '',
      status: map['status'] ?? '',
    );
  }
}