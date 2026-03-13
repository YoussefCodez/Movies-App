import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies/features/profile/presentation/manager/profile_cubit.dart';
import 'package:movies/features/profile/presentation/manager/profile_state.dart';
import 'package:movies/features/profile/presentation/views/update_profile_screen.dart';
import 'package:movies/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:movies/features/wishlist/presentation/manager/wishlist_state.dart';
import 'package:movies/features/history/presentation/manager/history_cubit.dart';
import 'package:movies/features/history/presentation/manager/history_state.dart';
import 'package:movies/features/movies/domain/entities/movie_entity.dart';
import 'package:movies/core/utils/hive_service.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    if (context.read<ProfileCubit>().state is! ProfileLoaded) {
      context.read<ProfileCubit>().loadProfile();
    }
    context.read<WishlistCubit>().getWishlist();
    context.read<HistoryCubit>().getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (profileState is ProfileError) {
          return Center(
            child: Text(
              profileState.message,
              style: const TextStyle(color: AppColors.white),
            ),
          );
        }

        if (profileState is ProfileLoaded) {
          final user = profileState.user;
          return Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(user.avatarPath),
                      backgroundColor: AppColors.inputBackgroundDark,
                      onBackgroundImageError: (error, stackTrace) => const Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 40),
                    BlocBuilder<WishlistCubit, WishlistState>(
                      builder: (context, state) {
                        String count = '0';
                        if (state is WishlistLoaded) {
                          count = state.movies.length.toString();
                        } else if (state is WishlistLoading ||
                            state is WishlistInitial) {
                          count = '...';
                        }
                        return _buildStatItem(count, 'wish_list'.tr());
                      },
                    ),
                    const SizedBox(width: 40),
                    BlocBuilder<HistoryCubit, HistoryState>(
                      builder: (context, state) {
                        String count = '0';
                        if (state is HistoryLoaded) {
                          count = state.movies.length.toString();
                        } else if (state is HistoryLoading ||
                            state is HistoryInitial) {
                          count = '...';
                        }
                        return _buildStatItem(count, 'history'.tr());
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpdateProfileScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('edit_profile'.tr()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _showExitConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('exit'.tr()),
                          const SizedBox(width: 8),
                          const Icon(Icons.logout, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildTabButton(0, Icons.bookmark, 'watch_list'.tr()),
                  _buildTabButton(1, Icons.history, 'history'.tr()),
                ],
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(child: _buildGridContent()),
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTabButton(int index, IconData icon, String label) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : Colors.white60,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.white60,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridContent() {
    if (_selectedTabIndex == 0) {
      return BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is WishlistLoaded) {
            return _buildMoviesGrid(state.movies);
          } else if (state is WishlistError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.red),
              ),
            );
          }
          return _buildEmptyState();
        },
      );
    } else {
      return BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is HistoryLoaded) {
            return _buildMoviesGrid(state.movies);
          } else if (state is HistoryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.red),
              ),
            );
          }
          return _buildEmptyState();
        },
      );
    }
  }

  Widget _buildMoviesGrid(List<MovieEntity> movies) {
    if (movies.isEmpty) return _buildEmptyState();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/movie-details', arguments: movie);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.network(
                  movie.mediumCoverImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(color: Colors.white10);
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.movie, color: Colors.white24),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.primary,
                          size: 10,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          movie.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.movie_creation_outlined,
            size: 80,
            color: Colors.white24,
          ),
          const SizedBox(height: 10),
          Text('no_data'.tr(), style: const TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.inputBackgroundDark,
          title: Text(
            'exit'.tr(),
            style: const TextStyle(color: AppColors.white),
          ),
          content: Text(
            'are_you_sure_exit'.tr(),
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
              onPressed: () async {
                Navigator.pop(dialogContext);
                await HiveService.clearAllBoxes();
                if (context.mounted) {
                  context.read<WishlistCubit>().reset();
                  context.read<HistoryCubit>().reset();
                  context.read<ProfileCubit>().reset();
                  context.read<AuthCubit>().signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: Text(
                'exit'.tr(),
                style: const TextStyle(color: AppColors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
