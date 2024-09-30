class Whisky {
  String distillery;
  int age;
  double price;
  String? imagePath;
  String? type;
  String? aroma;
  String? taste;
  String? finish;
  List<String> flavorProfiles;
  double? alcoholContent;
  String? region;
  int? rating;
  List<String> notes;

  Whisky({
    required this.distillery,
    required this.age,
    required this.price,
    this.imagePath,
    this.type,
    this.aroma,
    this.taste,
    this.finish,
    this.flavorProfiles = const [],
    this.alcoholContent,
    this.region,
    this.rating,
    this.notes = const [], // Initialisierung der Liste
  });

  Map<String, dynamic> toJson() {
    return {
      'distillery': distillery,
      'age': age,
      'price': price,
      'imagePath': imagePath,
      'type': type,
      'aroma': aroma,
      'taste': taste,
      'finish': finish,
      'flavorProfiles': flavorProfiles,
      'alcoholContent': alcoholContent,
      'region': region,
      'rating': rating,
      'notes': notes,
    };
  }

  factory Whisky.fromJson(Map<String, dynamic> json) {
    return Whisky(
      distillery: json['distillery'],
      age: json['age'],
      price: json['price'],
      imagePath: json['imagePath'],
      type: json['type'],
      aroma: json['aroma'],
      taste: json['taste'],
      finish: json['finish'],
      flavorProfiles: List<String>.from(json['flavorProfiles'] ?? []),
      alcoholContent: json['alcoholContent'],
      region: json['region'],
      rating: json['rating'],
      notes: List<String>.from(json['notes'] ?? []), // Kopiere die Liste, damit sie veränderlich ist
    );
  }
}
