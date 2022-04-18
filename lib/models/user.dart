class User {
  final int id;
  final String name;
  final String email;
  final int vehicleModel;
  final int prefectureId;
  final String token;

  User(this.id, this.name, this.email, this.vehicleModel, this.prefectureId,
      this.token);

  User.fromJson(Map<String, dynamic> json)
      : id = json['data']['id'] ?? '',
        name = json['data']['name'] ?? '',
        email = json['data']['email'] ?? '',
        vehicleModel = json['data']['vehicleModel'],
        prefectureId = json['data']['prefectureId'] - 1,
        token = json['data']['accessToken'] ?? '';
}
