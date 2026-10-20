import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stayjogja_flutter/core/utils/location_helper.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/domain/usecases/get_hotels_usecase.dart';
import 'package:stayjogja_flutter/features/hotel/domain/usecases/get_hotel_detail_usecase.dart';

enum HotelSortOption {
  popularity('Paling Populer & Rekomendasi'),
  distanceNearest('Jarak Terdekat ke Pusat Malioboro'),
  priceLowest('Harga: Rendah ke Tinggi'),
  priceHighest('Harga: Tinggi ke Rendah'),
  ratingHighest('Rating Ulasan Tertinggi');

  final String label;
  const HotelSortOption(this.label);
}

// ─── States ────────────────────────────────────────────────────────────────
abstract class HotelState extends Equatable {
  const HotelState();

  @override
  List<Object?> get props => [];
}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelLoaded extends HotelState {
  final List<Hotel> hotels;
  final String selectedArea;
  final HotelSortOption activeSort;
  final String searchQuery;

  const HotelLoaded({
    required this.hotels,
    this.selectedArea = 'Semua',
    this.activeSort = HotelSortOption.popularity,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [hotels, selectedArea, activeSort, searchQuery];
}

class HotelDetailLoaded extends HotelState {
  final Hotel hotel;

  const HotelDetailLoaded(this.hotel);

  @override
  List<Object?> get props => [hotel];
}

class HotelError extends HotelState {
  final String message;

  const HotelError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Cubit ─────────────────────────────────────────────────────────────────
class HotelCubit extends Cubit<HotelState> {
  final GetHotelsUseCase getHotelsUseCase;
  final GetHotelDetailUseCase getHotelDetailUseCase;

  List<Hotel> _cachedAllHotels = [];

  HotelCubit({
    required this.getHotelsUseCase,
    required this.getHotelDetailUseCase,
  }) : super(HotelInitial());

  Future<void> loadHotels({String? area, String? query}) async {
    emit(HotelLoading());
    final result = await getHotelsUseCase(GetHotelsParams(area: area, query: query));
    result.fold(
      (failure) => emit(HotelError(failure.message)),
      (hotels) {
        if (area == null || area == 'Semua') {
          _cachedAllHotels = List.from(hotels);
        }
        emit(HotelLoaded(
          hotels: hotels,
          selectedArea: area ?? 'Semua',
          searchQuery: query ?? '',
        ));
      },
    );
  }

  /// Instant In-Memory Search (0 ms delay, no screen flickering)
  void searchHotels(String query) {
    final cleanQ = query.trim().toLowerCase();

    if (_cachedAllHotels.isEmpty && state is HotelLoaded) {
      _cachedAllHotels = List.from((state as HotelLoaded).hotels);
    }

    if (cleanQ.isEmpty) {
      emit(HotelLoaded(
        hotels: _cachedAllHotels,
        selectedArea: state is HotelLoaded ? (state as HotelLoaded).selectedArea : 'Semua',
        searchQuery: '',
      ));
      return;
    }

    // Filter instan berdasarkan nama hotel, kawasan, alamat, atau fasilitas
    final filtered = _cachedAllHotels.where((h) {
      final nameMatches = h.name.toLowerCase().contains(cleanQ);
      final areaMatches = h.area.toLowerCase().contains(cleanQ);
      final addressMatches = h.address.toLowerCase().contains(cleanQ);
      final facilityMatches = h.facilities.any((f) => f.toLowerCase().contains(cleanQ));
      final roomMatches = h.rooms.any((r) => r.name.toLowerCase().contains(cleanQ));
      return nameMatches || areaMatches || addressMatches || facilityMatches || roomMatches;
    }).toList();

    emit(HotelLoaded(
      hotels: filtered,
      selectedArea: state is HotelLoaded ? (state as HotelLoaded).selectedArea : 'Semua',
      searchQuery: query,
    ));
  }

  void sortHotels(HotelSortOption option) {
    if (state is HotelLoaded) {
      final current = state as HotelLoaded;
      final sortedList = List<Hotel>.from(current.hotels);

      switch (option) {
        case HotelSortOption.distanceNearest:
          sortedList.sort((a, b) {
            final distA = LocationHelper.calculateDistanceKm(lat1: a.latitude, lon1: a.longitude);
            final distB = LocationHelper.calculateDistanceKm(lat1: b.latitude, lon1: b.longitude);
            return distA.compareTo(distB);
          });
          break;
        case HotelSortOption.priceLowest:
          sortedList.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
          break;
        case HotelSortOption.priceHighest:
          sortedList.sort((a, b) => b.startingPrice.compareTo(a.startingPrice));
          break;
        case HotelSortOption.ratingHighest:
          sortedList.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case HotelSortOption.popularity:
          sortedList.sort((a, b) => b.totalReviews.compareTo(a.totalReviews));
          break;
      }

      emit(HotelLoaded(
        hotels: sortedList,
        selectedArea: current.selectedArea,
        activeSort: option,
        searchQuery: current.searchQuery,
      ));
    }
  }

  Future<void> loadHotelDetail(String id) async {
    emit(HotelLoading());
    final result = await getHotelDetailUseCase(id);
    result.fold(
      (failure) => emit(HotelError(failure.message)),
      (hotel) => emit(HotelDetailLoaded(hotel)),
    );
  }
}
