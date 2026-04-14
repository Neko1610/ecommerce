class Profile {
  final int id;
  final String email;
  final String fullName;
  final String phone;
  final String? avatar;

  Profile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    this.avatar,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
    );
  }
}