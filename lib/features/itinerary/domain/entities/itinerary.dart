import 'package:equatable/equatable.dart';

enum AttractionCategory {
  wisata('Wisata Budaya & Sejarah', '🏛️'),
  alam('Wisata Alam', '🌿'),
  kuliner('Kuliner Khas', '🍲'),
  belanja('Belanja & Oleh-oleh', '🛍️'),
  kafe('Kafe & Tempat Nongkrong', '☕'),
  malam('Hiburan Malam', '🌙');

  final String label;
  final String icon;
  const AttractionCategory(this.label, this.icon);
}

class Attraction extends Equatable {
  final String id;
  final String name;
  final AttractionCategory category;
  final String description;
  final double latitude;
  final double longitude;
  final String openingHours;
  final int ticketPrice;
  final int estimatedDurationMinutes; // durasi kunjungan ideal
  final double distanceFromHotelKm;
  final int travelTimeMinutes;
  final double rating;
  final String imageUrl;

  const Attraction({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.openingHours,
    required this.ticketPrice,
    required this.estimatedDurationMinutes,
    required this.distanceFromHotelKm,
    required this.travelTimeMinutes,
    required this.rating,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        description,
        latitude,
        longitude,
        openingHours,
        ticketPrice,
        estimatedDurationMinutes,
        distanceFromHotelKm,
        travelTimeMinutes,
        rating,
        imageUrl,
      ];
}

// ─── Itinerary Item Model ───────────────────────────────────────────────────
class ItineraryItem extends Equatable {
  final String id;
  final int order;
  final Attraction attraction;
  final String startTime;
  final String endTime;
  final int travelTimeFromPreviousMinutes;
  final String notes;

  const ItineraryItem({
    required this.id,
    required this.order,
    required this.attraction,
    required this.startTime,
    required this.endTime,
    required this.travelTimeFromPreviousMinutes,
    this.notes = '',
  });

  @override
  List<Object?> get props => [
        id,
        order,
        attraction,
        startTime,
        endTime,
        travelTimeFromPreviousMinutes,
        notes,
      ];
}

// ─── Daily Plan Model ───────────────────────────────────────────────────────
class DayPlan extends Equatable {
  final int dayNumber;
  final String date;
  final List<ItineraryItem> items;
  final int totalTravelMinutes;
  final int estimatedDailyCost;

  const DayPlan({
    required this.dayNumber,
    required this.date,
    required this.items,
    required this.totalTravelMinutes,
    required this.estimatedDailyCost,
  });

  @override
  List<Object?> get props => [
        dayNumber,
        date,
        items,
        totalTravelMinutes,
        estimatedDailyCost,
      ];
}

// ─── Complete Itinerary Model ───────────────────────────────────────────────
class TripItinerary extends Equatable {
  final String id;
  final String title;
  final String hotelName;
  final String hotelArea;
  final int totalDays;
  final String pace; // 'santai' / 'padat'
  final List<String> interests;
  final List<DayPlan> days;
  final DateTime createdAt;

  const TripItinerary({
    required this.id,
    required this.title,
    required this.hotelName,
    required this.hotelArea,
    required this.totalDays,
    required this.pace,
    required this.interests,
    required this.days,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        hotelName,
        hotelArea,
        totalDays,
        pace,
        interests,
        days,
        createdAt,
      ];
}
