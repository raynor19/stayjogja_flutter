import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/features/auth/presentation/pages/splash_page.dart';
import 'package:stayjogja_flutter/features/auth/presentation/pages/onboarding_page.dart';
import 'package:stayjogja_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:stayjogja_flutter/features/auth/presentation/pages/register_page.dart';
import 'package:stayjogja_flutter/features/home/presentation/pages/home_page.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/pages/hotel_detail_page.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/pages/hotel_search_page.dart';
import 'package:stayjogja_flutter/features/itinerary/presentation/pages/itinerary_preference_page.dart';
import 'package:stayjogja_flutter/features/itinerary/presentation/pages/itinerary_generate_page.dart';
import 'package:stayjogja_flutter/features/itinerary/presentation/pages/itinerary_result_page.dart';
import 'package:stayjogja_flutter/features/booking/presentation/pages/checkout_page.dart';
import 'package:stayjogja_flutter/features/booking/presentation/pages/payment_success_page.dart';
import 'package:stayjogja_flutter/core/widgets/main_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    // ── Auth ────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),

    // ── Hotel Detail ────────────────────────────────────────────
    GoRoute(
      path: '/hotel/:id',
      builder: (context, state) {
        final hotelId = state.pathParameters['id'] ?? 'htl-1';
        return HotelDetailPage(hotelId: hotelId);
      },
    ),

    // ── Itinerary AI Flow ───────────────────────────────────────
    GoRoute(
      path: AppRoutes.itineraryPreference,
      builder: (context, state) {
        final hotelId = state.uri.queryParameters['hotelId'] ?? 'htl-1';
        return ItineraryPreferencePage(hotelId: hotelId);
      },
    ),
    GoRoute(
      path: AppRoutes.itineraryGenerate,
      builder: (context, state) {
        final hotelId = state.uri.queryParameters['hotelId'] ?? 'htl-1';
        final days = int.tryParse(state.uri.queryParameters['days'] ?? '3') ?? 3;
        final pace = state.uri.queryParameters['pace'] ?? 'santai';
        return ItineraryGeneratePage(hotelId: hotelId, days: days, pace: pace);
      },
    ),
    GoRoute(
      path: '${AppRoutes.itineraryList}/result',
      builder: (context, state) {
        final hotelId = state.uri.queryParameters['hotelId'] ?? 'htl-1';
        final days = int.tryParse(state.uri.queryParameters['days'] ?? '3') ?? 3;
        final pace = state.uri.queryParameters['pace'] ?? 'santai';
        return ItineraryResultPage(hotelId: hotelId, days: days, pace: pace);
      },
    ),

    // ── Booking Flow ────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.checkout,
      builder: (context, state) {
        final hotelId = state.uri.queryParameters['hotelId'] ?? 'htl-1';
        final roomId = state.uri.queryParameters['roomId'] ?? 'rm-101';
        return CheckoutPage(hotelId: hotelId, roomId: roomId);
      },
    ),
    GoRoute(
      path: '${AppRoutes.checkout}/success',
      builder: (context, state) {
        final hotelId = state.uri.queryParameters['hotelId'] ?? 'htl-1';
        final roomId = state.uri.queryParameters['roomId'] ?? 'rm-101';
        return PaymentSuccessPage(hotelId: hotelId, roomId: roomId);
      },
    ),

    // ── Main Shell (Bottom Nav) ──────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) => const HotelSearchPage(),
        ),
        GoRoute(
          path: AppRoutes.bookings,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Riwayat Booking Kamu')),
          ),
        ),
        GoRoute(
          path: AppRoutes.itineraryList,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Itinerary Tersimpan')),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Profil Pengguna')),
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
);
