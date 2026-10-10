import 'package:dartz/dartz.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/core/usecase/usecase.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/repositories/itinerary_repository.dart';

class GetSavedItinerariesUseCase implements UseCase<List<TripItinerary>, NoParams> {
  final ItineraryRepository repository;

  GetSavedItinerariesUseCase(this.repository);

  @override
  Future<Either<Failure, List<TripItinerary>>> call(NoParams params) async {
    return await repository.getSavedItineraries();
  }
}
