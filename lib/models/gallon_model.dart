class Gallon {
  int? id;
  String name;
  double price;
  String imagePath;
  String description;

  Gallon({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
  });

  factory Gallon.fromMap(Map<String, dynamic> map) {
    return Gallon(
      id: map['id'],
      name: map['name'],
      price: map['price'] is int ? (map['price'] as int).toDouble() : map['price'],
      imagePath: map['image_path'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_path': imagePath,
      'description': description,
    };
  }
}
