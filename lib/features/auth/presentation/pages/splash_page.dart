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
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    context.go(AppRoutes.onboarding);
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
              width: 220,
              height: 220,
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
                    // ─── Liquid Glass Logo Emblem ────────────────────────
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F2618).withValues(alpha: 0.10),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.90),
                                  Colors.white.withValues(alpha: 0.55),
                                  Colors.white.withValues(alpha: 0.75),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.95),
                                width: 1.5,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.hotel_rounded,
                                size: 48,
                                color: AppColors.emerald,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title with Emerald Dot
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'STAY JOGJA',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.grey900,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '•',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.emerald,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Hotel & AI Trip Planner',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Version / Region Tag
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                ),
                child: const Text(
                  'Yogyakarta, Indonesia',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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
