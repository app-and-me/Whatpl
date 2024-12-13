class Series {
  String? id;
  int likeCount;
  List<String> reviews;
  List<String> places;
  String type; 
  
  Series({
    this.id,
    required this.likeCount,
    required this.reviews,
    required this.places,
    required this.type,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'] as String?,
      likeCount: json['likeCount'] as int,
      reviews: List<String>.from(json['reviews'] ?? []),
      places: List<String>.from(json['places'] ?? []),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'likeCount': likeCount,
      'reviews': reviews,
      'places': places,
      'type': type,
    };
  }
}
