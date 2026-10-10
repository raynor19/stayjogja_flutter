import 'package:dartz/dartz.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/core/usecase/usecase.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/domain/repositories/hotel_repository.dart';

class GetHotelDetailUseCase implements UseCase<Hotel, String> {
  final HotelRepository repository;

  GetHotelDetailUseCase(this.repository);

  @override
  Future<Either<Failure, Hotel>> call(String hotelId) async {
    return await repository.getHotelById(hotelId);
  }
}
