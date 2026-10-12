import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';

class MockData {
  MockData._();

  // ─── HOTELS JOGJA (Mencakup Seluruh Wilayah DIY) ─────────────────────────
  static final List<Hotel> hotels = [
    // 1. Malioboro (Kota Yogyakarta)
    Hotel(
      id: 'htl-1',
      name: 'Grand Malioboro Heritage Hotel',
      area: 'Malioboro',
      address: 'Jl. Malioboro No. 52-58, Sosromenduran, Gedong Tengen, Kota Yogyakarta',
      latitude: -7.7928,
      longitude: 110.3658,
      rating: 4.8,
      totalReviews: 1240,
      star: 4,
      startingPrice: 520000,
      badge: 'Best Value',
      description:
          'Terletak strategis di jantung Malioboro, hanya 3 menit jalan kaki ke Stasiun Tugu dan Pasar Beringharjo. Menggabungkan arsitektur kolonial klasik dengan kenyamanan modern Jogja.',
      policy: 'Check-in mulai 14.00, check-out maksimal 12.00. Pembatalan gratis hingga 24 jam sebelum check-in.',
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

    // 2. Prawirotaman (Kota Yogyakarta)
    Hotel(
      id: 'htl-2',
      name: 'Prawirotaman Arts & Boutique Villa',
      area: 'Prawirotaman',
      address: 'Jl. Prawirotaman I No. 30, Brontokusuman, Mergangsan, Kota Yogyakarta',
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

    // 3. Kraton (Kota Yogyakarta)
    Hotel(
      id: 'htl-3',
      name: 'The Phoenix Heritage Hotel MGallery',
      area: 'Kraton',
      address: 'Jl. Jend. Sudirman No. 9, Cokrodiningratan, Jetis, Kota Yogyakarta',
      latitude: -7.7828,
      longitude: 110.3672,
      rating: 4.8,
      totalReviews: 1450,
      star: 5,
      startingPrice: 680000,
      badge: 'Member Exclusive',
      description:
          'Hotel warisan kolonial bintang 5 bergaya Eropa-Jawa klasik dekat Tugu dan Kraton. Kolam renang berlatar arsitektur klasik Jawa dan spa relaksasi tradisional.',
      policy: 'Check-in 14.00, check-out 12.00.',
      images: [
        'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      ],
      facilities: ['Kolam Renang Vintage', 'Restoran Kolonial', 'Bar Wine', 'Spa Jawa', 'Fitness Center'],
      rooms: [
        RoomType(
          id: 'rm-301',
          hotelId: 'htl-3',
          name: 'Classic Heritage Room',
          description: 'Kamar klasik bergaya kolonial dengan balkon pribadi dan sentuhan ukiran kayu jati.',
          capacity: 2,
          pricePerNight: 680000,
          originalPrice: 850000,
          stock: 5,
          cancellationPolicy: 'Gratis pembatalan s/d H-1',
          hasBreakfast: true,
          facilities: ['1 King Bed', '30 m²', 'Balkon', 'Sarapan Prasmanan'],
          images: ['https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800'],
        ),
      ],
    ),

    // 4. Kotagede (Kota Yogyakarta)
    Hotel(
      id: 'htl-4',
      name: 'Omah Kotagede Heritage Guesthouse',
      area: 'Kotagede',
      address: 'Jl. Mondorakan No. 45, Purbayan, Kotagede, Kota Yogyakarta',
      latitude: -7.8283,
      longitude: 110.3986,
      rating: 4.6,
      totalReviews: 430,
      star: 3,
      startingPrice: 350000,
      badge: 'Best Value',
      description:
          'Penginapan rumah Joglo otentik di sentra perak Kotagede. Suasana tenang dengan lorong labirin bersejarah dan peninggalan Kerajaan Mataram Islam.',
      policy: 'Check-in 14.00, check-out 12.00.',
      images: [
        'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800',
        'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
      ],
      facilities: ['Pendopo Joglo', 'Teh Herbal Gratis', 'WiFi Cepat', 'Parkir', 'Sewa Sepeda Onthel'],
      rooms: [
        RoomType(
          id: 'rm-401',
          hotelId: 'htl-4',
          name: 'Traditional Joglo Room',
          description: 'Kamar berdinding gebyok ukir jati dengan pendingin udara dan kamar mandi semi-terbuka.',
          capacity: 2,
          pricePerNight: 350000,
          originalPrice: 420000,
          stock: 3,
          cancellationPolicy: 'Fleksibel',
          hasBreakfast: true,
          facilities: ['1 Queen Bed', '24 m²', 'Sarapan Khas Jogja', 'AC'],
          images: ['https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800'],
        ),
      ],
    ),

    // 5. Kaliurang (Kabupaten Sleman)
    Hotel(
      id: 'htl-5',
      name: 'Merapi View Resort & Spa',
      area: 'Kaliurang',
      address: 'Jl. Kaliurang KM 22, Hargobinangun, Pakem, Sleman, DI Yogyakarta',
      latitude: -7.5989,
      longitude: 110.4243,
      rating: 4.9,
      totalReviews: 610,
      star: 5,
      startingPrice: 780000,
      badge: 'Member Exclusive',
      description:
          'Udara sejuk pegunungan dengan pemandangan megah Gunung Merapi di pagi hari. Cocok untuk liburan keluarga atau retret menenangkan diri.',
      policy: 'Check-in 15.00, check-out 12.00.',
      images: [
        'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
        'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800',
      ],
      facilities: ['Infinity Pool Merapi', 'Spa Tradisional Jawa', 'Restoran Kebun', 'Area Outbound', 'Api Unggun'],
      rooms: [
        RoomType(
          id: 'rm-501',
          hotelId: 'htl-5',
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

    // 6. Sleman (Kabupaten Sleman)
    Hotel(
      id: 'htl-6',
      name: 'Hyatt Regency Yogyakarta Golf Resort',
      area: 'Sleman',
      address: 'Jl. Palagan Tentara Pelajar, Sariharjo, Ngaglik, Sleman, DI Yogyakarta',
      latitude: -7.7408,
      longitude: 110.3721,
      rating: 4.8,
      totalReviews: 2100,
      star: 5,
      startingPrice: 890000,
      badge: 'Popular',
      description:
          'Resort megah seluas 22 hektar yang dikelilingi taman tropis rimbun, lapangan golf 9-hole, dan kolam renang bertema reruntuhan Candi Candi Jawa.',
      policy: 'Check-in 15.00, check-out 12.00.',
      images: [
        'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      ],
      facilities: ['Lapangan Golf', 'Multi-level Pool', 'Restoran Kemangi Bistro', 'Jogging Track', 'Tennis Court'],
      rooms: [
        RoomType(
          id: 'rm-601',
          hotelId: 'htl-6',
          name: 'Regency Garden King',
          description: 'Kamar mewah dengan pemandangan taman tropis dan lapangan golf hijau.',
          capacity: 2,
          pricePerNight: 890000,
          originalPrice: 1150000,
          stock: 4,
          cancellationPolicy: 'Gratis pembatalan s/d H-2',
          hasBreakfast: true,
          facilities: ['1 King Bed', '38 m²', 'Bathtub Marmer', 'Sarapan Mewah', 'Balkon Hijau'],
          images: ['https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800'],
        ),
      ],
    ),

    // 7. Bantul (Kabupaten Bantul - Parangtritis)
    Hotel(
      id: 'htl-7',
      name: 'Queen of the South Beach Resort',
      area: 'Bantul',
      address: 'Desa Parangrejo, Girijati, Purwosari (Dekat Pantai Parangtritis), Bantul',
      latitude: -8.0261,
      longitude: 110.3344,
      rating: 4.6,
      totalReviews: 920,
      star: 4,
      startingPrice: 620000,
      badge: 'Popular',
      description:
          'Resort tebing tepi laut dengan pemandangan langsung Samudera Hindia dan matahari terbenam magis Pantai Parangtritis. Infinity pool di atas tebing.',
      policy: 'Check-in 14.00, check-out 12.00.',
      images: [
        'https://images.unsplash.com/photo-1540541338287-41700207dee6?w=800',
        'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
      ],
      facilities: ['Cliff Infinity Pool', 'Sunset Lounge', 'Akses Pantai Pribadi', 'Restoran Seafood', 'Spa Ombak'],
      rooms: [
        RoomType(
          id: 'rm-701',
          hotelId: 'htl-7',
          name: 'Ocean Sunset Bungalow',
          description: 'Bungalow kayu pribadi di tepi tebing dengan deburan ombak laut selatan dan panorama senja.',
          capacity: 2,
          pricePerNight: 620000,
          originalPrice: 750000,
          stock: 3,
          cancellationPolicy: 'Gratis pembatalan s/d H-3',
          hasBreakfast: true,
          facilities: ['1 King Bed', '35 m²', 'View Samudera Hindia', 'Balkon Sunset'],
          images: ['https://images.unsplash.com/photo-1540541338287-41700207dee6?w=800'],
        ),
      ],
    ),

    // 8. Gunungkidul (Kabupaten Gunungkidul - Pantai Indrayanti/Tepus)
    Hotel(
      id: 'htl-8',
      name: 'Santorini Beach Resort Indrayanti',
      area: 'Gunungkidul',
      address: 'Kawasan Pantai Indrayanti, Tepus, Kabupaten Gunungkidul, DI Yogyakarta',
      latitude: -8.1512,
      longitude: 110.6128,
      rating: 4.7,
      totalReviews: 540,
      star: 4,
      startingPrice: 540000,
      badge: 'Best Value',
      description:
          'Penginapan bergaya mediterania putih-biru persis di tepi pantai pasir putih Gunungkidul. Suasana tenang dengan deru ombak dan keindahan karang laut.',
      policy: 'Check-in 14.00, check-out 12.00.',
      images: [
        'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800',
        'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
      ],
      facilities: ['Akses Langsung Pasir Putih', 'Kafe Pantai', 'Sewa Snorkeling', 'Restoran Ikan Bakar', 'WiFi'],
      rooms: [
        RoomType(
          id: 'rm-801',
          hotelId: 'htl-8',
          name: 'White Beach Deluxe',
          description: 'Hanya 10 langkah ke pasir putih pantai Indrayanti dengan AC sejuk dan teras santai.',
          capacity: 2,
          pricePerNight: 540000,
          originalPrice: 650000,
          stock: 4,
          cancellationPolicy: 'Fleksibel',
          hasBreakfast: true,
          facilities: ['1 Queen Bed', '28 m²', 'Akses Pantai', 'AC', 'Sarapan Kelapa Muda'],
          images: ['https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800'],
        ),
      ],
    ),

    // 9. Kulon Progo (Kabupaten Kulon Progo - YIA/Bandara & Menoreh)
    Hotel(
      id: 'htl-9',
      name: 'Grand Dafam Signature Airport YIA',
      area: 'Kulon Progo',
      address: 'Jl. Nasional III KM 41.5, Temon, Kabupaten Kulon Progo, DI Yogyakarta',
      latitude: -7.8972,
      longitude: 110.0544,
      rating: 4.7,
      totalReviews: 780,
      star: 4,
      startingPrice: 490000,
      badge: 'Popular',
      description:
          'Hotel modern tepat di depan Bandara Internasional Yogyakarta (YIA). Layanan antar-jemput bandara gratis dan akses mudah ke perbukitan Menoreh dan Waduk Sermo.',
      policy: 'Check-in 14.00, check-out 12.00. Shuttle bandara 24 jam.',
      images: [
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
        'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
      ],
      facilities: ['Rooftop Pool', 'Free Airport Shuttle', 'Restoran Internasional', 'Grand Ballroom', 'Gym'],
      rooms: [
        RoomType(
          id: 'rm-901',
          hotelId: 'htl-9',
          name: 'Superior Airport View',
          description: 'Kamar modern kedap suara dengan kasur empuk dan pemandangan runway bandara serta perbukitan.',
          capacity: 2,
          pricePerNight: 490000,
          originalPrice: 600000,
          stock: 6,
          cancellationPolicy: 'Gratis pembatalan s/d 24 jam',
          hasBreakfast: true,
          facilities: ['1 King Bed', '32 m²', 'Kedap Suara', 'Free Airport Transfer'],
          images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'],
        ),
      ],
    ),
  ];

  // ─── TEMPAT WISATA JOGJA LENGKAP TERKURASI (Patokan AI & Wilayah) ─────────
  static final List<Attraction> attractions = [
    // 1. Kraton & Budaya (Kota)
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

    // 2. Taman Sari (Kota)
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

    // 3. Kuliner Gudeg Wijilan (Kota)
    Attraction(
      id: 'atr-3',
      name: 'Gudeg Yu Djum Wijilan 167',
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

    // 4. Pasar Beringharjo & Malioboro (Kota)
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

    // 5. Candi Prambanan (Sleman)
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

    // 6. Kopi Klotok (Sleman)
    Attraction(
      id: 'atr-6',
      name: 'Warung Kopi Klotok Pakem',
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

    // 7. Lava Tour Merapi (Sleman)
    Attraction(
      id: 'atr-7',
      name: 'Jeep Lava Tour Merapi',
      category: AttractionCategory.alam,
      description: 'Petualangan jeep offroad menjelajahi bunker Kaliadem, Museum Sisa Hartaku, dan manuver air Kali Kuning.',
      latitude: -7.5841,
      longitude: 110.4431,
      openingHours: '06:00 - 17:00',
      ticketPrice: 350000,
      estimatedDurationMinutes: 150,
      distanceFromHotelKm: 24.0,
      travelTimeMinutes: 50,
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=600',
    ),

    // 8. Hutan Pinus Mangunan (Bantul)
    Attraction(
      id: 'atr-8',
      name: 'Hutan Pinus Mangunan & Dlingo',
      category: AttractionCategory.alam,
      description: 'Hutan pinus asri berhawa sejuk dengan amfiteater kayu estetik dan spot kabut pagi yang magis.',
      latitude: -7.9292,
      longitude: 110.4312,
      openingHours: '06:00 - 18:00',
      ticketPrice: 10000,
      estimatedDurationMinutes: 90,
      distanceFromHotelKm: 22.0,
      travelTimeMinutes: 45,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=600',
    ),

    // 9. Pantai Parangtritis & Gumuk Pasir (Bantul)
    Attraction(
      id: 'atr-9',
      name: 'Pantai Parangtritis & Sandboarding Gumuk Pasir',
      category: AttractionCategory.alam,
      description: 'Ikon wisata pantai selatan Jogja dengan sunset legendaris dan satu-satunya gumuk pasir barchan di Asia Tenggara.',
      latitude: -8.0255,
      longitude: 110.3341,
      openingHours: '24 Jam',
      ticketPrice: 15000,
      estimatedDurationMinutes: 120,
      distanceFromHotelKm: 28.0,
      travelTimeMinutes: 50,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
    ),

    // 10. Pantai Timang & Jembatan Gantung (Gunungkidul)
    Attraction(
      id: 'atr-10',
      name: 'Pantai Timang & Gondola Karang',
      category: AttractionCategory.alam,
      description: 'Wisata adrenalin gondola tradisional dan jembatan gantung menyeberangi deburan ombak karang laut selatan.',
      latitude: -8.1738,
      longitude: 110.6625,
      openingHours: '07:00 - 17:00',
      ticketPrice: 50000,
      estimatedDurationMinutes: 120,
      distanceFromHotelKm: 65.0,
      travelTimeMinutes: 110,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=600',
    ),

    // 11. Goa Pindul Cave Tubing (Gunungkidul)
    Attraction(
      id: 'atr-11',
      name: 'Goa Pindul Cave Tubing',
      category: AttractionCategory.alam,
      description: 'Menyusuri sungai bawah tanah di dalam gua stalaktit karst menggunakan ban pelampung alami.',
      latitude: -7.9331,
      longitude: 110.6483,
      openingHours: '07:00 - 16:30',
      ticketPrice: 45000,
      estimatedDurationMinutes: 90,
      distanceFromHotelKm: 42.0,
      travelTimeMinutes: 75,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?w=600',
    ),

    // 12. HeHa Sky View Patuk (Gunungkidul)
    Attraction(
      id: 'atr-12',
      name: 'HeHa Sky View Patuk',
      category: AttractionCategory.kafe,
      description: 'Restoran dan spot foto modern di atas bukit dengan panorama pemandangan lampu kota (city lights) Jogja.',
      latitude: -7.8483,
      longitude: 110.4789,
      openingHours: '10:00 - 21:00',
      ticketPrice: 25000,
      estimatedDurationMinutes: 90,
      distanceFromHotelKm: 18.0,
      travelTimeMinutes: 35,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600',
    ),

    // 13. Kalibiru & Waduk Sermo (Kulon Progo)
    Attraction(
      id: 'atr-13',
      name: 'Wisata Alam Kalibiru & Waduk Sermo',
      category: AttractionCategory.alam,
      description: 'Spot foto panggung pohon di ketinggian bukit Menoreh berlatar pemandangan danau Waduk Sermo nan hijau.',
      latitude: -7.8089,
      longitude: 110.1294,
      openingHours: '08:00 - 17:00',
      ticketPrice: 20000,
      estimatedDurationMinutes: 100,
      distanceFromHotelKm: 35.0,
      travelTimeMinutes: 60,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=600',
    ),

    // 14. Perak & Heritage Kotagede (Kota)
    Attraction(
      id: 'atr-14',
      name: 'Heritage Labirin & Sentra Perak Kotagede',
      category: AttractionCategory.belanja,
      description: 'Menyusuri gang sempit batu bata kuno Amongtani dan melihat pengrajin perak Mataram langsung di bengkel kerjanya.',
      latitude: -7.8285,
      longitude: 110.3991,
      openingHours: '08:00 - 18:00',
      ticketPrice: 0,
      estimatedDurationMinutes: 90,
      distanceFromHotelKm: 6.0,
      travelTimeMinutes: 15,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=600',
    ),

    // 15. Kuliner Malam Kopi Jos (Kota)
    Attraction(
      id: 'atr-15',
      name: 'Angkringan Kopi Jos Lik Man Malioboro',
      category: AttractionCategory.malam,
      description: 'Nongkrong lesehan khas Jogja menikmati kopi panas dicelup arang membara (kopi jos) ditemani nasi kucing.',
      latitude: -7.7891,
      longitude: 110.3644,
      openingHours: '17:00 - 02:00',
      ticketPrice: 15000,
      estimatedDurationMinutes: 60,
      distanceFromHotelKm: 1.0,
      travelTimeMinutes: 4,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600',
    ),
  ];

  // ─── GENERATE ITINERARY CERDAS (RAG Filter & Sequencing Logic) ─────────────
  static TripItinerary generateMockItinerary({
    required Hotel hotel,
    required int daysCount,
    required String pace,
    required List<String> preferences,
  }) {
    final dailyPlans = <DayPlan>[];

    for (int day = 1; day <= daysCount; day++) {
      final items = <ItineraryItem>[];

      if (day == 1) {
        // Hari 1: Area dekat hotel & Budaya & Kuliner
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
          notes: 'Jalan santai sore hari dan berburu batik sebelum kembali ke hotel.',
        ));
      } else if (day == 2) {
        // Hari 2: Eksplorasi Candi & Alam Lereng Merapi
        items.add(ItineraryItem(
          id: 'item-2-1',
          order: 1,
          attraction: attractions[5], // Kopi Klotok
          startTime: '08:00',
          endTime: '09:30',
          travelTimeFromPreviousMinutes: 40,
          notes: 'Sarapan pagi sayur lodeh dan pisang goreng panas di tepi sawah.',
        ));
        items.add(ItineraryItem(
          id: 'item-2-2',
          order: 2,
          attraction: attractions[6], // Lava Tour Merapi
          startTime: '10:30',
          endTime: '13:00',
          travelTimeFromPreviousMinutes: 20,
          notes: 'Petualangan jeep offroad seru menyusuri bekas erupsi Merapi.',
        ));
        items.add(ItineraryItem(
          id: 'item-2-3',
          order: 3,
          attraction: attractions[4], // Prambanan Sunset
          startTime: '15:30',
          endTime: '17:45',
          travelTimeFromPreviousMinutes: 35,
          notes: 'Golden hour sunset di candi megah Prambanan.',
        ));
      } else {
        // Hari 3+: Alam Selatan Bantul / Gunungkidul
        items.add(ItineraryItem(
          id: 'item-3-1',
          order: 1,
          attraction: attractions[7], // Hutan Pinus Mangunan
          startTime: '08:30',
          endTime: '10:30',
          travelTimeFromPreviousMinutes: 45,
          notes: 'Menikmati udara sejuk dan ketenangan hutan pinus asri.',
        ));
        items.add(ItineraryItem(
          id: 'item-3-2',
          order: 2,
          attraction: attractions[8], // Parangtritis & Gumuk Pasir
          startTime: '15:00',
          endTime: '18:00',
          travelTimeFromPreviousMinutes: 35,
          notes: 'Sandboarding seru dan menikmati matahari terbenam di pantai selatan.',
        ));
        items.add(ItineraryItem(
          id: 'item-3-3',
          order: 3,
          attraction: attractions[14], // Kopi Jos Lik Man
          startTime: '19:30',
          endTime: '21:30',
          travelTimeFromPreviousMinutes: 40,
          notes: 'Nongkrong santai lesehan khas Jogja minum Kopi Jos sebelum istirahat.',
        ));
      }

      final totalTravel = items.fold(0, (sum, itm) => sum + itm.travelTimeFromPreviousMinutes);
      final totalCost = items.fold(0, (sum, itm) => sum + itm.attraction.ticketPrice);

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
