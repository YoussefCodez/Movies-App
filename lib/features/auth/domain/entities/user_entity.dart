class UserEntity {
  final String uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final List<String>? wishList;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.wishList,
  });
}
