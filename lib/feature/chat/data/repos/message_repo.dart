
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/feature/chat/data/models/message_model.dart';
import 'package:dartz/dartz.dart';

abstract class  MessageRepo {
  Future<Either<Failure,MessageModel>>getMessage({required String businessId,required String question,required String language});
}
