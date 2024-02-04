class Lesson {
  Lesson({
    this.id,
    required this.ownerId,
    this.level,
    this.userLimit,
    this.students,
    this.description,
    this.images,
    this.pricePoint,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.type,
    this.likes = const [],
  });

  String? ownerId;
  String? level;
  String? userLimit;
  List<String>? students;
  String? description;
  String? id;
  List<String>? images;
  int? pricePoint;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title, type;
  List<String> likes = [];

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      ownerId: json["ownerId"],
      level: json["level"],
      userLimit: json["userLimit"],
      students: json["students"] == null
          ? []
          : List<String>.from(json["students"]!.map((x) => x)),
      description: json["description"],
      id: json["id"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      pricePoint: json["pricePoint"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      title: json["title"],
      type: json["type"],
      likes: json["likes"] == null
          ? []
          : List<String>.from(json["likes"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "ownerId": ownerId,
        "level": level,
        "userLimit": userLimit,
        "students": students?.map((x) => x).toList(),
        "description": description,
        "id": id,
        "images": images?.map((x) => x).toList(),
        "pricePoint": pricePoint,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "title": title,
        "type": type,
        "likes": likes?.map((x) => x).toList(),
      };
}
