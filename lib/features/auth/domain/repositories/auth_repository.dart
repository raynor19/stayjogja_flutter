import 'package:dartz/dartz.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? birthDate,
    String? gender,
  });
  Future<Either<Failure, UserEntity>> loginWithGoogle({
    String? phone,
    String? birthDate,
    String? gender,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
