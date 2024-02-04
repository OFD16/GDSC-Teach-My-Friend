class User {
  User({
    this.points,
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
    this.isAdmin,
    this.favourites = const [],
    required this.id,
  });
  int? points;
  late bool? isEmailVerified, isAdmin;
  late String? userRate;
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
  List<String>? favourites;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      points: json["points"],
      isEmailVerified: json["isEmailVerified"],
      isAdmin: json["isAdmin"],
      userRate: json['userRate'],
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
      favourites:
          (json["favourites"] as List?)?.map((x) => x.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "points": points,
        "isEmailVerified": isEmailVerified,
        "isAdmin": isAdmin,
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
        "favourites": List<dynamic>.from(favourites!.map((x) => x)),
      };

  User copyWith({
    int? points,
    bool? isEmailVerified,
    bool? isAdmin,
    String? userRate,
    String? firstName,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? address,
    String? email,
    String? password,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSignInTime,
    String? photoUrl,
    String? id,
    List<String>? favourites,
  }) {
    return User(
      points: points ?? this.points,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isAdmin: isAdmin ?? this.isAdmin,
      userRate: userRate ?? this.userRate,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      photoUrl: photoUrl ?? this.photoUrl,
      id: id ?? this.id,
      favourites: favourites ?? this.favourites,
    );
  }
}
