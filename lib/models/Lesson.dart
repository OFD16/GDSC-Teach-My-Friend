class Coupon {
  Coupon({
    required this.ownerId,
    required this.level,
    this.userLimit,
    this.students,
    this.description,
    required this.id,
    this.images,
    required this.pricePoint,
    this.createdAt,
    this.updatedAt,
    required this.title,
  });

  final String? ownerId;
  final String? level;
  final int? userLimit;
  final List<String>? students;
  final String? description;
  final String? id;
  final List<String>? images;
  final int? pricePoint;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
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
      };
}
