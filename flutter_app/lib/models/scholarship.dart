class Scholarship {
  final int id;
  final String title;
  final String description;
  final DateTime deadline;
  final String applicationUrl;

  Scholarship({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.applicationUrl,
  });

  factory Scholarship.fromJson(Map<String, dynamic> json) {
    return Scholarship(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      applicationUrl: json['application_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'application_url': applicationUrl,
    };
  }

  bool get isExpired => DateTime.now().isAfter(deadline);
}
