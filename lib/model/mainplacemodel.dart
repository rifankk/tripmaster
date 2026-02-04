class MainPlace {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  MainPlace({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  /// Used when reading Firestore parent documents
  factory MainPlace.fromDocument(Map<String, dynamic> map, String docId) {
    return MainPlace(
      id: docId,
      title: map['place'] ?? "",
      description: map['description'] ?? "",
      imageUrl: map['image'] ?? "",
    );
  }

  /// Used inside PlaceModel (nested map)
  factory MainPlace.fromMap(Map<String, dynamic> map, String id) {
    return MainPlace(
      id: id,
      title: map['place'] ?? "",
      description: map['description'] ?? "",
      imageUrl: map['imageUrl'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "place": title,
      "description": description,
      "imageUrl": imageUrl,
    };
  }
}
