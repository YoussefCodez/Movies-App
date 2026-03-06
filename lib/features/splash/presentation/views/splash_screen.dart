import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start splash logic post-frame to ensure Context is valid
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().initSplash(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Center Play Logo (Using Icon as placeholder for now, 
          // but should be Image.asset eventually once logo is available)
          Center(
            child: Icon(
              Icons.play_circle_outline, 
              size: 150, 
              color: Theme.of(context).primaryColor,
            ),
          ),
          // Route Footer
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   // Image.asset('assets/images/route_logo.png')
                  Text('Route', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Supervised by Mohamed Nabil', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
