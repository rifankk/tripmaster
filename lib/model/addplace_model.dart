import 'package:tripmaster/model/activitiesmodel.dart';
import 'package:tripmaster/model/hotelmodel.dart';
import 'package:tripmaster/model/mainplacemodel.dart';
import 'package:tripmaster/model/mealsmodel.dart';
import 'package:tripmaster/model/nearby_model.dart';

class PlaceModel {
  String? id;
  String? placename;
  String? description;
  String? BasePrice;
  String? imageUrl;
  String? image2Url;
  MainPlace? maonplace;
  List<Hotelmodel>? hotels;
  List<Activitiesmodel>? activity;
  List<mealsmodel>? meals;
  List<Nearbymodel>? nearby;
  int? status;

  

  PlaceModel({
    this.id,
    this.placename,
    this.description,
    this.BasePrice,
    this.imageUrl,
    this.image2Url,
    this.maonplace,
    this.hotels,
    this.activity,
    this.meals,
    this.nearby,
    this.status,
  });

  factory PlaceModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PlaceModel(
      id: documentId,
      placename: map['place'] ?? "",
      description: map['description'] ?? "",
      BasePrice: map['Baseprice']??"",
      imageUrl: map['image'] ?? "",
      image2Url: map['image2'] ?? "",
      maonplace: MainPlace.fromMap(map['mainplace'] ?? {}, ''),
      hotels: (map['hotels'] as List<dynamic>? ?? []).map((e) => Hotelmodel.fromMap(e)).toList(),
      activity: (map['activity'] as List<dynamic>? ?? [])
          .map((e) => Activitiesmodel.fromMap(e))
          .toList(),
      meals: (map['meals'] as List<dynamic>? ?? []).map((e) => mealsmodel.fromMap(e)).toList(),
      nearby: (map['nearby'] as List<dynamic>? ?? []).map((e) => Nearbymodel.fromJson(e)).toList(),
      status: map['status'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "place": placename,
      "description": description,
      "BasePrice": BasePrice,
      "image": imageUrl,
      "image2": image2Url,
      "mainplace": maonplace?.toMap(),
      "hotels": hotels?.map((e) => e.toMap()).toList(),
      "activity": activity?.map((e) => e.toMap()).toList(),
      "meals": meals?.map((e) => e.toMap()).toList(),
      "nearby": nearby?.map((e) => e.toMap()).toList(),
      "status": status,
    };
  }
}
