class Validate {
  final List<dynamic>? name;
  final List<dynamic>? email;
  final List<dynamic>? earningsBase;
  final List<dynamic>? password;
  final List<dynamic>? prefectureId;
  final List<dynamic>? vehicleModelId;

  Validate(
      this.name,
      this.email,
      this.earningsBase,
      this.password,
      this.prefectureId,
      this.vehicleModelId);

  Validate.fromJson(Map<String,dynamic> json)
      : name = json['errors']['name'],
        email = json['errors']['email'],
        earningsBase = json['errors']['earningsBase'],
        password = json['errors']['password'],
        prefectureId = json['errors']['prefectureId'],
        vehicleModelId = json['errors']['vehicleModelId'];
}