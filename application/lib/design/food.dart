class Food {
  final int id;
  final String name;
  final String type;

  Food({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    //print('ajab');
    return Food(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}
