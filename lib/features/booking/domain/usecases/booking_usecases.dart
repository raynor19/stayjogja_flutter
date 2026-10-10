import 'package:dartz/dartz.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/core/usecase/usecase.dart';
import 'package:stayjogja_flutter/features/booking/domain/entities/booking.dart';
import 'package:stayjogja_flutter/features/booking/domain/repositories/booking_repository.dart';

class CreateBookingUseCase implements UseCase<BookingEntity, BookingEntity> {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(BookingEntity params) async {
    return await repository.createBooking(params);
  }
}

class GetUserBookingsUseCase implements UseCase<List<BookingEntity>, NoParams> {
  final BookingRepository repository;

  GetUserBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(NoParams params) async {
    return await repository.getUserBookings();
  }
}
