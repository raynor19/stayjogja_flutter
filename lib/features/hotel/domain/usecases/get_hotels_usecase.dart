import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stayjogja_flutter/core/error/failures.dart';
import 'package:stayjogja_flutter/core/usecase/usecase.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/domain/repositories/hotel_repository.dart';

class GetHotelsParams extends Equatable {
  final String? area;
  final String? query;

  const GetHotelsParams({this.area, this.query});

  @override
  List<Object?> get props => [area, query];
}

class GetHotelsUseCase implements UseCase<List<Hotel>, GetHotelsParams> {
  final HotelRepository repository;

  GetHotelsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Hotel>>> call(GetHotelsParams params) async {
    return await repository.getHotels(area: params.area, query: params.query);
  }
}
