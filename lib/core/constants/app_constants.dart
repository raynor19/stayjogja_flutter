class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Stay Jogja';
  static const String appTagline = 'Hotel & AI Trip Planner Jogja';

  // Base URL (ganti sesuai backend nanti)
  static const String baseUrl = 'https://api.stayjogja.com/v1';

  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyLanguage = 'language';

  // Hive Box Names
  static const String boxItinerary = 'itinerary_box';
  static const String boxBooking = 'booking_box';
  static const String boxUser = 'user_box';

  // Pagination
  static const int defaultPageSize = 10;
  static const int hotelPageSize = 15;

  // Timeouts (ms)
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 30000;
  static const int aiGenerateTimeout = 60000;

  // AI Itinerary Rules
  static const int maxActivitiesSantai = 5;
  static const int maxActivitiesPadat = 7;
  static const double maxTravelHoursPerDay = 2.5;
  static const int maxItineraryDays = 7;
  static const int maxGeneratePerDay = 5; // batas generate AI per user per hari

  // Search
  static const int minSearchLength = 2;
  static const List<String> popularAreas = [
    'Semua',
    'Malioboro',
    'Prawirotaman',
    'Kraton',
    'Kotagede',
    'Kaliurang',
    'Sleman',
    'Bantul',
    'Gunungkidul',
    'Kulon Progo',
  ];

  // Map
  static const double defaultLat = -7.7956; // Tugu Jogja
  static const double defaultLng = 110.3695;
  static const double defaultZoom = 13.0;
  static const double attractionDefaultRadius = 5000; // meter

  // Currency
  static const String currency = 'IDR';
  static const String currencySymbol = 'Rp';

  // Date formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateFormatShort = 'dd MMM';
  static const String dateTimeFormat = 'dd MMM yyyy, HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';

  // Image placeholder
  static const String placeholderHotel = 'assets/images/placeholder_hotel.png';
  static const String placeholderAttraction = 'assets/images/placeholder_attraction.png';
  static const String placeholderUser = 'assets/images/placeholder_user.png';

  // Min touch target (accessibility)
  static const double minTouchTarget = 44.0;
}

class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';

  // Main
  static const String home = '/home';
  static const String search = '/search';
  static const String searchResult = '/search/result';

  // Hotel
  static const String hotelDetail = '/hotel/:id';
  static const String roomDetail = '/hotel/:id/room/:roomId';

  // Booking
  static const String bookingReview = '/booking/review';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment/success';
  static const String eVoucher = '/booking/:id/voucher';
  static const String bookings = '/bookings';
  static const String bookingDetail = '/bookings/:id';

  // Itinerary
  static const String itineraryPreference = '/itinerary/preference';
  static const String itineraryGenerate = '/itinerary/generate';
  static const String itineraryResult = '/itinerary/:id';
  static const String itineraryList = '/itinerary';
  static const String itineraryEdit = '/itinerary/:id/edit';

  // Attraction
  static const String attractionList = '/attractions';
  static const String attractionDetail = '/attractions/:id';

  // Profile & Settings
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String wishlist = '/wishlist';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String help = '/help';
}
