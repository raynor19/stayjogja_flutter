import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stayjogja_flutter/core/usecase/usecase.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/usecases/generate_itinerary_usecase.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/usecases/get_saved_itineraries_usecase.dart';

// ─── States ────────────────────────────────────────────────────────────────
abstract class ItineraryState extends Equatable {
  const ItineraryState();

  @override
  List<Object?> get props => [];
}

class ItineraryInitial extends ItineraryState {}

class ItineraryGenerating extends ItineraryState {
  final int currentStep;
  const ItineraryGenerating({this.currentStep = 0});

  @override
  List<Object?> get props => [currentStep];
}

class ItineraryGenerated extends ItineraryState {
  final TripItinerary itinerary;
  const ItineraryGenerated(this.itinerary);

  @override
  List<Object?> get props => [itinerary];
}

class SavedItinerariesLoaded extends ItineraryState {
  final List<TripItinerary> itineraries;
  const SavedItinerariesLoaded(this.itineraries);

  @override
  List<Object?> get props => [itineraries];
}

class ItineraryError extends ItineraryState {
  final String message;
  const ItineraryError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Cubit ─────────────────────────────────────────────────────────────────
class ItineraryCubit extends Cubit<ItineraryState> {
  final GenerateItineraryUseCase generateItineraryUseCase;
  final GetSavedItinerariesUseCase getSavedItinerariesUseCase;

  ItineraryCubit({
    required this.generateItineraryUseCase,
    required this.getSavedItinerariesUseCase,
  }) : super(ItineraryInitial());

  Future<void> generateItinerary({
    required Hotel hotel,
    required int daysCount,
    required String pace,
    required List<String> preferences,
  }) async {
    emit(const ItineraryGenerating());
    final result = await generateItineraryUseCase(
      GenerateItineraryParams(
        hotel: hotel,
        daysCount: daysCount,
        pace: pace,
        preferences: preferences,
      ),
    );
    result.fold(
      (failure) => emit(ItineraryError(failure.message)),
      (itinerary) => emit(ItineraryGenerated(itinerary)),
    );
  }

  Future<void> loadSavedItineraries() async {
    emit(const ItineraryGenerating());
    final result = await getSavedItinerariesUseCase(NoParams());
    result.fold(
      (failure) => emit(ItineraryError(failure.message)),
      (list) => emit(SavedItinerariesLoaded(list)),
    );
  }
}
