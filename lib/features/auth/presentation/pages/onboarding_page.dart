import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';

class _OnboardingItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;

  const _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
  });
}

const _items = [
  _OnboardingItem(
    title: 'Temukan Hotel\nTerbaik di Jogja',
    subtitle: 'Ratusan pilihan hotel dan penginapan di Yogyakarta dengan harga terbaik untuk semua anggaran.',
    icon: Icons.hotel_rounded,
    iconBg: AppColors.primaryLight,
  ),
  _OnboardingItem(
    title: 'Pesan & Bayar\nMudah dan Aman',
    subtitle: 'Booking instan dengan berbagai metode pembayaran — GoPay, OVO, DANA, QRIS, dan kartu kredit.',
    icon: Icons.payment_rounded,
    iconBg: AppColors.accent,
  ),
  _OnboardingItem(
    title: 'AI Trip Planner\nKhusus Jogja',
    subtitle: 'Setelah booking, AI kami otomatis menyusun itinerary harian lengkap dengan atraksi, kuliner, dan rute terbaik dari hotelmu.',
    icon: Icons.auto_awesome_rounded,
    iconBg: AppColors.highlight,
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingDone, true);
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  void _next() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skip() => _finishOnboarding();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _items.length - 1;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _skip,
                child: const Text('Lewati'),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) => _OnboardingCard(item: _items[i]),
              ),
            ),

            // Dots + CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _items.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.grey200,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _next,
                    child: Text(isLast ? 'Mulai Sekarang' : 'Lanjut'),
                  ),
                  if (!isLast) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _skip,
                      child: const Text('Masuk ke akun saya'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  final _OnboardingItem item;
  const _OnboardingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: item.iconBg.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 72, color: item.iconBg),
          ),
          const SizedBox(height: 40),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.primary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
