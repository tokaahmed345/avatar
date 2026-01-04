part of 'start_session_cubit.dart';

sealed class StartSessionState extends Equatable {
  const StartSessionState();

  @override
  List<Object> get props => [];
}

final class StartSessionInitial extends StartSessionState {}
final class StartSessionLoading extends StartSessionState {}
final class StartSessionSuccess extends StartSessionState {
  final StartSession startSession;

  const StartSessionSuccess({required this.startSession});
  @override
  List<Object> get props => [startSession];
}
final class StartSessionFailure extends StartSessionState {
  final String errMessage;

  const StartSessionFailure({required this.errMessage});
    @override
  List<Object> get props => [errMessage];
  
  }
