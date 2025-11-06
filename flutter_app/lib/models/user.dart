class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool isAdmin;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      isActive: json['is_active'] ?? true,
      isAdmin: json['is_admin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'is_active': isActive,
      'is_admin': isAdmin,
    };
  }

  String get fullName => '$firstName $lastName';
  
  // Check if user is admin (in God Mode, .gov emails are admins)
  bool get isAdminUser => isAdmin || email.endsWith('.gov.tr') || email.endsWith('.gov');
}
