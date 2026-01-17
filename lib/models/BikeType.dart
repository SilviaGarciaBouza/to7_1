class BikeType {
  BikeType({required this.id, required this.count});
  final String id;
  final int count;
  factory BikeType.fromJson(Map<String, dynamic> json) {
    return BikeType(
      id: (json['vehicle_type_id'] ?? 'id unknown') as String,
      count: ((json['count'] ?? 0) as num).toInt(),
    );
  }
}
