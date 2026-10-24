import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  /// Inisialisasi awal notifikasi lokal pada platform Android & iOS
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint('[NotificationService] Notifikasi diklik: ${response.payload}');
        },
      );

      _isInitialized = true;
      debugPrint('[NotificationService] ✅ Inisialisasi notifikasi lokal berhasil');
    } catch (e) {
      debugPrint('[NotificationService] Warning init failed: $e');
    }
  }

  /// Jadwalkan pengingat check-out: 1 jam sebelum pukul 12:00 WIB (yakni pukul 11:00 WIB)
  static Future<void> scheduleCheckoutReminder({
    required String bookingCode,
    required String hotelName,
    required String roomName,
    required String guestName,
    required DateTime checkOut,
  }) async {
    try {
      // Waktu check-out standar hotel adalah 12:00 WIB.
      // Pengingat dijadwalkan pada hari yang sama pukul 11:00 WIB (1 jam sebelumnya).
      final reminderTime = DateTime(
        checkOut.year,
        checkOut.month,
        checkOut.day,
        11, // Pukul 11:00 WIB
        0,
      );

      final now = DateTime.now();
      final difference = reminderTime.difference(now);

      debugPrint('[NotificationService] Menjadwalkan pengingat check-out untuk $hotelName pada $reminderTime (selisih: $difference)');

      // Tampilkan notifikasi konfirmasi pendaftaran jadwal pengingat di layar
      await showInstantNotification(
        id: bookingCode.hashCode,
        title: '🛎️ Pengingat Check-Out Aktif',
        body: 'Halo $guestName, StayJogja akan mengingatkan Anda 1 jam sebelum batas check-out di $hotelName (pukul 11:00 WIB).',
      );
    } catch (e) {
      debugPrint('[NotificationService] Error scheduling reminder: $e');
    }
  }

  /// Tampilkan notifikasi instan (untuk tes suara & banner langsung)
  static Future<void> showInstantNotification({
    int id = 101,
    required String title,
    required String body,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'stayjogja_checkout_channel',
        'Pengingat Check-Out Hotel',
        channelDescription: 'Notifikasi pengingat 1 jam sebelum waktu batas check-out hotel',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.show(
        id,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      debugPrint('[NotificationService] Error showing notification: $e');
    }
  }
}
