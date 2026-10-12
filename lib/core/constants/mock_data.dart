import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';

// ─── Import Katalog Hotel Lengkap per Wilayah DIY ─────────────────────────
import 'hotels/malioboro_hotels.dart';
import 'hotels/prawirotaman_hotels.dart';
import 'hotels/kraton_hotels.dart';
import 'hotels/kotagede_hotels.dart';
import 'hotels/kaliurang_hotels.dart';
import 'hotels/sleman_hotels.dart';
import 'hotels/bantul_hotels.dart';
import 'hotels/gunungkidul_hotels.dart';
import 'hotels/kulonprogo_hotels.dart';

class MockData {
  MockData._();

  // ─── DATABASE 51 HOTEL JOGJA LENGKAP & SUPER DETAIL ─────────────────────
  static final List<Hotel> hotels = [
    ...malioboroHotels,
    ...prawirotamanHotels,
    ...kratonHotels,
    ...kotagedeHotels,
    ...kaliurangHotels,
    ...slemanHotels,
    ...bantulHotels,
    ...gunungkidulHotels,
    ...kulonprogoHotels,
  ];

  // ─── 15 TEMPAT WISATA POPULER DIY (Patokan & Input RAG AI Planner) ───────
  static final List<Attraction> attractions = [
    Attraction(
      id: 'atr-1',
      name: 'Kraton Ngayogyakarta Hadiningrat',
      category: AttractionCategory.wisata,
      description: 'Istana resmi Kesultanan Ngayogyakarta Hadiningrat, pusat kebudayaan Jawa adiluhung dengan museum pusaka, gamelan, dan pertunjukan tarian tradisional tiap pagi.',
      latitude: -7.8053,
      longitude: 110.3642,
      openingHours: '08:30 - 14:00 (Tutup setiap hari Senin)',
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
      description: 'Situs kebun istana pemandian putri raja Mataram abad ke-18 dengan lorong bawah tanah Masjid Sumur Gumuling yang magis dan sangat estetik.',
      latitude: -7.8099,
      longitude: 110.3592,
      openingHours: '09:00 - 15:00 Setiap Hari',
      ticketPrice: 15000,
      estimatedDurationMinutes: 75,
      distanceFromHotelKm: 2.3,
      travelTimeMinutes: 10,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?w=600',
    ),
    Attraction(
      id: 'atr-3',
      name: 'Gudeg Yu Djum Wijilan 167',
      category: AttractionCategory.kuliner,
      description: 'Kuliner legendaris nangka muda bumbu areh manis gurih yang dimasak kayu bakar khas Jogja sejak tahun 1951 di sentra Wijilan.',
      latitude: -7.8041,
      longitude: 110.3686,
      openingHours: '06:00 - 22:00 Setiap Hari',
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
      description: 'Pusat belanja batik tulis dan cap, suvenir khas, kerajinan tangan, dan aneka jajanan pasar tradisional terbesar di Yogyakarta.',
      latitude: -7.7984,
      longitude: 110.3656,
      openingHours: '08:30 - 21:00 Setiap Hari',
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
      description: 'Kompleks candi Hindu terindah di Asia Tenggara yang menjulang 47 meter berlatar siluet matahari terbenam spektakuler dan Sendratari Ramayana.',
      latitude: -7.7520,
      longitude: 110.4915,
      openingHours: '06:30 - 17:00 Setiap Hari',
      ticketPrice: 50000,
      estimatedDurationMinutes: 120,
      distanceFromHotelKm: 15.0,
      travelTimeMinutes: 35,
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?w=600',
    ),
    Attraction(
      id: 'atr-6',
      name: 'Warung Kopi Klotok Pakem',
      category: AttractionCategory.kuliner,
      description: 'Sensasi sarapan kopi tubruk tradisional di tepi hamparan sawah hijau dengan menu pisang goreng renyah dan sayur lodeh prasmanan hangat.',
      latitude: -7.6582,
      longitude: 110.4239,
      openingHours: '07:00 - 21:00 Setiap Hari',
      ticketPrice: 20000,
      estimatedDurationMinutes: 60,
      distanceFromHotelKm: 18.0,
      travelTimeMinutes: 40,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=600',
    ),
    Attraction(
      id: 'atr-7',
      name: 'Jeep Lava Tour Merapi',
      category: AttractionCategory.alam,
      description: 'Petualangan offroad menyusuri lereng Gunung Merapi dengan jeep terbuka: mengunjungi Bunker Kaliadem, Museum Sisa Hartaku, dan manuver air Kali Kuning.',
      latitude: -7.5841,
      longitude: 110.4431,
      openingHours: '06:00 - 17:00 Setiap Hari',
      ticketPrice: 350000,
      estimatedDurationMinutes: 150,
      distanceFromHotelKm: 24.0,
      travelTimeMinutes: 50,
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=600',
    ),
    Attraction(
      id: 'atr-8',
      name: 'Hutan Pinus Mangunan & Dlingo',
      category: AttractionCategory.alam,
      description: 'Hamparan hutan pinus asri berhawa sejuk dengan amfiteater kayu estetik, spot kabut pagi hari, dan jajaran warung kopi teduh.',
      latitude: -7.9292,
      longitude: 110.4312,
      openingHours: '06:00 - 18:00 Setiap Hari',
      ticketPrice: 10000,
      estimatedDurationMinutes: 90,
      distanceFromHotelKm: 22.0,
      travelTimeMinutes: 45,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=600',
    ),
    Attraction(
      id: 'atr-9',
      name: 'Pantai Parangtritis & Gumuk Pasir',
      category: AttractionCategory.alam,
      description: 'Ikon pantai laut selatan dengan deburan ombak megah, sunset legendaris, serta bukit pasir barchan alami langka untuk sandboarding dan foto estetik.',
      latitude: -8.0255,
      longitude: 110.3341,
      openingHours: '24 Jam Setiap Hari',
      ticketPrice: 15000,
      estimatedDurationMinutes: 120,
      distanceFromHotelKm: 28.0,
      travelTimeMinutes: 50,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
    ),
    Attraction(
      id: 'atr-10',
      name: 'Pantai Timang & Gondola Karang',
      category: AttractionCategory.alam,
      description: 'Pengalaman menyeberang pulau karang dengan gondola kayu nelayan tradisional di atas hempasan ombak Samudera Hindia yang mendebarkan.',
      latitude: -8.1738,
      longitude: 110.6625,
      openingHours: '07:00 - 17:00 Setiap Hari',
      ticketPrice: 50000,
      estimatedDurationMinutes: 120,
      distanceFromHotelKm: 65.0,
      travelTimeMinutes: 110,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=600',
    ),
    Attraction(
      id: 'atr-11',
      name: 'Goa Pindul Cave Tubing',
      category: AttractionCategory.alam,
      description: 'Menyusuri keindahan sungai bawah tanah gua karst dengan ban pelampung alami, melihat stalaktit hidup dan cahaya surga (luweng).',
      latitude: -7.9331,
      longitude: 110.6483,
      openingHours: '07:00 - 16:30 Setiap Hari',
      ticketPrice: 45000,
      estimatedDurationMinutes: 90,
      distanceFromHotelKm: 42.0,
      travelTimeMinutes: 75,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?w=600',
    ),
    Attraction(
      id: 'atr-12',
      name: 'HeHa Sky View Patuk',
      category: AttractionCategory.kafe,
      description: 'Restoran modern di ketinggian tebing Patuk dengan spot foto ikonik balon udara, sky bridge kaca, dan pemandangan gemerlap lampu malam kota Jogja.',
      latitude: -7.8483,
      longitude: 110.4789,
      openingHours: '10:00 - 21:00 Setiap Hari',
      ticketPrice: 25000,
      estimatedDurationMinutes: 90,
      distanceFromHotelKm: 18.0,
      travelTimeMinutes: 35,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600',
    ),
    Attraction(
      id: 'atr-13',
      name: 'Wisata Alam Kalibiru & Waduk Sermo',
      category: AttractionCategory.alam,
      description: 'Wisata gardu pandang pohon di perbukitan Menoreh Kulon Progo berlatar pemandangan danau Waduk Sermo nan hijau zamrud.',
      latitude: -7.8089,
      longitude: 110.1294,
      openingHours: '08:00 - 17:00 Setiap Hari',
      ticketPrice: 20000,
      estimatedDurationMinutes: 100,
      distanceFromHotelKm: 35.0,
      travelTimeMinutes: 60,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=600',
    ),
    Attraction(
      id: 'atr-14',
      name: 'Labirin Heritage & Sentra Perak Kotagede',
      category: AttractionCategory.belanja,
      description: 'Lorong bersejarah bekas ibukota Kerajaan Mataram Islam, rumah-rumah tradisional Kalang abad ke-19, dan puluhan galeri pengrajin perak buatan tangan.',
      latitude: -7.8285,
      longitude: 110.3991,
      openingHours: '08:00 - 18:00 Setiap Hari',
      ticketPrice: 0,
      estimatedDurationMinutes: 90,
      distanceFromHotelKm: 6.0,
      travelTimeMinutes: 15,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=600',
    ),
    Attraction(
      id: 'atr-15',
      name: 'Angkringan Kopi Jos Lik Man Malioboro',
      category: AttractionCategory.malam,
      description: 'Nongkrong santai lesehan khas Jogja di dekat Stasiun Tugu menikmati kopi panas dengan arang kayu membara mendesis (kopi jos) dan aneka sate nasi kucing.',
      latitude: -7.7891,
      longitude: 110.3644,
      openingHours: '17:00 - 02:00 Setiap Malam',
      ticketPrice: 15000,
      estimatedDurationMinutes: 60,
      distanceFromHotelKm: 1.0,
      travelTimeMinutes: 4,
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600',
    ),
  ];

  // ─── AI ITINERARY GENERATOR LOGIC ─────────────────────────────────────────
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
        items.add(ItineraryItem(
          id: 'item-1',
          order: 1,
          attraction: attractions[0], // Kraton
          startTime: '09:00',
          endTime: '10:30',
          travelTimeFromPreviousMinutes: 8,
          notes: 'Mulai perjalanan dari ${hotel.name}. Pagi hari adalah waktu terbaik sebelum udara terlalu panas.',
        ));
        items.add(ItineraryItem(
          id: 'item-2',
          order: 2,
          attraction: attractions[2], // Gudeg Yu Djum
          startTime: '11:00',
          endTime: '12:00',
          travelTimeFromPreviousMinutes: 6,
          notes: 'Makan siang kuliner legendaris di sentra Gudeg Wijilan.',
        ));
        items.add(ItineraryItem(
          id: 'item-3',
          order: 3,
          attraction: attractions[1], // Taman Sari
          startTime: '13:00',
          endTime: '14:30',
          travelTimeFromPreviousMinutes: 8,
          notes: 'Spot foto terbaik di lorong bawah tanah Sumur Gumuling.',
        ));
        items.add(ItineraryItem(
          id: 'item-4',
          order: 4,
          attraction: attractions[3], // Malioboro Walk
          startTime: '16:00',
          endTime: '18:30',
          travelTimeFromPreviousMinutes: 10,
          notes: 'Jalan santai sore hari berburu batik di Beringharjo sebelum kembali ke hotel.',
        ));
      } else if (day == 2) {
        items.add(ItineraryItem(
          id: 'item-2-1',
          order: 1,
          attraction: attractions[5], // Kopi Klotok
          startTime: '08:00',
          endTime: '09:30',
          travelTimeFromPreviousMinutes: 40,
          notes: 'Sarapan pagi sayur lodeh dan pisang goreng panas di tepi hamparan sawah.',
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
          notes: 'Golden hour sunset di candi megah Hindu Prambanan.',
        ));
      } else {
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
