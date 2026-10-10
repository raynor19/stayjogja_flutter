import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/core/error/exceptions.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';

abstract class HotelRemoteDataSource {
  Future<List<Hotel>> getHotels({String? area, String? query});
  Future<Hotel> getHotelById(String id);
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  @override
  Future<List<Hotel>> getHotels({String? area, String? query}) async {
    // Simulasi delay jaringan realistis
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      var result = MockData.hotels;
      if (area != null && area.isNotEmpty && area != 'Semua') {
        result = result.where((h) => h.area.toLowerCase() == area.toLowerCase()).toList();
      }
      if (query != null && query.isNotEmpty) {
        result = result
            .where((h) =>
                h.name.toLowerCase().contains(query.toLowerCase()) ||
                h.area.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      return result;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Hotel> getHotelById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return MockData.hotels.firstWhere(
        (h) => h.id == id,
        orElse: () => MockData.hotels.first,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
