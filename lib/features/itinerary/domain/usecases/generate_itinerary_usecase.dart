import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/core/usecase/usecase.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/repositories/itinerary_repository.dart';

class GenerateItineraryParams extends Equatable {
  final Hotel hotel;
  final int daysCount;
  final String pace;
  final List<String> preferences;

  const GenerateItineraryParams({
    required this.hotel,
    required this.daysCount,
    required this.pace,
    required this.preferences,
  });

  @override
  List<Object?> get props => [hotel, daysCount, pace, preferences];
}

class GenerateItineraryUseCase implements UseCase<TripItinerary, GenerateItineraryParams> {
  final ItineraryRepository repository;

  GenerateItineraryUseCase(this.repository);

  @override
  Future<Either<Failure, TripItinerary>> call(GenerateItineraryParams params) async {
    return await repository.generateItinerary(
      hotel: params.hotel,
      daysCount: params.daysCount,
      pace: params.pace,
      preferences: params.preferences,
    );
  }
}
