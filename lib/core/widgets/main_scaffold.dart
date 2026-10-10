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
      extendBody: true, // Konten layar meluncur bebas di bawah floating liquid dock
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: _CustomLiquidGlassDock(
            selectedIndex: selectedIndex,
            onTap: (index) => _onTap(context, index),
          ),
        ),
      ),
    );
  }
}

class _DockItemData {
  final IconData icon;
  final String label;
  const _DockItemData({required this.icon, required this.label});
}

class _CustomLiquidGlassDock extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _CustomLiquidGlassDock({
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    _DockItemData(icon: Icons.home_rounded, label: 'Home'),
    _DockItemData(icon: Icons.search_rounded, label: 'Search'),
    _DockItemData(icon: Icons.calendar_month_rounded, label: 'Bookings'),
    _DockItemData(icon: Icons.person_rounded, label: 'Account'),
    _DockItemData(icon: Icons.auto_awesome_rounded, label: 'AI Trip'),
  ];

  @override
  Widget build(BuildContext context) {
    const dockHeight = 64.0;
    const dockRadius = 32.0;

    return Center(
      heightFactor: 1.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 370),
        child: Container(
          height: dockHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dockRadius),
            boxShadow: [
              // Ambient soft environment drop shadow
              BoxShadow(
                color: const Color(0xFF0F2618).withValues(alpha: 0.12),
                blurRadius: 32,
                spreadRadius: 1,
                offset: const Offset(0, 10),
              ),
              // Soft direct contact reflection
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.70),
                blurRadius: 10,
                offset: const Offset(0, -1),
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
                          Colors.white.withValues(alpha: 0.78),
                          Colors.white.withValues(alpha: 0.46),
                          Colors.white.withValues(alpha: 0.65),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                      // Directional Specular Rim
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
                            // ─── Morphing Active Pill (Icon Only Inside) ───
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutBack, // Fluid spring feel
                              left: selectedIndex * tabWidth,
                              top: 2,
                              bottom: 2,
                              width: tabWidth,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  // Emerald liquid droplet tint
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.emerald.withValues(alpha: 0.20),
                                      AppColors.emerald.withValues(alpha: 0.08),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: AppColors.emerald.withValues(alpha: 0.35),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.emerald.withValues(alpha: 0.20),
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

                            // ─── Interactive Items Row ─────────────────────────
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
                                      // Tab AKTIF: Hanya Ikon Saja (Pill shape, centered sempurna)
                                      // Tab NON-AKTIF: Ikon + Text Label di bawahnya
                                      child: isSelected
                                          ? AnimatedScale(
                                              duration: const Duration(milliseconds: 200),
                                              scale: 1.15,
                                              curve: Curves.easeOutCubic,
                                              child: Icon(
                                                item.icon,
                                                size: 26,
                                                color: AppColors.emerald,
                                              ),
                                            )
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  item.icon,
                                                  size: 20,
                                                  color: const Color(0xFF6F7673),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  item.label,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF6F7673),
                                                    letterSpacing: -0.2,
                                                  ),
                                                ),
                                              ],
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
