import 'package:dartz/dartz.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/features/auth/domain/entities/user.dart';
import 'package:stayjogja_flutter/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  UserEntity? _currentUser = const UserEntity(
    id: 'usr-1',
    name: 'Budiarti',
    email: 'budiarti@gmail.com',
    phoneNumber: '+62 812-3456-7890',
  );

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = UserEntity(
      id: 'usr-1',
      name: email.split('@').first,
      email: email,
      phoneNumber: '+62 812-3456-7890',
    );
    return Right(_currentUser!);
  }

  @override
  Future<Either<Failure, UserEntity>> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = UserEntity(
      id: 'usr-1',
      name: name,
      email: email,
      phoneNumber: '+62 812-3456-7890',
    );
    return Right(_currentUser!);
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Right(_currentUser!);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    _currentUser = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    return Right(_currentUser);
  }
}
