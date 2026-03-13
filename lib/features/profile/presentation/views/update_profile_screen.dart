import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/utils/hive_service.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies/features/history/presentation/manager/history_cubit.dart';
import 'package:movies/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:movies/features/profile/presentation/manager/profile_cubit.dart';
import 'package:movies/features/profile/presentation/manager/profile_state.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      _nameController = TextEditingController(text: profileState.user.name);
      _phoneController = TextEditingController(
        text: profileState.user.phoneNumber,
      );
      _selectedAvatar = profileState.user.avatarPath;
    } else {
      _nameController = TextEditingController();
      _phoneController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'update_profile'.tr(),
          style: const TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile updated successfully'.tr())),
            );
            Navigator.pop(context);
          } else if (state is ProfileDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Account deleted successfully'.tr())),
            );
            // Full cleanup
            HiveService.clearAllBoxes();
            context.read<WishlistCubit>().reset();
            context.read<HistoryCubit>().reset();
            context.read<ProfileCubit>().reset();
            context.read<AuthCubit>().signOut();

            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          } else if (state is ProfileReauthenticationRequired) {
            _showReauthDialog(context);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileLoading;
          final cubit = context.read<ProfileCubit>();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Avatar Preview
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(_selectedAvatar ?? ''),
                  backgroundColor: AppColors.inputBackgroundDark,
                  onBackgroundImageError: (error, stackTrace) => const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Form Fields
                _buildTextField(
                  controller: _nameController,
                  hint: 'name'.tr(),
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  hint: 'phone_number'.tr(),
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Reset password logic
                    },
                    child: Text(
                      'reset_password'.tr(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Avatar Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: cubit.availableAvatars.length,
                  itemBuilder: (context, index) {
                    final avatar = cubit.availableAvatars[index];
                    final isSelected = _selectedAvatar == avatar;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAvatar = avatar),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(avatar),
                          onBackgroundImageError: (error, stackTrace) =>
                              const Icon(Icons.person, color: AppColors.white),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            _showDeleteConfirmationDialog(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'delete_account'.tr(),
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<ProfileCubit>().updateProfile(
                              name: _nameController.text,
                              phone: _phoneController.text,
                              avatar: _selectedAvatar,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'update_data'.tr(),
                            style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.inputBackgroundDark,
          title: Text(
            'delete_account'.tr(),
            style: const TextStyle(color: AppColors.white),
          ),
          content: Text(
            'are_you_sure_delete_account'.tr(),
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'cancel'.tr(),
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<ProfileCubit>().deleteAccount();
              },
              child: Text(
                'delete'.tr(),
                style: const TextStyle(color: AppColors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showReauthDialog(BuildContext context) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.inputBackgroundDark,
          title: Text(
            'reauthenticate'.tr(),
            style: const TextStyle(color: AppColors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'reauth_message'.tr(),
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: passwordController,
                hint: 'password'.tr(),
                icon: Icons.lock,
                isPassword: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'cancel'.tr(),
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                final password = passwordController.text.trim();
                if (password.isNotEmpty) {
                  Navigator.pop(dialogContext);
                  context.read<ProfileCubit>().reauthenticateAndDelete(
                    password,
                  );
                }
              },
              child: Text(
                'confirm'.tr(),
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackgroundDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: AppColors.white),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
