class User{
  final int id;
  final String name;
  final String email;

  User(this.id,this.name,this.email);

  User.fromJson(Map<String,dynamic> json)
      : id = json['data']['id'] ?? '',
        name=json['data']['name'] ?? '',
        email=json['data']['email'] ?? '';
}