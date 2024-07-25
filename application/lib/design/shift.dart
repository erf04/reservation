class Shift {
  int id;
  String shiftName;
  Shift({
    required this.id,
    required this.shiftName,
  });
  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(id: json['id'], shiftName: json['shift_name']);
  }
}
