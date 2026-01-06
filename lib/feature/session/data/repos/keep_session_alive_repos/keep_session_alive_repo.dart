
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/feature/session/data/models/keep_session_alive.dart';
import 'package:dartz/dartz.dart';

abstract class  KeepSessionAliveRepo {
  Future<Either<Failure,KeepSessionAliveModel>>keepSessionAlive({required String sessionId});
}
