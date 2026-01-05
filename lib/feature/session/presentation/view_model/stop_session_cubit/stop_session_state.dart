part of 'stop_session_cubit.dart';

sealed class StopSessionState extends Equatable {
  const StopSessionState();

  @override
  List<Object> get props => [];
}

final class StopSessionInitial extends StopSessionState {}
final class StopSessionLoading extends StopSessionState {}
final class StopSessionSuccess extends StopSessionState {
  final StopSessionModel stopSession;

  const StopSessionSuccess({required this.stopSession});
  
  @override
  List<Object> get props => [stopSession];
}
final class StopSessionFailure extends StopSessionState {
  final  String errMessage;

  const StopSessionFailure({required this.errMessage});
  
  @override
  List<Object> get props => [errMessage];
}
