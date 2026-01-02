import 'package:avatar/feature/home/data/models/voice_text_model.dart';
import 'package:avatar/feature/home/data/repos/voice_text_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'voice_text_state.dart';

class VoiceTextCubit extends Cubit<VoiceTextState> {
  VoiceTextCubit(this.voiceTextRepo) : super(VoiceTextInitial());
     final VoiceTextRepo voiceTextRepo;
  Future<void>sendVoiceText({required String businessId,required String message,required String language,required String userId})async{
    emit(VoiceTextLoading());
final data= await voiceTextRepo.voiceText(businessId: businessId, message: message, language: language, userId: userId);
 data.fold((failure)=>emit(VoiceTextFailure(errorMessage: failure.errMessage)),(success)=>emit(VoiceTextSuccess( voiceText: success)) );
 
  } 
}
