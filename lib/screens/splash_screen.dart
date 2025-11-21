import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'onboarding_screen.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentTheme.primaryGradient,
        ),
        child: Stack(
          children: [
            // Animated background elements
            ...List.generate(20, (index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    left: (index * 50.0) % MediaQuery.of(context).size.width,
                    top: (sin(_controller.value * 2 * pi + index) * 200 + 300),
                    child: Opacity(
                      opacity: 0.2,
                      child: Text(
                        themeProvider.currentTheme.emoji,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  );
                },
              );
            }),
            // Main content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.2).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: const Text(
                        'Veuolla 💛',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Cursive',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Sunflower Pods',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      themeProvider.currentTheme.emoji,
                      style: const TextStyle(fontSize: 100),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        "Let's connect your Funpods",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
  }
}
