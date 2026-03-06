import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:movies/features/profile/presentation/views/update_profile_screen.dart';
import 'package:movies/core/services/get_it.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is SignOutError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.isLoading && state.user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = state.user;
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
                              backgroundImage: const AssetImage(
                                'assets/images/avatar1.png',
                              ), // Default for now
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user.displayName ?? "No Name",
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
                                (user.wishList?.length ?? 0).toString(),
                                'wish_list'.tr(),
                              ),
                              _buildStatColumn(
                                "0", // Placeholder for history
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
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, authState) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: authState is SignOutLoading
                                  ? null
                                  : () => context.read<AuthCubit>().signOut(),
                              child: authState is SignOutLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          'exit'.tr(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.exit_to_app,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                            );
                          },
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

                  // Tab Content
                  if (state.selectedTabIndex == 0)
                    user.wishList == null || user.wishList!.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Text(
                                "No Wish List Added",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: user.wishList!.length,
                            itemBuilder: (context, index) {
                              // Since these are URLs for now
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  user.wishList![index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[850],
                                    child: const Icon(
                                      Icons.movie,
                                      color: Colors.white24,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                  else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          "No Watch History",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
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
