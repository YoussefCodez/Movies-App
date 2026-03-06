import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/explore/presentation/views/explore_tab.dart';
import 'package:movies/features/main/presentation/cubits/main_layout_cubit.dart';
import 'package:movies/features/home/presentation/views/home_tab.dart';
import 'package:movies/features/search/presentation/views/search_tab.dart';
import 'package:movies/features/profile/presentation/views/profile_tab.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  final List<Widget> tabs = const [
    HomeTab(),
    SearchTab(),
    ExploreTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainLayoutCubit(),
      child: BlocBuilder<MainLayoutCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: IndexedStack(index: selectedIndex, children: tabs),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF282A28),
                borderRadius: BorderRadius.circular(16),
              ),
              child: BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) =>
                    context.read<MainLayoutCubit>().changeTab(index),
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.white60,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/svgs/home.svg",
                      colorFilter: ColorFilter.mode(
                        selectedIndex == 0
                            ? const Color(0xFFFFC107)
                            : Colors.white60,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "home".tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/svgs/search.svg",
                      colorFilter: ColorFilter.mode(
                        selectedIndex == 1
                            ? const Color(0xFFFFC107)
                            : Colors.white60,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "search".tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/svgs/explore.svg",
                      colorFilter: ColorFilter.mode(
                        selectedIndex == 2
                            ? const Color(0xFFFFC107)
                            : Colors.white60,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "explore".tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/svgs/profile.svg",
                      colorFilter: ColorFilter.mode(
                        selectedIndex == 3
                            ? const Color(0xFFFFC107)
                            : Colors.white60,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "profile".tr(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
