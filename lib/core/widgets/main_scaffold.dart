import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.search)) return 1;
    if (location.startsWith(AppRoutes.bookings)) return 2;
    if (location.startsWith(AppRoutes.profile)) return 3;
    if (location.startsWith('/more') || location.startsWith(AppRoutes.itineraryList)) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.search);
      case 2:
        context.go(AppRoutes.bookings);
      case 3:
        context.go(AppRoutes.profile);
      case 4:
        context.go(AppRoutes.itineraryList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true, // Content gracefully flows underneath the floating liquid dock
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: _AwardWinningLiquidDock(
            selectedIndex: selectedIndex,
            onTap: (index) => _onTap(context, index),
          ),
        ),
      ),
    );
  }
}

class _AwardWinningLiquidDock extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _AwardWinningLiquidDock({
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.calendar_month_rounded,
    Icons.person_rounded,
    Icons.auto_awesome_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    const dockHeight = 62.0;
    const dockRadius = 31.0;

    return Center(
      heightFactor: 1.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          height: dockHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dockRadius),
            boxShadow: [
              // Tinted organic environment drop shadow (gives pure floating depth)
              BoxShadow(
                color: const Color(0xFF0F2618).withValues(alpha: 0.12),
                blurRadius: 32,
                spreadRadius: 1,
                offset: const Offset(0, 10),
              ),
              // Soft direct contact shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(dockRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Stack(
                children: [
                  // ─── 1. Base Liquid Transmission Layer ──────────────────
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(dockRadius),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.76),
                          Colors.white.withValues(alpha: 0.44),
                          Colors.white.withValues(alpha: 0.62),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                      // Specular Rim: Top-left light catch
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.85),
                        width: 1.2,
                      ),
                    ),
                  ),

                  // ─── 2. Specular Meniscus Sheen (Kaca Melengkung) ────────
                  Positioned(
                    top: 1,
                    left: 24,
                    right: 24,
                    height: 22,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.60),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ─── 3. Viscous Morphing Lens & Interactive Tabs ─────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final tabWidth = constraints.maxWidth / _items.length;

                        return Stack(
                          children: [
                            // ─── Morphing Liquid Lens (Springs to active tab) ──
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 320),
                              curve: Curves.easeOutBack, // Viscous bouncy spring feel
                              left: selectedIndex * tabWidth,
                              top: 0,
                              bottom: 0,
                              width: tabWidth,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  // Emerald liquid droplet tint
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.emerald.withValues(alpha: 0.16),
                                      AppColors.emerald.withValues(alpha: 0.06),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: AppColors.emerald.withValues(alpha: 0.28),
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.emerald.withValues(alpha: 0.18),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(alpha: 0.70),
                                      blurRadius: 2,
                                      offset: const Offset(0, -1),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ─── Interactive Items ─────────────────────────────
                            Row(
                              children: List.generate(_items.length, (index) {
                                final item = _items[index];
                                final isSelected = selectedIndex == index;

                                return Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      if (!isSelected) {
                                        HapticFeedback.selectionClick();
                                        onTap(index);
                                      }
                                    },
                                    child: Center(
                                      child: AnimatedScale(
                                        duration: const Duration(milliseconds: 200),
                                        scale: isSelected ? 1.12 : 1.0,
                                        curve: Curves.easeOutCubic,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              item,
                                              size: isSelected ? 24 : 22,
                                              color: isSelected
                                                  ? AppColors.emerald
                                                  : const Color(0xFF6F7673),
                                            ),
                                            // Glowing Micro-Bead for active indicator
                                            AnimatedContainer(
                                              duration: const Duration(milliseconds: 250),
                                              curve: Curves.easeOutCubic,
                                              margin: const EdgeInsets.only(top: 4),
                                              width: isSelected ? 4 : 0,
                                              height: isSelected ? 4 : 0,
                                              decoration: BoxDecoration(
                                                color: AppColors.emerald,
                                                shape: BoxShape.circle,
                                                boxShadow: isSelected
                                                    ? [
                                                        BoxShadow(
                                                          color: AppColors.emerald.withValues(alpha: 0.6),
                                                          blurRadius: 4,
                                                          spreadRadius: 1,
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
