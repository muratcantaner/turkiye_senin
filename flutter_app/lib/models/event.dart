class Event {
  final int id;
  final String eventName;
  final String eventCategory;
  final DateTime eventDate;
  final String eventLocation;
  final double eventPrice;
  final int? participantLimit;
  final int? councilId;

  Event({
    required this.id,
    required this.eventName,
    required this.eventCategory,
    required this.eventDate,
    required this.eventLocation,
    required this.eventPrice,
    this.participantLimit,
    this.councilId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      eventName: json['event_name'],
      eventCategory: json['event_category'],
      eventDate: DateTime.parse(json['event_date']),
      eventLocation: json['event_location'],
      eventPrice: (json['event_price'] ?? 0).toDouble(),
      participantLimit: json['participant_limit'],
      councilId: json['council_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_name': eventName,
      'event_category': eventCategory,
      'event_date': eventDate.toIso8601String(),
      'event_location': eventLocation,
      'event_price': eventPrice,
      'participant_limit': participantLimit,
      'council_id': councilId,
    };
  }

  bool get isFree => eventPrice == 0;
  bool get hasLimit => participantLimit != null;
}
