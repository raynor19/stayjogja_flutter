import 'package:stayjogja_flutter/core/error/exceptions.dart';
import 'package:stayjogja_flutter/features/booking/domain/entities/booking.dart';

abstract class BookingRemoteDataSource {
  Future<BookingEntity> createBooking(BookingEntity booking);
  Future<List<BookingEntity>> getUserBookings();
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final List<BookingEntity> _bookings = [
    BookingEntity(
      id: 'bkg-1',
      bookingCode: 'SJ-928104',
      hotelId: 'htl-1',
      hotelName: 'Grand Malioboro Heritage Hotel',
      roomName: 'Deluxe Heritage King',
      hotelImageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      guestName: 'Budiarti',
      guestEmail: 'budiarti@gmail.com',
      checkInDate: '12 Okt 2026',
      checkOutDate: '14 Okt 2026',
      totalNights: 2,
      totalPrice: 1040000,
      paymentMethod: 'QRIS',
      status: BookingStatus.waitingCheckIn,
      createdAt: DateTime.now(),
    ),
    BookingEntity(
      id: 'bkg-2',
      bookingCode: 'SJ-719302',
      hotelId: 'htl-2',
      hotelName: 'Prawirotaman Arts & Boutique Villa',
      roomName: 'Bohemian Garden Room',
      hotelImageUrl: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
      guestName: 'Budiarti',
      guestEmail: 'budiarti@gmail.com',
      checkInDate: '01 Sep 2026',
      checkOutDate: '03 Sep 2026',
      totalNights: 2,
      totalPrice: 840000,
      paymentMethod: 'BCA VA',
      status: BookingStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Future<BookingEntity> createBooking(BookingEntity booking) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      _bookings.insert(0, booking);
      return booking;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookingEntity>> getUserBookings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return List.unmodifiable(_bookings);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
