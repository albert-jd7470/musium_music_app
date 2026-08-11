class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String avatarId;
  final String preferredLanguage;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarId,
    required this.preferredLanguage,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      avatarId: data['avatarId'] ?? 'avatar-1.png',
      preferredLanguage: data['preferredLanguage'] ?? 'hindi',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatarId': avatarId,
      'preferredLanguage': preferredLanguage,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarId,
    String? preferredLanguage,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarId: avatarId ?? this.avatarId,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }
}
