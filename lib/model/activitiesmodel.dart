// To parse this JSON data, do
//
//     final activitiesmodel = activitiesmodelFromJson(jsonString);

import 'dart:convert';

List<Activitiesmodel> activitiesmodelFromJson(String str) => List<Activitiesmodel>.from(json.decode(str).map((x) => Activitiesmodel.fromJson(x)));

String activitiesmodelToJson(List<Activitiesmodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Activitiesmodel {
    String id;
    String description;
    String price;
    String title;

    Activitiesmodel({
        required this.id,
        required this.description,
        required this.price,
        required this.title,
    });

    factory Activitiesmodel.fromJson(Map<String, dynamic> json) => Activitiesmodel(
        id: json["id"],
        description: json["description"],
        price: json["price"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "price": price,
        "title": title,
    };
}
