import 'package:avatar/feature/session/data/models/start_session_model.dart';
import 'package:avatar/feature/session/data/repos/start_session_repos/start_session_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'start_session_state.dart';

class StartSessionCubit extends Cubit<StartSessionState> {
  StartSessionCubit(this.startSessionRepo) : super(StartSessionInitial());
  final StartSessionRepo startSessionRepo;
    Future<void>startSession()async{
    emit(StartSessionLoading());
final data= await startSessionRepo.startSession();
 data.fold((failure)=>emit(StartSessionFailure(errMessage: failure.errMessage)),(success)=>emit(StartSessionSuccess( startSession:  success)) );
 
  } 
}
