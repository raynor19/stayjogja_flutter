import 'package:dartz/dartz.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';

abstract class HotelRepository {
  Future<Either<Failure, List<Hotel>>> getHotels({String? area, String? query});
  Future<Either<Failure, Hotel>> getHotelById(String id);
}
