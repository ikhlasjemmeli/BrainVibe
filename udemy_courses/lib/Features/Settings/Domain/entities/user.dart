class User {
  final String email;
  final String password;
  late final String firstName;
  late final String lastName;

  User({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });


  factory User.fromJson(Map<String, dynamic> json) => User(

      email: json["email"] ?? '',
      password: json["password"] ?? '',
      firstName: json["firstName"] ?? '',
      lastName: json["lastName"] ?? '',
  );


  Map<String, dynamic> toJson() => {

    "email": email,
    "password": password,
    "firstName":  firstName,
    "lastName":  lastName,

  };



  User copyWith({

    String? email,
    String? password,
    String? firstName,
    String? lastName,

  }) {
    return User(

      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,

    );
  }
}

