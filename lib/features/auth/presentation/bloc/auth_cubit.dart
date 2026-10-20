import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stayjogja_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stayjogja_flutter/features/auth/domain/entities/user.dart';
import 'package:stayjogja_flutter/features/auth/domain/usecases/auth_usecases.dart';

// ─── States ────────────────────────────────────────────────────────────────
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Cubit ─────────────────────────────────────────────────────────────────
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final AuthRepositoryImpl authRepository;

  AuthCubit({
    required this.loginUseCase,
    required this.authRepository,
  }) : super(AuthInitial());

  Future<void> checkCurrentUser() async {
    final result = await authRepository.getCurrentUser();
    result.fold(
      (_) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          // Default demo user jika belum pernah login
          const defaultUser = UserEntity(
            id: 'usr-budiarti',
            name: 'Budiarti',
            email: 'budiarti@gmail.com',
            phoneNumber: '+62 812-3456-7890',
            isMember: true,
          );
          emit(const Authenticated(defaultUser));
        }
      },
    );
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (state is Authenticated) {
      final current = (state as Authenticated).user;
      final updated = UserEntity(
        id: current.id,
        name: name,
        email: email,
        phoneNumber: phone,
        photoUrl: current.photoUrl,
        isMember: current.isMember,
      );

      emit(Authenticated(updated));

      // Update langsung ke Cloud Firestore
      await authRepository.updateUserProfile(
        userId: current.id,
        name: name,
        email: email,
        phone: phone,
      );
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    emit(Unauthenticated());
  }
}
