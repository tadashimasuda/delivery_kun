class Validate {
  final List<dynamic>? email;
  final List<dynamic>? password;

  Validate(this.email, this.password);

  Validate.fromJson(Map<String,dynamic> json)
      : email = json['errors']['email'],
        password = json['errors']['password'];
}