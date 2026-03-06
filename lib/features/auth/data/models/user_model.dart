import 'package:movies/features/auth/domain/entities/user_entity.dart';

class UserModel {
  String? uid;
  String? email;
  String? displayName;
  String? phoneNumber;
  List<String>? wishList;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    required this.wishList,
  });

  UserModel.fromEntity(UserEntity entity) {
    uid = entity.uid;
    email = entity.email;
    displayName = entity.displayName;
    phoneNumber = entity.phoneNumber;
    wishList = entity.wishList;
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid ?? "",
      email: email ?? "",
      displayName: displayName ?? "",
      phoneNumber: phoneNumber ?? "",
      wishList: wishList ?? [],
    );
  }
}
