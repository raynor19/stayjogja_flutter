import 'package:dartz/dartz.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';

abstract class ItineraryRepository {
  Future<Either<Failure, TripItinerary>> generateItinerary({
    required Hotel hotel,
    required int daysCount,
    required String pace,
    required List<String> preferences,
  });

  Future<Either<Failure, List<TripItinerary>>> getSavedItineraries();
  Future<Either<Failure, void>> saveItinerary(TripItinerary itinerary);
}
