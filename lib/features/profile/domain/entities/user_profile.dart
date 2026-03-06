class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String avatarPath;
  final List<String> wishList;
  final List<String> history;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatarPath,
    this.wishList = const [],
    this.history = const [],
  });

  UserProfile copyWith({
    String? name,
    String? phoneNumber,
    String? avatarPath,
    List<String>? wishList,
    List<String>? history,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarPath: avatarPath ?? this.avatarPath,
      wishList: wishList ?? this.wishList,
      history: history ?? this.history,
    );
  }
}
