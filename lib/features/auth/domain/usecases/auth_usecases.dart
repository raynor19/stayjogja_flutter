import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/core/usecase/usecase.dart';
import 'package:stayjogja_flutter/features/auth/domain/entities/user.dart';
import 'package:stayjogja_flutter/features/auth/domain/repositories/auth_repository.dart';

// ─── LOGIN ─────────────────────────────────────────────────────────────────
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

// ─── REGISTER ──────────────────────────────────────────────────────────────
class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? birthDate;
  final String? gender;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.birthDate,
    this.gender,
  });

  @override
  List<Object?> get props => [name, email, password, phone, birthDate, gender];
}

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      phone: params.phone,
      birthDate: params.birthDate,
      gender: params.gender,
    );
  }
}
