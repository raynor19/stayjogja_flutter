import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2300));
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Luxury mint pastel canvas
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient soft glowing orbs in the background
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emerald.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.40),
              ),
            ),
          ),

          // Center Logo & Title
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ─── Liquid Glass Frame with Stay Jogja Logo ───────
                    Container(
                      width: 130,
                      height: 130,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F2618).withValues(alpha: 0.10),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.9),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.95),
                          width: 1.5,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/logo_emblem.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Official Stay Jogja Branding
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'STAY',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1B3D6D), // Official Navy Blue
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'JOGJA',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFDE641C), // Official Orange
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Hotel & AI Trip Planner',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Region Pill
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                ),
                child: const Text(
                  'Yogyakarta, Indonesia',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
