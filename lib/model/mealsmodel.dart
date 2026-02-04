// To parse this JSON data, do
//
//     final mealsmodel = mealsmodelFromJson(jsonString);

import 'dart:convert';

List<mealsmodel> mealsmodelFromJson(String str) =>
    List<mealsmodel>.from(json.decode(str).map((x) => mealsmodel.fromJson(x)));

String mealsmodelToJson(List<mealsmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class mealsmodel {
  String id;
  String items;
  String price;
  String title;
  String time;

  mealsmodel({
    required this.id,
    required this.items,
    required this.price,
    required this.title,
    required this.time,
  });

  /// JSON factory (existing)
  factory mealsmodel.fromJson(Map<String, dynamic> json) => mealsmodel(
        id: json["id"],
        items: json["items"],
        price: json["price"],
        title: json["title"],
        time: json["time"],
      );

  /// JSON serialization (existing)
  Map<String, dynamic> toJson() => {
        "id": id,
        "items": items,
        "price": price,
        "title": title,
        "time": time,
      };

  /// ✅ Firestore-compatible Map reader
  factory mealsmodel.fromMap(Map<String, dynamic> map) {
    return mealsmodel(
      id: map["id"] ?? "",
      items: map["items"] ?? "",
      price: map["price"] ?? "",
      title: map["title"] ?? "",
      time: map["time"] ?? "",
    );
  }

  /// ✅ Firestore-compatible Map writer
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "items": items,
      "price": price,
      "title": title,
      "time": time,
    };
  }
}
