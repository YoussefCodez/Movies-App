import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/main_layout_view_model.dart';
import '../home/home_tab.dart';
import '../search/search_tab.dart';

import '../profile/profile_tab.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of tabs corresponding to the bottom navigation bar
    final List<Widget> tabs = [
      const HomeTab(),
      const SearchTab(),
      const Center(child: Text('Browse Tab', style: TextStyle(color: Colors.white, fontSize: 24))),
      const ProfileTab(),
    ];

    return ChangeNotifierProvider(
      create: (_) => MainLayoutViewModel(),
      child: Consumer<MainLayoutViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            // We do not want an AppBar for the Home/Main screens usually in this design
            body: SafeArea(
              child: IndexedStack(
                index: viewModel.selectedIndex,
                children: tabs,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: viewModel.selectedIndex,
              onTap: viewModel.changeTab,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Browse'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          );
        },
      ),
    );
  }
}
