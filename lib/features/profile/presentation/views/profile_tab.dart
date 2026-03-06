import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../view_models/profile_view_model.dart';
import '../../../data/repositories/mock_profile_repository.dart';
import 'update_profile_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(MockProfileRepository()),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.userProfile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = viewModel.userProfile;
          if (user == null) {
            return const Center(child: Text('Error loading profile', style: TextStyle(color: Colors.white)));
          }

          return Column(
            children: [
              const SizedBox(height: 20),
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(user.avatarPath),
                      backgroundColor: Colors.grey[800],
                      onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(width: 40),
                    _buildStatItem(user.wishList.length.toString(), 'wish_list'.tr()),
                    const SizedBox(width: 40),
                    _buildStatItem(user.history.length.toString(), 'history'.tr()),
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
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Action Buttons
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
                              builder: (context) => ChangeNotifierProvider.value(
                                value: viewModel,
                                child: const UpdateProfileScreen(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('edit_profile'.tr()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                         // Logout logic later
                         Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

              // Tabs (Watch List / History)
              Row(
                children: [
                  _buildTabButton(context, viewModel, 0, Icons.list, 'watch_list'.tr()),
                  _buildTabButton(context, viewModel, 1, Icons.folder, 'history'.tr()),
                ],
              ),
              const Divider(color: Colors.white24, height: 1),

              // Grid Content
              Expanded(
                child: _buildGridContent(viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _buildTabButton(BuildContext context, ProfileViewModel viewModel, int index, IconData icon, String label) {
    final isSelected = viewModel.selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => viewModel.setTabIndex(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFFFFC107) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? const Color(0xFFFFC107) : Colors.white60, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFFFC107) : Colors.white60,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridContent(ProfileViewModel viewModel) {
    final list = viewModel.selectedTabIndex == 0 
        ? viewModel.userProfile!.wishList 
        : viewModel.userProfile!.history;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.movie_creation_outlined, size: 100, color: Colors.white24),
            const SizedBox(height: 10),
            Text('no_data'.tr(), style: const TextStyle(color: Colors.white24)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            list[index],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey[800]),
          ),
        );
      },
    );
  }
}
