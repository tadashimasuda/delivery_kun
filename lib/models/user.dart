class User{
  final int id;
  final String name;
  final String email;
  final String token;

  User(this.id,this.name,this.email,this.token);

  User.fromJson(Map<String,dynamic> json)
      : id = json['data']['id'] ?? '',
        name=json['data']['name'] ?? '',
        email=json['data']['email'] ?? '',
        token=json['data']['access_token'] ?? '';
}