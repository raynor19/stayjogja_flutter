import 'package:get_it/get_it.dart';
import 'package:stayjogja_flutter/core/network/api_client.dart';

// Hotel
import 'package:stayjogja_flutter/features/hotel/data/datasources/hotel_remote_datasource.dart';
import 'package:stayjogja_flutter/features/hotel/data/repositories/hotel_repository_impl.dart';
import 'package:stayjogja_flutter/features/hotel/domain/repositories/hotel_repository.dart';
import 'package:stayjogja_flutter/features/hotel/domain/usecases/get_hotels_usecase.dart';
import 'package:stayjogja_flutter/features/hotel/domain/usecases/get_hotel_detail_usecase.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/bloc/hotel_cubit.dart';

// Itinerary
import 'package:stayjogja_flutter/features/itinerary/data/datasources/itinerary_remote_datasource.dart';
import 'package:stayjogja_flutter/features/itinerary/data/repositories/itinerary_repository_impl.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/repositories/itinerary_repository.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/usecases/generate_itinerary_usecase.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/usecases/get_saved_itineraries_usecase.dart';
import 'package:stayjogja_flutter/features/itinerary/presentation/bloc/itinerary_cubit.dart';

// Booking
import 'package:stayjogja_flutter/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:stayjogja_flutter/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:stayjogja_flutter/features/booking/domain/repositories/booking_repository.dart';
import 'package:stayjogja_flutter/features/booking/domain/usecases/booking_usecases.dart';
import 'package:stayjogja_flutter/features/booking/presentation/bloc/booking_cubit.dart';

// Auth
import 'package:stayjogja_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stayjogja_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:stayjogja_flutter/features/auth/domain/usecases/auth_usecases.dart';
import 'package:stayjogja_flutter/features/auth/presentation/bloc/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // ─── Core Network ────────────────────────────────────────────────────────
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ─── Hotel Feature ───────────────────────────────────────────────────────
  // Data Source
  sl.registerLazySingleton<HotelRemoteDataSource>(() => HotelRemoteDataSourceImpl());
  // Repository
  sl.registerLazySingleton<HotelRepository>(
    () => HotelRepositoryImpl(remoteDataSource: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => GetHotelsUseCase(sl()));
  sl.registerLazySingleton(() => GetHotelDetailUseCase(sl()));
  // Cubit
  sl.registerFactory(
    () => HotelCubit(
      getHotelsUseCase: sl(),
      getHotelDetailUseCase: sl(),
    ),
  );

  // ─── Itinerary Feature ───────────────────────────────────────────────────
  // Data Source
  sl.registerLazySingleton<ItineraryRemoteDataSource>(() => ItineraryRemoteDataSourceImpl());
  // Repository
  sl.registerLazySingleton<ItineraryRepository>(
    () => ItineraryRepositoryImpl(remoteDataSource: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => GenerateItineraryUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedItinerariesUseCase(sl()));
  // Cubit
  sl.registerFactory(
    () => ItineraryCubit(
      generateItineraryUseCase: sl(),
      getSavedItinerariesUseCase: sl(),
    ),
  );

  // ─── Booking Feature ─────────────────────────────────────────────────────
  // Data Source
  sl.registerLazySingleton<BookingRemoteDataSource>(() => BookingRemoteDataSourceImpl());
  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetUserBookingsUseCase(sl()));
  // Cubit
  sl.registerFactory(
    () => BookingCubit(
      createBookingUseCase: sl(),
      getUserBookingsUseCase: sl(),
    ),
  );

  // ─── Auth Feature ────────────────────────────────────────────────────────
  // Repository
  final authRepo = AuthRepositoryImpl();
  sl.registerLazySingleton<AuthRepository>(() => authRepo);
  sl.registerLazySingleton<AuthRepositoryImpl>(() => authRepo);
  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  // Cubit
  sl.registerFactory(() => AuthCubit(
        loginUseCase: sl(),
        registerUseCase: sl(),
        authRepository: sl(),
      ));
}
