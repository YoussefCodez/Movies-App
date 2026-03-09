import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingPageChanged) {
            _pageController.animateToPage(
              state.index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else if (state is OnboardingCompleted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Scaffold(
          body: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              final cubit = context.read<OnboardingCubit>();
              return PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cubit.onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = cubit.onboardingPages[index];
                  return OnboardingPageWidget(
                    page: page,
                    index: index,
                    onNext: () => cubit.next(),
                    onBack: index > 0 ? () => cubit.back() : null,
                    isFirst: index == 0,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
