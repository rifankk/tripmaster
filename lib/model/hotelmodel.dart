// To parse this JSON data, do
//
//     final hotelmodel = hotelmodelFromJson(jsonString);

import 'dart:convert';

List<Hotelmodel> hotelmodelFromJson(String str) =>
    List<Hotelmodel>.from(json.decode(str).map((x) => Hotelmodel.fromJson(x)));

String hotelmodelToJson(List<Hotelmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Hotelmodel {
  String pricePerday;
  String latitude;
  String description;
  String? hotel;
  String id;
  String image1;
  String image2;
  String longitude;
  String filter;

  Hotelmodel({
    required this.pricePerday,
    required this.latitude,
    required this.description,
    this.hotel,
    required this.id,
    required this.image1,
    required this.image2,
    required this.longitude,
    required this.filter
  });

  /// JSON factory (you already had this)
  factory Hotelmodel.fromJson(Map<String, dynamic> json) => Hotelmodel(
    pricePerday: json["price perday"],
    latitude: json["latitude"],
    description: json["description"],
    hotel: json["hotel"],
    id: json["id"],
    image1: json["image1"],
    image2: json["image2"],
    longitude: json["longitude"],
    filter: json["filter"]
  );

  /// JSON serialization (you already had this)
  Map<String, dynamic> toJson() => {
    "price perday": pricePerday,
    "latitude": latitude,
    "description": description,
    "hotel": hotel,
    "id": id,
    "image1": image1,
    "image2": image2,
    "longitude": longitude,
    "filter":filter
  };

  /// ✅ Firestore-compatible Map reader (NEEDED for PlaceModel)
  factory Hotelmodel.fromMap(Map<String, dynamic> map) {
    return Hotelmodel(
      pricePerday: map["price perday"] ?? "",
      latitude: map["latitude"] ?? "",
      description: map["description"] ?? "",
      hotel: map["hotel"] ?? "",
      id: map["id"] ?? "",
      image1: map["image1"] ?? "",
      image2: map["image2"] ?? "",
      longitude: map["longitude"] ?? "",
      filter: map["filter"] ?? ""
    );
  }

  /// ✅ Firestore-compatible writer (used in PlaceModel.toMap)
  Map<String, dynamic> toMap() {
    return {
      "price perday": pricePerday,
      "latitude": latitude,
      "description": description,
      "hotel": hotel,
      "id": id,
      "image1": image1,
      "image2": image2,
      "longitude": longitude,
      "filter":filter
    };
  }
}
