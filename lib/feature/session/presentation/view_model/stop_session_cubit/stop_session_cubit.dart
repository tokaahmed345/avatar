import 'package:avatar/feature/session/data/models/stop_session_model.dart';
import 'package:avatar/feature/session/data/repos/stop_session_repos/stop_session_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stop_session_state.dart';

class StopSessionCubit extends Cubit<StopSessionState> {
  StopSessionCubit(this.stopSessionRepo) : super(StopSessionInitial());
  final StopSessionRepo stopSessionRepo;
  Future<void>stopSession({required String sessionId})async{
    emit(StopSessionLoading());
final data= await stopSessionRepo.stopSession(sessionId: sessionId);
 data.fold((failure)=>emit(StopSessionFailure(errMessage: failure.errMessage)),(success)=>emit(StopSessionSuccess( stopSession:  success)) );
 
  } 
}
