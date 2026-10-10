import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, Traveler! 👋',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Mau ke mana hari ini?',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: AppColors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                height: 0,
                color: AppColors.primary,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Search Bar ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _SearchCard(),
                ),

                const SizedBox(height: 24),

                // ── Area populer chips ────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Area Populer',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: AppConstants.popularAreas.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => _AreaChip(
                      label: AppConstants.popularAreas[i],
                      isSelected: i == 0,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Penawaran unggulan ────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Penawaran Unggulan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Lihat semua'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, i) => _HotelCard(index: i),
                  ),
                ),

                const SizedBox(height: 24),

                // ── AI Itinerary Banner ───────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ItineraryBanner(),
                ),

                const SizedBox(height: 24),

                // ── Hotel terdekat ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hotel di Malioboro',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Lihat semua'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _HotelListCard(index: i),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search Card ────────────────────────────────────────────────────────────
class _SearchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Destinasi
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
            ),
            title: Text(
              'Destinasi',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.grey600),
            ),
            subtitle: Text(
              'Yogyakarta, Indonesia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          // Tanggal
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calendar_today_outlined, color: AppColors.accent, size: 20),
                  ),
                  title: Text(
                    'Check-in',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.grey600),
                  ),
                  subtitle: Text(
                    'Pilih tanggal',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onTap: () {},
                ),
              ),
              Container(width: 1, height: 48, color: AppColors.divider),
              Expanded(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calendar_month_outlined, color: AppColors.accent, size: 20),
                  ),
                  title: Text(
                    'Check-out',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.grey600),
                  ),
                  subtitle: Text(
                    'Pilih tanggal',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          // Tamu
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.highlight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.people_outline, color: AppColors.grey800, size: 20),
            ),
            title: Text(
              'Tamu & Kamar',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.grey600),
            ),
            subtitle: Text(
              '2 tamu, 1 kamar',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: AppColors.accent,
                ),
                child: const Text('Cari', style: TextStyle(fontSize: 14)),
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ── Area Chip ──────────────────────────────────────────────────────────────
class _AreaChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _AreaChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {},
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isSelected ? AppColors.white : AppColors.grey800,
      ),
    );
  }
}

// ── Hotel Card (horizontal scroll) ─────────────────────────────────────────
class _HotelCard extends StatelessWidget {
  final int index;
  const _HotelCard({required this.index});

  static const _names = [
    'Grand Malioboro Hotel',
    'Prawirotaman Boutique',
    'Kaliurang Resort',
    'Sleman City Hotel',
    'Kraton Heritage Inn',
  ];
  static const _areas = ['Malioboro', 'Prawirotaman', 'Kaliurang', 'Sleman', 'Kraton'];
  static const _prices = [450000, 380000, 620000, 290000, 510000];
  static const _ratings = [4.8, 4.6, 4.9, 4.5, 4.7];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final hotelId = index < MockData.hotels.length ? MockData.hotels[index].id : 'htl-1';
        context.push('/hotel/$hotelId');
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 140,
                color: AppColors.primary.withValues(alpha: 0.1 + index * 0.05),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.hotel_rounded,
                        size: 48,
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    // Badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          index == 0 ? 'Best Value' : index == 1 ? 'Free Cancel' : 'Popular',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _names[index],
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: AppColors.grey600),
                      const SizedBox(width: 2),
                      Text(
                        _areas[index],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.highlight),
                      const SizedBox(width: 2),
                      Text(
                        '${_ratings[index]}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Rp ${_formatPrice(_prices[index])}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                        TextSpan(
                          text: '/malam',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

// ── AI Itinerary Banner ─────────────────────────────────────────────────────
class _ItineraryBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✨ AI Trip Planner',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Biarkan AI\nsusun rencana\nperjalananmu!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () {
                    context.push('${AppRoutes.itineraryPreference}?hotelId=htl-1');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text(
                    'Buat Itinerary',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.auto_awesome_rounded,
            size: 80,
            color: AppColors.highlight,
          ),
        ],
      ),
    );
  }
}

// ── Hotel List Card (vertical) ──────────────────────────────────────────────
class _HotelListCard extends StatelessWidget {
  final int index;
  const _HotelListCard({required this.index});

  static const _names = [
    'Grand Malioboro Hotel',
    'Prawirotaman Boutique',
    'Kaliurang Resort',
  ];
  static const _areas = ['Malioboro', 'Prawirotaman', 'Kaliurang'];
  static const _prices = [450000, 380000, 620000];
  static const _ratings = [4.8, 4.6, 4.9];
  static const _reviews = [312, 189, 95];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final hotelId = index < MockData.hotels.length ? MockData.hotels[index].id : 'htl-1';
        context.push('/hotel/$hotelId');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Container(
                width: 110,
                height: 110,
                color: AppColors.primary.withValues(alpha: 0.1 + index * 0.05),
                child: Center(
                  child: Icon(
                    Icons.hotel_rounded,
                    size: 40,
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _names[index],
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: AppColors.grey600),
                        const SizedBox(width: 2),
                        Text(_areas[index], style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppColors.highlight),
                        const SizedBox(width: 4),
                        Text(
                          '${_ratings[index]} (${_reviews[index]} ulasan)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Rp ${_formatPrice(_prices[index])}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                              TextSpan(
                                text: '/mlm',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Pilih',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
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

  String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}
