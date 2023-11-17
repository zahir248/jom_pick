class Item {
  final int itemId;
  final String itemName;
  final String location;
  final DateTime registerDate;
  final String trackingNumber;
  final String itemType; // Add a property for item type

  Item({
    required this.itemId,
    required this.itemName,
    required this.location,
    required this.registerDate,
    required this.trackingNumber,
    required this.itemType, // Initialize the property in the constructor
  });

  // Factory method to create an Item instance from a Map
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: int.parse(json['item_id'] ?? '0'),
      itemName: json['name'] ?? '',
      location: json['location'] ?? '',
      registerDate: DateTime.parse(json['registerDate'] ?? ''),
      trackingNumber: json['trackingNumber'] ?? '',
      itemType: json['itemType'] ?? '', // Retrieve item type from the JSON
    );
  }
}
