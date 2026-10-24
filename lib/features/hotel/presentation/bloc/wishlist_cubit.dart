import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistState extends Equatable {
  final List<String> hotelIds;

  const WishlistState({this.hotelIds = const []});

  bool isFavorite(String hotelId) => hotelIds.contains(hotelId);

  @override
  List<Object?> get props => [hotelIds];
}

class WishlistCubit extends Cubit<WishlistState> {
  final FirebaseFirestore _firestore;

  WishlistCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(const WishlistState()) {
    loadWishlist();
  }

  static const _prefKey = 'user_wishlist_hotels';

  Future<void> loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final local = prefs.getStringList(_prefKey) ?? [];
      final userId = prefs.getString('logged_user_id');

      if (userId != null && userId.isNotEmpty) {
        final doc = await _firestore.collection('users').doc(userId).get().timeout(const Duration(seconds: 4));
        if (doc.exists && doc.data() != null && doc.data()!['wishlist'] is List) {
          final cloud = List<String>.from(doc.data()!['wishlist'] as List);
          final merged = {...local, ...cloud}.toList();
          await prefs.setStringList(_prefKey, merged);
          emit(WishlistState(hotelIds: merged));
          return;
        }
      }

      emit(WishlistState(hotelIds: local));
    } catch (_) {
      // Fallback lokal
    }
  }

  Future<void> toggleWishlist(String hotelId) async {
    final current = List<String>.from(state.hotelIds);
    final isFav = current.contains(hotelId);

    if (isFav) {
      current.remove(hotelId);
    } else {
      current.add(hotelId);
    }

    emit(WishlistState(hotelIds: current));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefKey, current);
      final userId = prefs.getString('logged_user_id');

      if (userId != null && userId.isNotEmpty) {
        await _firestore.collection('users').doc(userId).update({
          'wishlist': isFav ? FieldValue.arrayRemove([hotelId]) : FieldValue.arrayUnion([hotelId]),
        });
      }
    } catch (_) {}
  }
}
