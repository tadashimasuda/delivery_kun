class User{
  final String name;
  final String email;

  User({required this.name,required this.email});

  User.fromJson(Map<String,dynamic> json)
      : name=json['data']['name'],
        email=json['data']['email'];
}