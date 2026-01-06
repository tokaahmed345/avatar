import 'package:avatar/feature/session/data/models/keep_session_alive.dart';
import 'package:avatar/feature/session/data/repos/keep_session_alive_repos/keep_session_alive_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'keep_session_alive_state.dart';

class KeepSessionAliveCubit extends Cubit<KeepSessionAliveState> {
  KeepSessionAliveCubit(this.keepSessionAliveRepo) : super(KeepSessionAliveInitial());
  final KeepSessionAliveRepo keepSessionAliveRepo;
      Future<void>keepSessionAlive({required String sessionId})async{
    emit(KeepSessionAliveLoading());
final data= await keepSessionAliveRepo.keepSessionAlive(sessionId: sessionId);
 data.fold((failure)=>emit(KeepSessionAliveFailure(errMessage: failure.errMessage)),(success)=>emit(KeepSessionAliveSuccess( keepSession:  success)) );
 
  } 
}
