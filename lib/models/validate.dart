class Validate {
  final List<dynamic>? name;
  final List<dynamic>? email;
  final List<dynamic>? password;
  final List<dynamic>? prefectureId;
  final List<dynamic>? vehicleModelId;

  Validate(this.name,this.email, this.password,this.prefectureId,this.vehicleModelId);

  Validate.fromJson(Map<String,dynamic> json)
      : name = json['errors']['name'],
        email = json['errors']['email'],
        password = json['errors']['password'],
        prefectureId = json['errors']['prefectureId'],
        vehicleModelId = json['errors']['vehicleModelId'];
}