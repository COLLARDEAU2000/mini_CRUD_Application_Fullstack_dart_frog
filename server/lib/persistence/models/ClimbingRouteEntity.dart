class ClimbingRouteEntity {
  final int id;
  final String name;
  final String email;

  ClimbingRouteEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ClimbingRouteEntity.fromJson(Map<String, dynamic> json) {
    return ClimbingRouteEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  factory ClimbingRouteEntity.fromRowAssoc(Map<String, dynamic> row) {
    return ClimbingRouteEntity(
      id: int.parse(row['id'].toString()), // Conversion forcée en int
      name: row['name'] as String,
      email: row['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
