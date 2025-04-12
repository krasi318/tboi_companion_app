class Item {
  final int? id;
  final String name;
  final String description;
  final String imagePath;
  final String? pixelHash;

  // Constructor
  Item({
    this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    this.pixelHash,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'pixelHash': pixelHash, // Save pixelHash to database
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imagePath: map['imagePath'],
      pixelHash: map['pixelHash'], // Retrieve pixelHash from database
    );
  }
}
