import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Terjadi kesalahan pada server']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Koneksi internet bermasalah']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Gagal memuat data lokal']);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Autentikasi gagal']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
