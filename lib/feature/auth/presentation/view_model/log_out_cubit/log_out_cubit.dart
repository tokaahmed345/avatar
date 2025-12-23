import 'package:avatar/feature/auth/data/model/log_out_model.dart';
import 'package:avatar/feature/auth/data/repo/log_out/log_out_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit(this.logOutRepo) : super(LogOutInitial());
  final LogOutRepo logOutRepo;
   Future<void>logOut()async{
    emit(LogOutLoading());
final data= await logOutRepo.logOut();
 data.fold((failure)=>emit(LogOutFailure(errMessage:  failure.errMessage)),(success)=>emit(LogOutSuccess( successMessage: success)) );
 
  }
}
