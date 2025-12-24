class AppUser {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String imageUrl;
  final List<String> skills;

  AppUser({required this.uid, required this.email, required this.name, required this.role, required this.imageUrl, required this.skills});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'name': name, 'role': role, 'imageUrl': imageUrl, 'skills': skills};
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
    );
  }
}
