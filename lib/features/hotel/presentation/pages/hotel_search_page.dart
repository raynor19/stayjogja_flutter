import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/utils/location_helper.dart';
import 'package:stayjogja_flutter/core/utils/date_helper.dart';
import 'package:stayjogja_flutter/core/widgets/skeleton_loading.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/bloc/hotel_cubit.dart';

class HotelSearchPage extends StatefulWidget {
  final String? initialCheckIn;
  final String? initialCheckOut;

  const HotelSearchPage({
    super.key,
    this.initialCheckIn,
    this.initialCheckOut,
  });

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  final _searchCtrl = TextEditingController();
  late DateTime _checkIn;
  late DateTime _checkOut;
  final int _guests = 2;

  @override
  void initState() {
    super.initState();
    _checkIn = DateHelper.parseOrDefault(widget.initialCheckIn, DateHelper.defaultCheckIn);
    _checkOut = DateHelper.parseOrDefault(widget.initialCheckOut, DateHelper.defaultCheckOut);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    setState(() {}); // refresh suffix clear icon
    context.read<HotelCubit>().searchHotels(val);
  }

  void _clearSearch() {
    _searchCtrl.clear();
    setState(() {});
    context.read<HotelCubit>().searchHotels('');
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _checkIn, end: _checkOut),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.grey900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkIn = picked.start;
        _checkOut = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ─── Header: Back, Destination & Guest Subtitle, Map Icon ─
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.go(AppRoutes.home),
                  ),
                  InkWell(
                    onTap: _pickDateRange,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Column(
                        children: [
                          const Text(
                            'Yogyakarta, Indonesia',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.grey900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_month_rounded, size: 13, color: AppColors.emerald),
                              const SizedBox(width: 4),
                              Text(
                                '${DateHelper.formatDateRange(_checkIn, _checkOut)} • $_guests Tamu',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _circleButton(
                    icon: Icons.map_outlined,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Peta Hotel DIY: Gunakan tombol pin di tiap hotel untuk navigasi Google Maps 📍'),
                          backgroundColor: AppColors.emerald,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ─── Interactive Search Bar (Pencarian Hotel & Area) ─────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.grey200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Cari hotel, area (Malioboro, Sleman, dll)...',
                    hintStyle: const TextStyle(fontSize: 12, color: AppColors.grey400),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.grey600),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.grey600),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ─── Filter Pills Bar (Filter, Sort, Price range, Amenities)
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _filterPill(context, icon: Icons.tune_rounded, label: 'Filter', isFilter: true),
                  const SizedBox(width: 8),
                  _filterPill(context, icon: Icons.swap_vert_rounded, label: 'Sort', isSort: true),
                  const SizedBox(width: 8),
                  _filterPill(context, icon: Icons.attach_money_rounded, label: 'Rentang Harga', isFilter: true),
                  const SizedBox(width: 8),
                  _filterPill(context, icon: Icons.pool_rounded, label: 'Fasilitas & Bintang', isFilter: true),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ─── Hotel List with Shimmer Skeleton (Screen 2 Mockup Match) ───
            Expanded(
              child: BlocBuilder<HotelCubit, HotelState>(
                builder: (context, state) {
                  if (state is HotelLoading) {
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                      itemCount: 3,
                      itemBuilder: (_, __) => const HotelCardSkeleton(),
                    );
                  }

                  List<Hotel> hotels = [];
                  if (state is HotelLoaded) {
                    hotels = state.hotels;
                  }

                  if (hotels.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_rounded, size: 54, color: AppColors.grey400),
                          const SizedBox(height: 10),
                          const Text(
                            'Tidak ada hotel ditemukan untuk kata kunci ini',
                            style: TextStyle(fontFamily: 'Poppins', color: AppColors.grey600, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: _clearSearch,
                            child: const Text('Reset Pencarian'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 110), // Safe space for floating navbar
                    itemCount: hotels.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      return _HotelSearchCard(
                        hotel: hotels[index],
                        checkIn: _checkIn,
                        checkOut: _checkOut,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: AppColors.grey900),
        onPressed: onTap,
      ),
    );
  }

  Widget _filterPill(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isFilter = false,
    bool isSort = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (isFilter) {
          _showFilterSheet(context);
        } else if (isSort) {
          _showSortSheet(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.grey800),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.grey800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Filter Pencarian Hotel',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              const Text('Rentang Harga per Malam', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Rp 200.000', style: TextStyle(color: AppColors.grey600, fontSize: 12)),
                  Text('Rp 1.500.000+', style: TextStyle(color: AppColors.grey600, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Bintang Hotel', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: ['Semua', '3 ★', '4 ★', '5 ★'].map((s) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: s == 'Semua' ? AppColors.primary : AppColors.grey100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: s == 'Semua' ? AppColors.white : AppColors.grey800,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Terapkan Filter'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Urutkan Berdasarkan',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...HotelSortOption.values.map((sortOption) {
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    title: Text(sortOption.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey400, size: 20),
                    onTap: () {
                      context.read<HotelCubit>().sortHotels(sortOption);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _HotelSearchCard extends StatelessWidget {
  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;

  const _HotelSearchCard({
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Image Stack (Emerald price badge + Page indicator) ───
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: CachedNetworkImage(
                  imageUrl: hotel.images.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.grey100),
                  errorWidget: (_, __, ___) => Container(color: AppColors.grey200),
                ),
              ),
              // Emerald Price Badge
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.emerald,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Rp ${_formatK(hotel.startingPrice)}/night',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              // Image Counter Pill (e.g. 2/27)
              Positioned(
                bottom: 12,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '2/27',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ─── Content Details ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Star Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
                        const SizedBox(width: 4),
                        Text(
                          '${hotel.rating} (${hotel.totalReviews})',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Dynamic Pinpoint & Distance from Center
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.emerald),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        LocationHelper.getPinpointText(
                          area: hotel.area,
                          lat: hotel.latitude,
                          lng: hotel.longitude,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Amenities / Features + View Rooms Button Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Features Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _FeatureRow(icon: Icons.cancel_outlined, text: 'Free cancellation'),
                          SizedBox(height: 4),
                          _FeatureRow(icon: Icons.coffee_outlined, text: 'Breakfast included'),
                        ],
                      ),
                    ),

                    // Black Pill Button: View Rooms (Membawa parameter tanggal terpilih)
                    ElevatedButton(
                      onPressed: () {
                        final cinStr = DateHelper.formatDate(checkIn);
                        final coutStr = DateHelper.formatDate(checkOut);
                        context.push(
                          '/hotel/${hotel.id}?cin=${Uri.encodeComponent(cinStr)}&cout=${Uri.encodeComponent(coutStr)}',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'View Rooms',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatK(int price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    }
    return price.toString();
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.grey600),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }
}
