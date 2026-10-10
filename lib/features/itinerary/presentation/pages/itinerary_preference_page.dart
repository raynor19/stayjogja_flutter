import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';

class ItineraryPreferencePage extends StatefulWidget {
  final String hotelId;
  const ItineraryPreferencePage({super.key, required this.hotelId});

  @override
  State<ItineraryPreferencePage> createState() => _ItineraryPreferencePageState();
}

class _ItineraryPreferencePageState extends State<ItineraryPreferencePage> {
  int _days = 3;
  String _pace = 'santai'; // 'santai' / 'padat'
  final Set<String> _selectedInterests = {'Budaya & Sejarah', 'Kuliner Khas'};
  String _groupType = 'Keluarga';

  final List<String> _interestOptions = [
    'Budaya & Sejarah',
    'Kuliner Khas',
    'Wisata Alam',
    'Spot Foto & Estetik',
    'Belanja & Oleh-oleh',
    'Kafe & Nongkrong',
    'Hiburan Malam',
  ];

  final List<String> _groupOptions = ['Solo', 'Pasangan', 'Keluarga', 'Teman-teman'];

  @override
  Widget build(BuildContext context) {
    final hotel = MockData.hotels.firstWhere(
      (h) => h.id == widget.hotelId,
      orElse: () => MockData.hotels.first,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Preferensi AI Trip'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel anchor banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.hotel_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Titik Awal & Akhir: ${hotel.name}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Kawasan ${hotel.area} — Rute AI disusun dari sini',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lama Menginap
            Text('Lama Menginap', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [1, 2, 3, 4, 5].map((d) {
                final isSelected = _days == d;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _days = d),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.grey50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.grey200,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$d Hari',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isSelected ? AppColors.white : AppColors.grey800,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Tempo Perjalanan
            Text('Tempo Perjalanan', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPaceCard(
                    title: 'Santai ☕',
                    subtitle: 'Maks. 3-4 tempat/hari\nFokus menikmati suasana',
                    value: 'santai',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPaceCard(
                    title: 'Padat ⚡',
                    subtitle: 'Maks. 5-7 tempat/hari\nBanyak spot dalam sehari',
                    value: 'padat',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Minat & Preferensi Wisata
            Text('Minat & Kategori Wisata', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _interestOptions.map((opt) {
                final isSelected = _selectedInterests.contains(opt);
                return FilterChip(
                  label: Text(opt),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedInterests.add(opt);
                      } else {
                        _selectedInterests.remove(opt);
                      }
                    });
                  },
                  selectedColor: AppColors.accent,
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.grey800,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Tipe Rombongan
            Text('Tipe Rombongan', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _groupOptions.map((g) {
                final isSelected = _groupType == g;
                return ChoiceChip(
                  label: Text(g),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _groupType = g);
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.grey800,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 36),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                context.push(
                  '${AppRoutes.itineraryGenerate}?hotelId=${hotel.id}&days=$_days&pace=$_pace',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.auto_awesome, size: 20),
                  SizedBox(width: 8),
                  Text('Generate AI Itinerary Sekarang'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaceCard({required String title, required String subtitle, required String value}) {
    final isSelected = _pace == value;
    return GestureDetector(
      onTap: () => setState(() => _pace = value),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isSelected ? AppColors.primary : AppColors.grey900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: AppColors.grey600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
