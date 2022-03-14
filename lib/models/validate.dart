class Validate {
  final List<dynamic>? name;
  final List<dynamic>? email;
  final List<dynamic>? password;

  Validate(this.name,this.email, this.password);

  Validate.fromJson(Map<String,dynamic> json)
      : name = json['errors']['name'],
        email = json['errors']['email'],
        password = json['errors']['password'];
}