class User {
  final int id;
  final String name;
  final String email;
  final num earningsBase;
  final int vehicleModel;
  final int prefectureId;
  final String token;

  User(this.id,
      this.name,
      this.email,
      this.earningsBase,
      this.vehicleModel,
      this.prefectureId,
      this.token);

  User.fromJson(Map<String, dynamic> json)
      : id = json['data']['id'],
        name = json['data']['name'],
        email = json['data']['email'],
        earningsBase = json['data']['earningsBase'],
        vehicleModel = json['data']['vehicleModel'],
        prefectureId = json['data']['prefectureId'] - 1,
        token = json['data']['accessToken'];
}
