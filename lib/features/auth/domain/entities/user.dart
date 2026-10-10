import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? photoUrl;
  final bool isMember;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.photoUrl,
    this.isMember = true,
  });

  @override
  List<Object?> get props => [id, name, email, phoneNumber, photoUrl, isMember];
}
