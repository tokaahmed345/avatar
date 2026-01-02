import 'package:avatar/feature/auth/data/model/sign_in_model.dart';
import 'package:avatar/feature/auth/data/repo/sign_in/sign_in_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.signInRepo) : super(SignInInitial());
  final SignInRepo signInRepo;
  Future<void>signIn({required String email,required String password})async{
    emit(SignInLoading());
final data= await signInRepo.signIn(email: email, password: password);
 data.fold((failure)=>emit(SignInFailure(errorMessage: failure.errMessage)),(success)=>emit(SignInSuccess( userData: success)) );
 
  }
}
