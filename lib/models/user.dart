class User{
  final String name;
  final String email;

  User(this.name,this.email);

  User.fromJson(Map<String,dynamic> json)
      : name=json['data']['name'] ?? '',
        email=json['data']['email'] ?? '';
}