import 'package:avatar/feature/chat/data/models/message_model.dart';
import 'package:avatar/feature/chat/data/repos/message_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit(this.messageRepo) : super(MessageInitial());
   final MessageRepo messageRepo;
  Future<void>fetchMessage({required String businessId,required String question,required String language})async{
    emit(MessageLoading());
final data= await messageRepo.getMessage(businessId: businessId, question: question, language: language);
 data.fold((failure)=>emit(MessageFailure(errMessage: failure.errMessage)),(success)=>emit(MessageSuccess( messages: success)) );
 
  } 
}
