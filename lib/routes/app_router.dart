import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/widgets/app_page_transitions.dart';
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
import 'package:stayjogja_flutter/features/booking/presentation/pages/bookings_page.dart';
import 'package:stayjogja_flutter/features/itinerary/presentation/pages/saved_itineraries_page.dart';
import 'package:stayjogja_flutter/features/profile/presentation/pages/profile_page.dart';
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
      pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
        context: context,
        state: state,
        child: const OnboardingPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
        context: context,
        state: state,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      pageBuilder: (context, state) => AppPageTransitions.slideUpTransition(
        context: context,
        state: state,
        child: const RegisterPage(),
      ),
    ),

    // ── Hotel Detail (Shared-Axis Zoom Fade) ────────────────────
    GoRoute(
      path: '/hotel/:id',
      pageBuilder: (context, state) {
        final hotelId = state.pathParameters['id'] ?? 'htl-1';
        final cin = state.uri.queryParameters['cin'];
        final cout = state.uri.queryParameters['cout'];
        return AppPageTransitions.zoomFadeTransition(
          context: context,
          state: state,
          child: HotelDetailPage(
            hotelId: hotelId,
            initialCheckIn: cin,
            initialCheckOut: cout,
          ),
        );
      },
    ),

    // ── Itinerary AI Flow (Slide Up Sheet & Zoom Fade) ──────────
    GoRoute(
      path: AppRoutes.itineraryPreference,
      pageBuilder: (context, state) {
        final hotelId = state.uri.queryParameters['hotelId'] ?? 'htl-1';
        return AppPageTransitions.slideUpTransition(
          context: context,
          state: state,
          child: ItineraryPreferencePage(hotelId: hotelId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.itineraryGenerate,
      pageBuilder: (context, state) {
        final hotelId = state.uri.queryParameters['hotelId'] ?? 'htl-1';
        final days = int.tryParse(state.uri.queryParameters['days'] ?? '3') ?? 3;
        final pace = state.uri.queryParameters['pace'] ?? 'santai';
        return AppPageTransitions.fadeTransition(
          context: context,
          state: state,
          child: ItineraryGeneratePage(hotelId: hotelId, days: days, pace: pace),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.itineraryList}/result',
      pageBuilder: (context, state) {
        final hotelId = state.uri.queryParameters['hotelId'] ?? 'htl-tentrem';
        final days = int.tryParse(state.uri.queryParameters['days'] ?? '3') ?? 3;
        final pace = state.uri.queryParameters['pace'] ?? 'santai';
        final itinId = state.uri.queryParameters['id'];
        final title = state.uri.queryParameters['title'];
        final hotelName = state.uri.queryParameters['hotelName'];

        return AppPageTransitions.zoomFadeTransition(
          context: context,
          state: state,
          child: ItineraryResultPage(
            hotelId: hotelId,
            days: days,
            pace: pace,
            itineraryIdOverride: itinId,
            titleOverride: title,
            hotelNameOverride: hotelName,
          ),
        );
      },
    ),

    // ── Booking Flow (Slide Up) ─────────────────────────────────
    GoRoute(
      path: AppRoutes.checkout,
      pageBuilder: (context, state) {
        final hotelId = state.uri.queryParameters['hotelId'] ?? 'htl-1';
        final roomId = state.uri.queryParameters['roomId'] ?? 'rm-101';
        final cin = state.uri.queryParameters['cin'];
        final cout = state.uri.queryParameters['cout'];
        return AppPageTransitions.slideUpTransition(
          context: context,
          state: state,
          child: CheckoutPage(
            hotelId: hotelId,
            roomId: roomId,
            initialCheckIn: cin,
            initialCheckOut: cout,
          ),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.checkout}/success',
      pageBuilder: (context, state) {
        final hotelId = state.uri.queryParameters['hotelId'] ?? 'htl-tentrem';
        final roomId = state.uri.queryParameters['roomId'] ?? 'rm-tentrem-deluxe';
        final code = state.uri.queryParameters['code'];
        final price = int.tryParse(state.uri.queryParameters['price'] ?? '');
        final guest = state.uri.queryParameters['guest'];
        final cin = state.uri.queryParameters['cin'];
        final cout = state.uri.queryParameters['cout'];

        return AppPageTransitions.zoomFadeTransition(
          context: context,
          state: state,
          child: PaymentSuccessPage(
            hotelId: hotelId,
            roomId: roomId,
            bookingCodeOverride: code,
            totalPriceOverride: price,
            guestNameOverride: guest,
            checkInOverride: cin,
            checkOutOverride: cout,
          ),
        );
      },
    ),

    // ── Main Shell (Bottom Nav Tabs: Seamless Instant Cross-Fade)
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
            context: context,
            state: state,
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.search,
          pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
            context: context,
            state: state,
            child: const HotelSearchPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.bookings,
          pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
            context: context,
            state: state,
            child: const BookingsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
            context: context,
            state: state,
            child: const ProfilePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.itineraryList,
          pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
            context: context,
            state: state,
            child: const SavedItinerariesPage(),
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
