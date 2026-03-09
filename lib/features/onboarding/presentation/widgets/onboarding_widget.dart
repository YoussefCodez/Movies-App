import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/onboarding_entity.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingEntity page;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool isFirst;
  final int index;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    required this.onNext,
    this.onBack,
    this.isFirst = false,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      return _buildFirstScreen(context);
    } else {
      return _buildStandardScreen(context);
    }
  }

  Widget _buildFirstScreen(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(page.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.3, 0.9],
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.95),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Spacer(flex: 7), // Positions text roughly at 60-70% height
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              page.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                height: 1.4,
              ),
            ),
            const Spacer(flex: 1),
            _buildButton(
              text: page.buttonText,
              onPressed: onNext,
              color: const Color(0xFFFFC107),
              textColor: Colors.black,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardScreen(BuildContext context) {
    final bool showBack = onBack != null && index != 1;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(page.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1C1A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (page.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    page.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                _buildButton(
                  text: page.buttonText,
                  onPressed: onNext,
                  color: const Color(0xFFFFC107),
                  textColor: Colors.black,
                ),
                if (showBack) ...[
                  const SizedBox(height: 12),
                  _buildButton(
                    text: 'Back',
                    onPressed: onBack!,
                    color: Colors.transparent,
                    textColor: const Color(0xFFFFC107),
                    isOutlined: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                side: BorderSide(color: textColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: textColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
