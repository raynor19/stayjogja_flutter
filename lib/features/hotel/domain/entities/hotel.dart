import 'package:equatable/equatable.dart';

// ─── Room Type Model ────────────────────────────────────────────────────────
class RoomType extends Equatable {
  final String id;
  final String hotelId;
  final String name;
  final String description;
  final int capacity;
  final int pricePerNight;
  final int originalPrice;
  final int stock;
  final List<String> facilities;
  final List<String> images;
  final String cancellationPolicy;
  final bool hasBreakfast;

  const RoomType({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.description,
    required this.capacity,
    required this.pricePerNight,
    required this.originalPrice,
    required this.stock,
    required this.facilities,
    required this.images,
    required this.cancellationPolicy,
    this.hasBreakfast = false,
  });

  @override
  List<Object?> get props => [
        id,
        hotelId,
        name,
        description,
        capacity,
        pricePerNight,
        originalPrice,
        stock,
        facilities,
        images,
        cancellationPolicy,
        hasBreakfast,
      ];
}

// ─── Hotel Model ───────────────────────────────────────────────────────────
class Hotel extends Equatable {
  final String id;
  final String name;
  final String area;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int totalReviews;
  final int star;
  final int startingPrice;
  final List<String> images;
  final List<String> facilities;
  final String description;
  final String policy;
  final List<RoomType> rooms;
  final String badge; // 'Best Value', 'Popular', 'Member Exclusive'

  const Hotel({
    required this.id,
    required this.name,
    required this.area,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.totalReviews,
    required this.star,
    required this.startingPrice,
    required this.images,
    required this.facilities,
    required this.description,
    required this.policy,
    required this.rooms,
    this.badge = '',
  });

  @override
  List<Object?> get props => [
        id,
        name,
        area,
        address,
        latitude,
        longitude,
        rating,
        totalReviews,
        star,
        startingPrice,
        images,
        facilities,
        description,
        policy,
        rooms,
        badge,
      ];
}
