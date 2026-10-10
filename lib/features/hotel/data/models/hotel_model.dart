import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';

class RoomTypeModel extends RoomType {
  const RoomTypeModel({
    required super.id,
    required super.hotelId,
    required super.name,
    required super.description,
    required super.capacity,
    required super.pricePerNight,
    required super.originalPrice,
    required super.stock,
    required super.facilities,
    required super.images,
    required super.cancellationPolicy,
    super.hasBreakfast = false,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) {
    return RoomTypeModel(
      id: json['id'] as String,
      hotelId: json['hotel_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      capacity: json['capacity'] as int? ?? 2,
      pricePerNight: json['price_per_night'] as int,
      originalPrice: json['original_price'] as int? ?? json['price_per_night'] as int,
      stock: json['stock'] as int? ?? 1,
      facilities: List<String>.from(json['facilities'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      cancellationPolicy: json['cancellation_policy'] as String? ?? 'Standar',
      hasBreakfast: json['has_breakfast'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'name': name,
      'description': description,
      'capacity': capacity,
      'price_per_night': pricePerNight,
      'original_price': originalPrice,
      'stock': stock,
      'facilities': facilities,
      'images': images,
      'cancellation_policy': cancellationPolicy,
      'has_breakfast': hasBreakfast,
    };
  }
}

class HotelModel extends Hotel {
  const HotelModel({
    required super.id,
    required super.name,
    required super.area,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.rating,
    required super.totalReviews,
    required super.star,
    required super.startingPrice,
    required super.images,
    required super.facilities,
    required super.description,
    required super.policy,
    required super.rooms,
    super.badge = '',
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      area: json['area'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      totalReviews: json['total_reviews'] as int? ?? 0,
      star: json['star'] as int? ?? 3,
      startingPrice: json['starting_price'] as int,
      badge: json['badge'] as String? ?? '',
      images: List<String>.from(json['images'] ?? []),
      facilities: List<String>.from(json['facilities'] ?? []),
      description: json['description'] as String? ?? '',
      policy: json['policy'] as String? ?? '',
      rooms: (json['rooms'] as List<dynamic>? ?? [])
          .map((r) => RoomTypeModel.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'total_reviews': totalReviews,
      'star': star,
      'starting_price': startingPrice,
      'badge': badge,
      'images': images,
      'facilities': facilities,
      'description': description,
      'policy': policy,
      'rooms': rooms.map((r) => (r as RoomTypeModel).toJson()).toList(),
    };
  }
}
