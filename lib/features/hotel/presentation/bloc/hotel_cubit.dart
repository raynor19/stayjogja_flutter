import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/domain/usecases/get_hotels_usecase.dart';
import 'package:stayjogja_flutter/features/hotel/domain/usecases/get_hotel_detail_usecase.dart';

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

  const HotelLoaded({required this.hotels, this.selectedArea = 'Semua'});

  @override
  List<Object?> get props => [hotels, selectedArea];
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

  HotelCubit({
    required this.getHotelsUseCase,
    required this.getHotelDetailUseCase,
  }) : super(HotelInitial());

  Future<void> loadHotels({String? area, String? query}) async {
    emit(HotelLoading());
    final result = await getHotelsUseCase(GetHotelsParams(area: area, query: query));
    result.fold(
      (failure) => emit(HotelError(failure.message)),
      (hotels) => emit(HotelLoaded(hotels: hotels, selectedArea: area ?? 'Semua')),
    );
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
