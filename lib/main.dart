import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stayjogja_flutter/core/di/injection.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/routes/app_router.dart';

// Bloc/Cubits
import 'package:stayjogja_flutter/features/hotel/presentation/bloc/hotel_cubit.dart';
import 'package:stayjogja_flutter/features/itinerary/presentation/bloc/itinerary_cubit.dart';
import 'package:stayjogja_flutter/features/booking/presentation/bloc/booking_cubit.dart';
import 'package:stayjogja_flutter/features/auth/presentation/bloc/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inisialisasi Clean Architecture Service Locator (GetIt)
  await initServiceLocator();

  runApp(const StayJogjaApp());
}

class StayJogjaApp extends StatelessWidget {
  const StayJogjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HotelCubit>(create: (_) => sl<HotelCubit>()..loadHotels()),
        BlocProvider<ItineraryCubit>(create: (_) => sl<ItineraryCubit>()..loadSavedItineraries()),
        BlocProvider<BookingCubit>(create: (_) => sl<BookingCubit>()..loadUserBookings()),
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Stay Jogja',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
