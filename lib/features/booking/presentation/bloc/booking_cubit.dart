import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stayjogja_flutter/core/usecase/usecase.dart';
import 'package:stayjogja_flutter/features/booking/domain/entities/booking.dart';
import 'package:stayjogja_flutter/features/booking/domain/usecases/booking_usecases.dart';

// ─── States ────────────────────────────────────────────────────────────────
abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;
  const BookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingSuccess extends BookingState {
  final BookingEntity booking;
  const BookingSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Cubit ─────────────────────────────────────────────────────────────────
class BookingCubit extends Cubit<BookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final GetUserBookingsUseCase getUserBookingsUseCase;

  List<BookingEntity> _cachedBookings = [];

  BookingCubit({
    required this.createBookingUseCase,
    required this.getUserBookingsUseCase,
  }) : super(BookingInitial());

  Future<void> loadUserBookings() async {
    emit(BookingLoading());
    final result = await getUserBookingsUseCase(NoParams());
    result.fold(
      (failure) {
        if (_cachedBookings.isNotEmpty) {
          emit(BookingsLoaded(_cachedBookings));
        } else {
          emit(BookingError(failure.message));
        }
      },
      (bookings) {
        _cachedBookings = List.from(bookings);
        emit(BookingsLoaded(bookings));
      },
    );
  }

  Future<void> createBooking(BookingEntity booking) async {
    emit(BookingLoading());
    final result = await createBookingUseCase(booking);
    await result.fold(
      (failure) async {
        emit(BookingError(failure.message));
      },
      (created) async {
        // Tambahkan booking baru ke awal cache
        _cachedBookings.insert(0, created);
        // Refresh seluruh booking dari Cloud Firestore secara real-time
        await loadUserBookings();
      },
    );
  }
}
