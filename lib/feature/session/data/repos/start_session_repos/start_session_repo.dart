
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/feature/session/data/models/start_session_model.dart';
import 'package:dartz/dartz.dart';

abstract class  StartSessionRepo {
  Future<Either<Failure,StartSession>>startSession();
}
