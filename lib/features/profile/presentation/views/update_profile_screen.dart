import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:movies/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:movies/features/auth/presentation/widgets/primary_button.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().state.userProfile;
    nameController = TextEditingController(text: profile?.name);
    phoneController = TextEditingController(text: profile?.phoneNumber);
    selectedAvatar = profile?.avatarPath;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFF1A1C1A),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'update_profile'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFFFC107)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF282A28),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: cubit.availableAvatars.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(
                                    () => selectedAvatar =
                                        cubit.availableAvatars[index],
                                  );
                                  Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    cubit.availableAvatars[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                      selectedAvatar ?? 'assets/images/avatar1.png',
                    ),
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFFFC107),
                        child: Icon(Icons.edit, size: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: nameController,
                  hintText: 'name'.tr(),
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: phoneController,
                  hintText: 'phone_number'.tr(),
                  prefixIcon: Icons.phone,
                ),
                const SizedBox(height: 40),
                state.isLoading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        text: 'update_data'.tr(),
                        onPressed: () async {
                          await cubit.updateProfile(
                            name: nameController.text,
                            phone: phoneController.text,
                            avatar: selectedAvatar,
                          );
                          if (state.errorMessage == null) {
                            if (mounted) Navigator.pop(context);
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.errorMessage!)),
                              );
                            }
                          }
                        },
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    'delete_account'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
