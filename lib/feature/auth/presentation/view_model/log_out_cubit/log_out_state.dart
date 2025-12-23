part of 'log_out_cubit.dart';

sealed class LogOutState extends Equatable {
  const LogOutState();

  @override
  List<Object> get props => [];
}


final class LogOutInitial extends LogOutState {}
final class LogOutLoading extends LogOutState {}
final class LogOutSuccess extends LogOutState {
  final LogOutModel successMessage;

  const LogOutSuccess({required this.successMessage});
   @override
  List<Object> get props => [successMessage];
}
final class LogOutFailure  extends LogOutState {
  final String errMessage;

  const LogOutFailure({required this.errMessage});
     @override
  List<Object> get props => [errMessage];
}
