import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? photoUrl;
  final bool isMember;
  final String? nik;
  final bool isKtpVerified;
  final String? ktpPhoto;
  final String ktpStatus;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.photoUrl,
    this.isMember = true,
    this.nik,
    this.isKtpVerified = false,
    this.ktpPhoto,
    this.ktpStatus = 'unverified',
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        photoUrl,
        isMember,
        nik,
        isKtpVerified,
        ktpPhoto,
        ktpStatus,
      ];
}
