import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';

class MockData {
  MockData._();

  // ─── HOTELS JOGJA ────────────────────────────────────────────────────────
  static final List<Hotel> hotels = [
    Hotel(
      id: 'htl-1',
      name: 'Grand Malioboro Heritage Hotel',
      area: 'Malioboro',
      address: 'Jl. Malioboro No. 52-58, Sosromenduran, Gedong Tengen, Yogyakarta',
      latitude: -7.7928,
      longitude: 110.3658,
      rating: 4.8,
      totalReviews: 1240,
      star: 4,
      startingPrice: 520000,
      badge: 'Best Value',
      description:
          'Terletak strategis di jantung Malioboro, hanya 3 menit jalan kaki ke Stasiun Tugu dan Pasar Beringharjo. Menggabungkan arsitektur kolonial klasik dengan kenyamanan modern Jogja.',
      policy:
          'Check-in mulai 14.00, check-out maksimal 12.00. Pembatalan gratis hingga 24 jam sebelum check-in.',
      images: [
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
        'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800',
        'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
      ],
      facilities: ['WiFi Gratis', 'Kolam Renang', 'Restoran Khas Jogja', 'Parkir Gratis', 'Spa', 'AC'],
      rooms: [
        RoomType(
          id: 'rm-101',
          hotelId: 'htl-1',
          name: 'Deluxe Heritage King',
          description: 'Kamar luas 32 m² dengan kasur King Size, balkon pemandangan kota Malioboro.',
          capacity: 2,
          pricePerNight: 520000,
          originalPrice: 650000,
          stock: 4,
          cancellationPolicy: 'Gratis pembatalan s/d H-1',
          hasBreakfast: true,
          facilities: ['1 King Bed', '32 m²', 'Balkon', 'Sarapan Termasuk', 'Free WiFi', 'Kamar Mandi Pribadi'],
          images: ['https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800'],
        ),
        RoomType(
          id: 'rm-102',
          hotelId: 'htl-1',
          name: 'Executive Suite Malioboro',
          description: 'Suite mewah 48 m² dengan ruang tamu terpisah, bathtub, dan pemandangan Gunung Merapi.',
          capacity: 3,
          pricePerNight: 890000,
          originalPrice: 1100000,
          stock: 2,
          cancellationPolicy: 'Gratis pembatalan s/d H-1',
          hasBreakfast: true,
          facilities: ['1 King Bed + Daybed', '48 m²', 'Bathtub', 'Sarapan Prasmanan', 'Lounge VIP'],
          images: ['https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800'],
        ),
      ],
    ),
    Hotel(
      id: 'htl-2',
      name: 'Prawirotaman Arts & Boutique Villa',
      area: 'Prawirotaman',
      address: 'Jl. Prawirotaman I No. 30, Brontokusuman, Mergangsan, Yogyakarta',
      latitude: -7.8188,
      longitude: 110.3695,
      rating: 4.7,
      totalReviews: 860,
      star: 4,
      startingPrice: 420000,
      badge: 'Popular',
      description:
          'Surga bagi pecinta seni dan backpacker berkelas. Terletak di kawasan legendaris Prawirotaman yang dipenuhi kafe estetik, galeri seni, dan sentra batik klasik.',
      policy: 'Check-in 14.00, check-out 12.00. Non-smoking room.',
      images: [
        'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
        'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
      ],
      facilities: ['Kolam Renang Tropis', 'Kafe Seni', 'Sewa Sepeda', 'WiFi Super Cepat', 'Bar'],
      rooms: [
        RoomType(
          id: 'rm-201',
          hotelId: 'htl-2',
          name: 'Bohemian Garden Room',
          description: 'Akses langsung ke kolam renang tropis dan taman asri, dekorasi karya seniman Jogja.',
          capacity: 2,
          pricePerNight: 420000,
          originalPrice: 500000,
          stock: 3,
          cancellationPolicy: 'Kebijakan fleksibel',
          hasBreakfast: false,
          facilities: ['1 Queen Bed', '26 m²', 'Akses Kolam Renang', 'WiFi 100 Mbps'],
          images: ['https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800'],
        ),
      ],
    ),
    Hotel(
      id: 'htl-3',
      name: 'Merapi View Resort & Spa',
      area: 'Kaliurang',
      address: 'Jl. Kaliurang KM 22, Hargobinangun, Pakem, Sleman, Yogyakarta',
      latitude: -7.5989,
      longitude: 110.4243,
      rating: 4.9,
      totalReviews: 610,
      star: 5,
      startingPrice: 780000,
      badge: 'Member Exclusive',
      description:
          'Udara sejuk pegunungan dengan pemandangan megah Gunung Merapi di pagi hari. Cocok untuk liburan keluarga atau retret menenangkan diri dari hiruk pikuk kota.',
      policy: 'Check-in 15.00, check-out 12.00.',
      images: [
        'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
        'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800',
      ],
      facilities: ['Infinity Pool Merapi', 'Spa Tradisional Jawa', 'Restoran Kebun', 'Area Outbound', 'Api Unggun'],
      rooms: [
        RoomType(
          id: 'rm-301',
          hotelId: 'htl-3',
          name: 'Mountain Panorama Villa',
          description: 'Balkon pribadi menghadap puncak Merapi, perapian mini, dan teh herbal lokal gratis.',
          capacity: 4,
          pricePerNight: 780000,
          originalPrice: 950000,
          stock: 2,
          cancellationPolicy: 'Gratis pembatalan s/d 48 jam',
          hasBreakfast: true,
          facilities: ['2 Queen Beds', '55 m²', 'View Gunung Merapi', 'Sarapan Keluarga Termasuk', 'Perapian'],
          images: ['https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800'],
        ),
      ],
    ),
  ];

  // ─── ATTRACTIONS JOGJA TERKURASI (RAG Database) ───────────────────────────
  static final List<Attraction> attractions = [
    Attraction(
      id: 'atr-1',
      name: 'Kraton Ngayogyakarta Hadiningrat',
      category: AttractionCategory.wisata,
      description: 'Istana resmi Kesultanan Ngayogyakarta Hadiningrat, pusat kebudayaan Jawa yang adiluhung.',
      latitude: -7.8053,
      longitude: 110.3642,
      openingHours: '08:30 - 14:00 (Tutup Senin)',
      ticketPrice: 25000,
      estimatedDurationMinutes: 90,
      distanceFromHotelKm: 1.8,
      travelTimeMinutes: 8,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1596402184320-417e7178b2cd?w=600',
    ),
    Attraction(
      id: 'atr-2',
      name: 'Taman Sari Water Castle',
      category: AttractionCategory.wisata,
      description: 'Bekas kebun istana pemandian putri raja dengan lorong bawah tanah Masjid Sumur Gumuling.',
      latitude: -7.8099,
      longitude: 110.3592,
      openingHours: '09:00 - 15:00',
      ticketPrice: 15000,
      estimatedDurationMinutes: 75,
      distanceFromHotelKm: 2.3,
      travelTimeMinutes: 10,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?w=600',
    ),
    Attraction(
      id: 'atr-3',
      name: 'Gudeg Yu Djum Wijilan',
      category: AttractionCategory.kuliner,
      description: 'Kuliner legendaris nangka muda bumbu areh khas Jogja yang telah bertahan sejak 1951.',
      latitude: -7.8041,
      longitude: 110.3686,
      openingHours: '06:00 - 22:00',
      ticketPrice: 35000,
      estimatedDurationMinutes: 45,
      distanceFromHotelKm: 1.5,
      travelTimeMinutes: 6,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600',
    ),
    Attraction(
      id: 'atr-4',
      name: 'Pasar Beringharjo & Malioboro Walk',
      category: AttractionCategory.belanja,
      description: 'Pusat belanja batik, suvenir, kerajinan perak, dan jajanan pasar terbesar di Yogyakarta.',
      latitude: -7.7984,
      longitude: 110.3656,
      openingHours: '08:30 - 21:00',
      ticketPrice: 0,
      estimatedDurationMinutes: 90,
      distanceFromHotelKm: 0.6,
      travelTimeMinutes: 3,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1578469550956-0e16b69c6a3d?w=600',
    ),
    Attraction(
      id: 'atr-5',
      name: 'Candi Prambanan Sunset',
      category: AttractionCategory.wisata,
      description: 'Kompleks candi Hindu terbesar di Indonesia berlatar langit senja magis nan memesona.',
      latitude: -7.7520,
      longitude: 110.4915,
      openingHours: '06:30 - 17:00',
      ticketPrice: 50000,
      estimatedDurationMinutes: 120,
      distanceFromHotelKm: 15.0,
      travelTimeMinutes: 35,
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?w=600',
    ),
    Attraction(
      id: 'atr-6',
      name: 'Kopi Klotok Pakem',
      category: AttractionCategory.kuliner,
      description: 'Warung kopi tradisional di tepi sawah dengan pisang goreng renyah dan sayur lodeh prasmanan.',
      latitude: -7.6582,
      longitude: 110.4239,
      openingHours: '07:00 - 21:00',
      ticketPrice: 20000,
      estimatedDurationMinutes: 60,
      distanceFromHotelKm: 18.0,
      travelTimeMinutes: 40,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=600',
    ),
  ];

  // ─── GENERATE ITINERARY CERDAS (RAG Filter & Sequencing Logic) ─────────────
  static TripItinerary generateMockItinerary({
    required Hotel hotel,
    required int daysCount,
    required String pace, // 'santai' / 'padat'
    required List<String> preferences,
  }) {
    final dailyPlans = <DayPlan>[];

    for (int day = 1; day <= daysCount; day++) {
      final items = <ItineraryItem>[];

      if (day == 1) {
        // Hari 1: Area dekat hotel & kuliner
        items.add(ItineraryItem(
          id: 'item-1',
          order: 1,
          attraction: attractions[0], // Kraton
          startTime: '09:00',
          endTime: '10:30',
          travelTimeFromPreviousMinutes: 8,
          notes: 'Mulai dari ${hotel.name}. Bawa topi atau payung.',
        ));
        items.add(ItineraryItem(
          id: 'item-2',
          order: 2,
          attraction: attractions[2], // Gudeg Yu Djum
          startTime: '11:00',
          endTime: '12:00',
          travelTimeFromPreviousMinutes: 6,
          notes: 'Makan siang kuliner khas di sentra Gudeg Wijilan.',
        ));
        items.add(ItineraryItem(
          id: 'item-3',
          order: 3,
          attraction: attractions[1], // Taman Sari
          startTime: '13:00',
          endTime: '14:30',
          travelTimeFromPreviousMinutes: 8,
          notes: 'Spot foto terbaik di Sumur Gumuling.',
        ));
        items.add(ItineraryItem(
          id: 'item-4',
          order: 4,
          attraction: attractions[3], // Malioboro Walk
          startTime: '16:00',
          endTime: '18:30',
          travelTimeFromPreviousMinutes: 10,
          notes: 'Jalan santai sore hari dan berburu suvenir sebelum kembali ke hotel.',
        ));
      } else {
        // Hari 2 dst: Eksplorasi Candi & Alam
        items.add(ItineraryItem(
          id: 'item-2-1',
          order: 1,
          attraction: attractions[5], // Kopi Klotok
          startTime: '08:00',
          endTime: '09:30',
          travelTimeFromPreviousMinutes: 40,
          notes: 'Sarapan pagi lodeh dan pisang goreng panas di tepi sawah.',
        ));
        items.add(ItineraryItem(
          id: 'item-2-2',
          order: 2,
          attraction: attractions[4], // Prambanan Sunset
          startTime: '15:00',
          endTime: '17:30',
          travelTimeFromPreviousMinutes: 30,
          notes: 'Golden hour sunset di candi megah Prambanan.',
        ));
      }

      final totalTravel = items.fold(0, (sum, i) => sum + i.travelTimeFromPreviousMinutes);
      final totalCost = items.fold(0, (sum, i) => sum + i.attraction.ticketPrice);

      dailyPlans.add(DayPlan(
        dayNumber: day,
        date: 'Hari ke-$day',
        items: items,
        totalTravelMinutes: totalTravel,
        estimatedDailyCost: totalCost,
      ));
    }

    return TripItinerary(
      id: 'itin-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Eksplorasi Jogja Istimewa',
      hotelName: hotel.name,
      hotelArea: hotel.area,
      totalDays: daysCount,
      pace: pace,
      interests: preferences,
      days: dailyPlans,
      createdAt: DateTime.now(),
    );
  }
}
