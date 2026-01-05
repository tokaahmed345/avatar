
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/feature/session/data/models/stop_session_model.dart';
import 'package:dartz/dartz.dart';

abstract class  StopSessionRepo {
  Future<Either<Failure,StopSessionModel>>stopSession({required  String sessionId});
}
