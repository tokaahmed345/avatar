import 'package:avatar/feature/home/data/models/voice_text_model.dart';
import 'package:avatar/feature/home/data/repos/voice_text_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'voice_text_state.dart';

class VoiceTextCubit extends Cubit<VoiceTextState> {
  VoiceTextCubit(this.voiceTextRepo) : super(VoiceTextInitial());
     final VoiceTextRepo voiceTextRepo;
  Future<void>sendVoiceText({required String businessId,required String avatartId,required String language,required int userId,required String contextId})async{
    emit(VoiceTextLoading());
final data= await voiceTextRepo.voiceText(businessId: businessId, avatartId: avatartId, language: language, userId: userId,contextId: contextId);
 data.fold((failure)=>emit(VoiceTextFailure(errorMessage: failure.errMessage)),(success)=>emit(VoiceTextSuccess( voiceText: success)) );
 
  } 
}
