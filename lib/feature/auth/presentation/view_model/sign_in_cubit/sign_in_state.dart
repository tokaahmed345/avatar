part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState extends Equatable {
  const SignInState();
   @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}
final class SignInSuccess extends SignInState {
  final SignInModel userData;

  SignInSuccess({required this.userData});
   @override
  List<Object> get props => [userData];
 }
final class SignInFailure extends SignInState {
  final String errorMessage;

  SignInFailure({required this.errorMessage});
   @override
  List<Object> get props => [errorMessage];
}
