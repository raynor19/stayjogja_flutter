import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/features/hotel/data/models/hotel_model.dart';

class FirestoreSeeder {
  final FirebaseFirestore _firestore;

  FirestoreSeeder({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> seedInitialDataIfNeeded() async {
    try {
      final hotelSnapshot = await _firestore.collection('hotels').limit(1).get().timeout(const Duration(seconds: 4));

      // Jika database masih kosong atau kurang lengkap, upload seluruh data DIY
      if (hotelSnapshot.docs.isEmpty) {
        final batch = _firestore.batch();

        // ─── 1. Seed 9 Hotel Mewakili Seluruh Wilayah DIY ─────────────────────
        for (final hotel in MockData.hotels) {
          final hotelDoc = _firestore.collection('hotels').doc(hotel.id);
          final hotelModel = HotelModel(
            id: hotel.id,
            name: hotel.name,
            area: hotel.area,
            address: hotel.address,
            latitude: hotel.latitude,
            longitude: hotel.longitude,
            rating: hotel.rating,
            totalReviews: hotel.totalReviews,
            star: hotel.star,
            startingPrice: hotel.startingPrice,
            badge: hotel.badge,
            images: hotel.images,
            facilities: hotel.facilities,
            description: hotel.description,
            policy: hotel.policy,
            rooms: hotel.rooms
                .map((r) => RoomTypeModel(
                      id: r.id,
                      hotelId: r.hotelId,
                      name: r.name,
                      description: r.description,
                      capacity: r.capacity,
                      pricePerNight: r.pricePerNight,
                      originalPrice: r.originalPrice,
                      stock: r.stock,
                      facilities: r.facilities,
                      images: r.images,
                      cancellationPolicy: r.cancellationPolicy,
                      hasBreakfast: r.hasBreakfast,
                    ))
                .toList(),
          );
          batch.set(hotelDoc, hotelModel.toJson());
        }

        // ─── 2. Seed 15 Tempat Wisata Terpopuler DIY (RAG Database) ───────────
        for (final attraction in MockData.attractions) {
          final attractionDoc = _firestore.collection('attractions').doc(attraction.id);
          batch.set(attractionDoc, {
            'id': attraction.id,
            'name': attraction.name,
            'category': attraction.category.name,
            'description': attraction.description,
            'latitude': attraction.latitude,
            'longitude': attraction.longitude,
            'opening_hours': attraction.openingHours,
            'ticket_price': attraction.ticketPrice,
            'estimated_duration_minutes': attraction.estimatedDurationMinutes,
            'distance_km': attraction.distanceFromHotelKm,
            'travel_time_minutes': attraction.travelTimeMinutes,
            'rating': attraction.rating,
            'image_url': attraction.imageUrl,
          });
        }

        await batch.commit();
      }
    } catch (_) {
      // Gracefully silent jika offline
    }
  }
}
