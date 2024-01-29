class Coupon {
  Coupon({
    this.brand,
    this.brandId,
    this.count,
    this.couponOwners,
    this.description,
    required this.id,
    this.images,
    this.pricePoint,
    this.createdAt,
    this.updatedAt,
    this.title,
  });

  final String? brand;
  final String? brandId;
  final int? count;
  final List<String>? couponOwners;
  final String? description;
  final String? id;
  final List<String>? images;
  final int? pricePoint;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      brand: json["brand"],
      brandId: json["brandId"],
      count: json["count"],
      couponOwners: json["couponOwners"] == null
          ? []
          : List<String>.from(json["couponOwners"]!.map((x) => x)),
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
        "brand": brand,
        "brandId": brandId,
        "count": count,
        "couponOwners": couponOwners?.map((x) => x).toList(),
        "description": description,
        "id": id,
        "images": images?.map((x) => x).toList(),
        "pricePoint": pricePoint,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "title": title,
      };
}
