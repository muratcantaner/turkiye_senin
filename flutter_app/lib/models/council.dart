class Council {
  final int id;
  final String councilName;
  final String city;

  Council({
    required this.id,
    required this.councilName,
    required this.city,
  });

  factory Council.fromJson(Map<String, dynamic> json) {
    return Council(
      id: json['id'],
      councilName: json['council_name'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'council_name': councilName,
      'city': city,
    };
  }
}
