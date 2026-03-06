import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:movies/features/profile/data/repositories/mock_profile_repository.dart';
import 'package:movies/features/profile/presentation/views/update_profile_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(MockProfileRepository()),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading && state.userProfile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.userProfile;
          if (user == null) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Error loading profile',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final cubit = context.read<ProfileCubit>();

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // User Header Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(user.avatarPath),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn(
                              user.wishList.length.toString(),
                              'wish_list'.tr(),
                            ),
                            _buildStatColumn(
                              user.history.length.toString(),
                              'history'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC107),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: cubit,
                                child: const UpdateProfileScreen(),
                              ),
                            ),
                          ),
                          child: Text(
                            'edit_profile'.tr(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: Row(
                          children: [
                            Text(
                              'exit'.tr(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Tab Bar like Switcher
                Row(
                  children: [
                    _buildTabItem(
                      context,
                      0,
                      Icons.list,
                      'wish_list'.tr(),
                      state.selectedTabIndex == 0,
                    ),
                    _buildTabItem(
                      context,
                      1,
                      Icons.history,
                      'history'.tr(),
                      state.selectedTabIndex == 1,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tab Content Grid
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<ProfileCubit>().setTabIndex(index),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFFFC107) : Colors.white54,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFFC107) : Colors.white54,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 2,
              color: isSelected ? const Color(0xFFFFC107) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
