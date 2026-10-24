import 'package:equatable/equatable.dart';

enum BookingStatus {
  waitingCheckIn('Menunggu Check-in'),
  completed('Selesai'),
  cancelled('Dibatalkan');

  final String label;
  const BookingStatus(this.label);
}

class BookingEntity extends Equatable {
  final String id;
  final String bookingCode;
  final String hotelId;
  final String hotelName;
  final String roomName;
  final String hotelImageUrl;
  final String guestName;
  final String guestEmail;
  final String checkInDate;
  final String checkOutDate;
  final int totalNights;
  final int totalPrice;
  final String paymentMethod;
  final BookingStatus status;
  final DateTime createdAt;

  final String? guestNik;
  final bool isKtpVerified;
  final String? guestKtpPhoto;

  const BookingEntity({
    required this.id,
    required this.bookingCode,
    required this.hotelId,
    required this.hotelName,
    required this.roomName,
    required this.hotelImageUrl,
    required this.guestName,
    required this.guestEmail,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalNights,
    required this.totalPrice,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.guestNik,
    this.isKtpVerified = false,
    this.guestKtpPhoto,
  });

  @override
  List<Object?> get props => [
        id,
        bookingCode,
        hotelId,
        hotelName,
        roomName,
        guestName,
        guestEmail,
        checkInDate,
        checkOutDate,
        totalNights,
        totalPrice,
        paymentMethod,
        status,
        createdAt,
        guestNik,
        isKtpVerified,
        guestKtpPhoto,
      ];
}
