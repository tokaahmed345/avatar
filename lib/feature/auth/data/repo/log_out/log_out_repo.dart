import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/feature/auth/data/model/log_out_model.dart';
import 'package:dartz/dartz.dart';

abstract class  LogOutRepo {
  Future<Either<Failure,LogOutModel>>logOut();
}
