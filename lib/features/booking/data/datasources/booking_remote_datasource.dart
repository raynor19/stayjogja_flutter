import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stayjogja_flutter/core/error/exceptions.dart';
import 'package:stayjogja_flutter/features/booking/domain/entities/booking.dart';

abstract class BookingRemoteDataSource {
  Future<BookingEntity> createBooking(BookingEntity booking);
  Future<List<BookingEntity>> getUserBookings();
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore _firestore;

  BookingRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final List<BookingEntity> _initialFallback = [
    BookingEntity(
      id: 'bkg-1',
      bookingCode: 'SJ-928104',
      hotelId: 'htl-1',
      hotelName: 'Grand Malioboro Heritage Hotel',
      roomName: 'Deluxe Heritage King',
      hotelImageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      guestName: 'Raynor',
      guestEmail: 'raynormuhammad19@gmail.com',
      checkInDate: '12 Okt 2026',
      checkOutDate: '14 Okt 2026',
      totalNights: 2,
      totalPrice: 1040000,
      paymentMethod: 'QRIS',
      status: BookingStatus.waitingCheckIn,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<BookingEntity> createBooking(BookingEntity booking) async {
    try {
      await _firestore.collection('bookings').doc(booking.id).set({
        'id': booking.id,
        'booking_code': booking.bookingCode,
        'hotel_id': booking.hotelId,
        'hotel_name': booking.hotelName,
        'room_name': booking.roomName,
        'hotel_image_url': booking.hotelImageUrl,
        'guest_name': booking.guestName,
        'guest_email': booking.guestEmail,
        'check_in_date': booking.checkInDate,
        'check_out_date': booking.checkOutDate,
        'total_nights': booking.totalNights,
        'total_price': booking.totalPrice,
        'payment_method': booking.paymentMethod,
        'status': booking.status.name,
        'created_at': booking.createdAt.toIso8601String(),
      });
      _initialFallback.insert(0, booking);
      return booking;
    } catch (_) {
      _initialFallback.insert(0, booking);
      return booking;
    }
  }

  @override
  Future<List<BookingEntity>> getUserBookings() async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .orderBy('created_at', descending: true)
          .get()
          .timeout(const Duration(seconds: 3));

      if (snapshot.docs.isEmpty) return _initialFallback;

      return snapshot.docs.map((doc) {
        final d = doc.data();
        return BookingEntity(
          id: d['id'] as String,
          bookingCode: d['booking_code'] as String,
          hotelId: d['hotel_id'] as String,
          hotelName: d['hotel_name'] as String,
          roomName: d['room_name'] as String,
          hotelImageUrl: d['hotel_image_url'] as String? ?? '',
          guestName: d['guest_name'] as String,
          guestEmail: d['guest_email'] as String,
          checkInDate: d['check_in_date'] as String,
          checkOutDate: d['check_out_date'] as String,
          totalNights: d['total_nights'] as int? ?? 1,
          totalPrice: d['total_price'] as int? ?? 0,
          paymentMethod: d['payment_method'] as String? ?? 'QRIS',
          status: _statusFromString(d['status'] as String?),
          createdAt: DateTime.tryParse(d['created_at'] as String? ?? '') ?? DateTime.now(),
        );
      }).toList();
    } catch (_) {
      return _initialFallback;
    }
  }

  BookingStatus _statusFromString(String? st) {
    if (st == null) return BookingStatus.waitingCheckIn;
    switch (st) {
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.waitingCheckIn;
    }
  }
}
