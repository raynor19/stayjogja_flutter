import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/features/hotel/data/models/hotel_model.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';

abstract class HotelRemoteDataSource {
  Future<List<Hotel>> getHotels({String? area, String? query});
  Future<Hotel> getHotelById(String id);
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  final FirebaseFirestore _firestore;

  HotelRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Hotel>> getHotels({String? area, String? query}) async {
    try {
      Query<Map<String, dynamic>> queryRef = _firestore.collection('hotels');

      if (area != null && area.isNotEmpty && area != 'Semua') {
        queryRef = queryRef.where('area', isEqualTo: area);
      }

      // Beri batas timeout 3 detik agar tidak loading selamanya jika internet/rules terkendala
      final snapshot = await queryRef.get().timeout(const Duration(seconds: 3));
      
      List<Hotel> hotels = snapshot.docs.map((doc) {
        return HotelModel.fromJson(doc.data());
      }).toList();

      // Jika Firestore masih kosong, gunakan data lokal Jogja sebagai initial fallback
      if (hotels.isEmpty) {
        hotels = MockData.hotels;
        if (area != null && area.isNotEmpty && area != 'Semua') {
          hotels = hotels.where((h) => h.area.toLowerCase() == area.toLowerCase()).toList();
        }
      }

      if (query != null && query.isNotEmpty) {
        hotels = hotels.where((h) {
          final q = query.toLowerCase();
          return h.name.toLowerCase().contains(q) || h.area.toLowerCase().contains(q);
        }).toList();
      }

      return hotels;
    } catch (_) {
      // Fallback graceful: jika ada kendala jaringan Firestore, app tetap tampil sempurna
      var fallback = MockData.hotels;
      if (area != null && area.isNotEmpty && area != 'Semua') {
        fallback = fallback.where((h) => h.area.toLowerCase() == area.toLowerCase()).toList();
      }
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        fallback = fallback.where((h) => h.name.toLowerCase().contains(q) || h.area.toLowerCase().contains(q)).toList();
      }
      return fallback;
    }
  }

  @override
  Future<Hotel> getHotelById(String id) async {
    try {
      final doc = await _firestore.collection('hotels').doc(id).get().timeout(const Duration(seconds: 3));
      if (doc.exists && doc.data() != null) {
        return HotelModel.fromJson(doc.data()!);
      }
      return MockData.hotels.firstWhere((h) => h.id == id, orElse: () => MockData.hotels.first);
    } catch (_) {
      return MockData.hotels.firstWhere((h) => h.id == id, orElse: () => MockData.hotels.first);
    }
  }
}
