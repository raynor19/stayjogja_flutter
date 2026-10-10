import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';

abstract class ItineraryRemoteDataSource {
  Future<TripItinerary> generateItinerary({
    required Hotel hotel,
    required int daysCount,
    required String pace,
    required List<String> preferences,
  });

  Future<List<TripItinerary>> getSavedItineraries();
  Future<void> saveItinerary(TripItinerary itinerary);
}

class ItineraryRemoteDataSourceImpl implements ItineraryRemoteDataSource {
  final FirebaseFirestore _firestore;

  ItineraryRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<TripItinerary> generateItinerary({
    required Hotel hotel,
    required int daysCount,
    required String pace,
    required List<String> preferences,
  }) async {
    try {
      final attractionsSnapshot = await _firestore
          .collection('attractions')
          .get()
          .timeout(const Duration(seconds: 3));

      List<Attraction> availableAttractions = [];

      for (final doc in attractionsSnapshot.docs) {
        final data = doc.data();
        availableAttractions.add(
          Attraction(
            id: data['id'] as String,
            name: data['name'] as String,
            category: _categoryFromString(data['category'] as String?),
            description: data['description'] as String? ?? '',
            latitude: (data['latitude'] as num).toDouble(),
            longitude: (data['longitude'] as num).toDouble(),
            openingHours: data['opening_hours'] as String? ?? '08:00 - 17:00',
            ticketPrice: data['ticket_price'] as int? ?? 0,
            estimatedDurationMinutes: data['estimated_duration_minutes'] as int? ?? 60,
            distanceFromHotelKm: (data['distance_km'] as num?)?.toDouble() ?? 2.0,
            travelTimeMinutes: data['travel_time_minutes'] as int? ?? 10,
            rating: (data['rating'] as num?)?.toDouble() ?? 4.7,
            imageUrl: data['image_url'] as String? ?? '',
          ),
        );
      }

      if (availableAttractions.isEmpty) {
        availableAttractions = MockData.attractions;
      }

      final dailyPlans = <DayPlan>[];

      for (int day = 1; day <= daysCount; day++) {
        final items = <ItineraryItem>[];
        final maxSpots = pace == 'padat' ? 4 : 3;

        for (int i = 0; i < maxSpots && i < availableAttractions.length; i++) {
          final attractionIndex = ((day - 1) * 2 + i) % availableAttractions.length;
          final attraction = availableAttractions[attractionIndex];

          items.add(
            ItineraryItem(
              id: 'item-$day-${i + 1}',
              order: i + 1,
              attraction: attraction,
              startTime: i == 0 ? '09:00' : (i == 1 ? '12:00' : '15:30'),
              endTime: i == 0 ? '10:30' : (i == 1 ? '13:30' : '17:30'),
              travelTimeFromPreviousMinutes: attraction.travelTimeMinutes,
              notes: i == 0
                  ? 'Mulai perjalanan dari ${hotel.name}.'
                  : 'Rute dekat hotel (${attraction.distanceFromHotelKm} km).',
            ),
          );
        }

        final totalTravel = items.fold(0, (sum, itm) => sum + itm.travelTimeFromPreviousMinutes);
        final totalCost = items.fold(0, (sum, itm) => sum + itm.attraction.ticketPrice);

        dailyPlans.add(
          DayPlan(
            dayNumber: day,
            date: 'Hari ke-$day',
            items: items,
            totalTravelMinutes: totalTravel,
            estimatedDailyCost: totalCost,
          ),
        );
      }

      final itinerary = TripItinerary(
        id: 'itin-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Eksplorasi ${hotel.area} & Jogja',
        hotelName: hotel.name,
        hotelArea: hotel.area,
        totalDays: daysCount,
        pace: pace,
        interests: preferences,
        days: dailyPlans,
        createdAt: DateTime.now(),
      );

      // Save to Firestore background
      saveItinerary(itinerary).catchError((_) {});

      return itinerary;
    } catch (_) {
      return MockData.generateMockItinerary(
        hotel: hotel,
        daysCount: daysCount,
        pace: pace,
        preferences: preferences,
      );
    }
  }

  @override
  Future<List<TripItinerary>> getSavedItineraries() async {
    try {
      final snapshot = await _firestore
          .collection('itineraries')
          .orderBy('created_at', descending: true)
          .get()
          .timeout(const Duration(seconds: 3));

      if (snapshot.docs.isEmpty) {
        return [
          MockData.generateMockItinerary(
            hotel: MockData.hotels.first,
            daysCount: 3,
            pace: 'santai',
            preferences: ['Budaya', 'Kuliner'],
          ),
        ];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TripItinerary(
          id: data['id'] as String,
          title: data['title'] as String,
          hotelName: data['hotel_name'] as String,
          hotelArea: data['hotel_area'] as String? ?? 'Yogyakarta',
          totalDays: data['total_days'] as int? ?? 1,
          pace: data['pace'] as String? ?? 'santai',
          interests: List<String>.from(data['interests'] ?? []),
          days: [],
          createdAt: DateTime.tryParse(data['created_at'] as String? ?? '') ?? DateTime.now(),
        );
      }).toList();
    } catch (_) {
      return [
        MockData.generateMockItinerary(
          hotel: MockData.hotels.first,
          daysCount: 3,
          pace: 'santai',
          preferences: ['Budaya', 'Kuliner'],
        ),
      ];
    }
  }

  @override
  Future<void> saveItinerary(TripItinerary itinerary) async {
    try {
      await _firestore.collection('itineraries').doc(itinerary.id).set({
        'id': itinerary.id,
        'title': itinerary.title,
        'hotel_name': itinerary.hotelName,
        'hotel_area': itinerary.hotelArea,
        'total_days': itinerary.totalDays,
        'pace': itinerary.pace,
        'interests': itinerary.interests,
        'created_at': itinerary.createdAt.toIso8601String(),
      });
    } catch (_) {}
  }

  AttractionCategory _categoryFromString(String? cat) {
    if (cat == null) return AttractionCategory.wisata;
    switch (cat.toLowerCase()) {
      case 'kuliner':
        return AttractionCategory.kuliner;
      case 'alam':
        return AttractionCategory.alam;
      case 'belanja':
        return AttractionCategory.belanja;
      case 'kafe':
        return AttractionCategory.kafe;
      case 'malam':
        return AttractionCategory.malam;
      default:
        return AttractionCategory.wisata;
    }
  }
}
