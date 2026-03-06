import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  UserProfile _mockProfile = UserProfile(
    uid: '123',
    name: 'John Safwat',
    email: 'john.safwat@example.com',
    phoneNumber: '01200000000',
    avatarPath: 'assets/images/avatar1.png', // Assuming we'll have these
    wishList: [
      'https://image.tmdb.org/t/p/w500/iZf0KyrE25z1apesvKQFAMhCybg.jpg',
      'https://image.tmdb.org/t/p/w500/vSNxAJTlD0r02V8s0BN0nI82n3t.jpg',
    ],
    history: [
       'https://image.tmdb.org/t/p/w500/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg',
    ],
  );

  @override
  Future<UserProfile> getUserProfile(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProfile;
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockProfile = profile;
  }
}
