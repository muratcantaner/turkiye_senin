class Registration {
  final int id;
  final int userId;
  final int eventId;
  final DateTime registrationDate;

  Registration({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.registrationDate,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      id: json['id'],
      userId: json['user_id'],
      eventId: json['event_id'],
      registrationDate: DateTime.parse(json['registration_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'event_id': eventId,
      'registration_date': registrationDate.toIso8601String(),
    };
  }
}
