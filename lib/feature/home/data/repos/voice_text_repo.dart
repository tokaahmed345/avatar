
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/feature/home/data/models/voice_text_model.dart';
import 'package:dartz/dartz.dart';

abstract class  VoiceTextRepo {
  Future<Either<Failure,VoiceTextModel>>voiceText({required String businessId,required String avatartId,required String language,required int userId,required String contextId, required String voiceId});
}
