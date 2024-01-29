class User {
  User({
    this.isEmailVerified,
    this.userRate,
    this.userName,
    this.phoneNumber,
    this.address,
    this.lastSignInTime,
    this.photoUrl,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt,
    this.email,
    this.password,
    required this.id,
  });

  late bool? isEmailVerified;
  late int? userRate;
  late String? firstName,
      lastName,
      userName,
      phoneNumber,
      address,
      email,
      password;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late DateTime? lastSignInTime;
  late String? photoUrl;
  final String? id;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      isEmailVerified: json["isEmailVerified"],
      userRate: json["userRate"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      userName: json["userName"],
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      email: json["email"],
      password: json["password"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      lastSignInTime: DateTime.tryParse(json["lastSignInTime"] ?? ""),
      photoUrl: json["photoURL"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "isEmailVerified": isEmailVerified,
        "userRate": userRate,
        "firstName": firstName,
        "lastName": lastName,
        "userName": userName,
        "phoneNumber": phoneNumber,
        "address": address,
        "email": email,
        "password": password,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "lastSignInTime": lastSignInTime?.toIso8601String(),
        "photoURL": photoUrl,
        "id": id,
      };
}
