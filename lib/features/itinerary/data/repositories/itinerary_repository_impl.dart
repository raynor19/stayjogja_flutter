import 'package:dartz/dartz.dart';
import 'package:stayjogja_flutter/core/error/exceptions.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/itinerary/data/datasources/itinerary_remote_datasource.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/repositories/itinerary_repository.dart';

class ItineraryRepositoryImpl implements ItineraryRepository {
  final ItineraryRemoteDataSource remoteDataSource;

  ItineraryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TripItinerary>> generateItinerary({
    required Hotel hotel,
    required int daysCount,
    required String pace,
    required List<String> preferences,
  }) async {
    try {
      final itinerary = await remoteDataSource.generateItinerary(
        hotel: hotel,
        daysCount: daysCount,
        pace: pace,
        preferences: preferences,
      );
      return Right(itinerary);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TripItinerary>>> getSavedItineraries() async {
    try {
      final list = await remoteDataSource.getSavedItineraries();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveItinerary(TripItinerary itinerary) async {
    try {
      await remoteDataSource.saveItinerary(itinerary);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
