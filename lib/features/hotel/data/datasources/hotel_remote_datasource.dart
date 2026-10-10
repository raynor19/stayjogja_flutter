import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stayjogja_flutter/core/error/exceptions.dart';
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

      final snapshot = await queryRef.get();
      List<Hotel> hotels = snapshot.docs.map((doc) {
        return HotelModel.fromJson(doc.data());
      }).toList();

      if (query != null && query.isNotEmpty) {
        hotels = hotels.where((h) {
          final q = query.toLowerCase();
          return h.name.toLowerCase().contains(q) || h.area.toLowerCase().contains(q);
        }).toList();
      }

      return hotels;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Hotel> getHotelById(String id) async {
    try {
      final doc = await _firestore.collection('hotels').doc(id).get();
      if (!doc.exists || doc.data() == null) {
        throw const ServerException('Hotel tidak ditemukan di Firestore');
      }
      return HotelModel.fromJson(doc.data()!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
