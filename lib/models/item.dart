class Item {
  final String itemName;
  final String location;
  final DateTime registerDate;

  Item({
    required this.itemName,
    required this.location,
    required this.registerDate,
  });

  // Factory method to create an Item instance from a Map
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['name'] ?? '',
      location: json['location'] ?? '',
      registerDate: DateTime.parse(json['registerDate'] ?? ''),
    );
  }
}
