import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/core/error/exceptions.dart';
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
  final List<TripItinerary> _saved = [];

  @override
  Future<TripItinerary> generateItinerary({
    required Hotel hotel,
    required int daysCount,
    required String pace,
    required List<String> preferences,
  }) async {
    // Simulasi AI Generation latency
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final itinerary = MockData.generateMockItinerary(
        hotel: hotel,
        daysCount: daysCount,
        pace: pace,
        preferences: preferences,
      );
      _saved.add(itinerary);
      return itinerary;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TripItinerary>> getSavedItineraries() async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      if (_saved.isEmpty) {
        final sample = MockData.generateMockItinerary(
          hotel: MockData.hotels.first,
          daysCount: 3,
          pace: 'santai',
          preferences: ['Budaya', 'Kuliner'],
        );
        _saved.add(sample);
      }
      return List.unmodifiable(_saved);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> saveItinerary(TripItinerary itinerary) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _saved.add(itinerary);
  }
}
