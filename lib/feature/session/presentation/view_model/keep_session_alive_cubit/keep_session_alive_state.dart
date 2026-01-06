part of 'keep_session_alive_cubit.dart';

sealed class KeepSessionAliveState extends Equatable {
  const KeepSessionAliveState();

  @override
  List<Object> get props => [];
}

final class KeepSessionAliveInitial extends KeepSessionAliveState {}
final class KeepSessionAliveLoading extends KeepSessionAliveState {}
final class KeepSessionAliveSuccess extends KeepSessionAliveState 
{
  final KeepSessionAliveModel keepSession;

  const KeepSessionAliveSuccess({required this.keepSession});
      @override
  List<Object> get props => [keepSession];
}
final class KeepSessionAliveFailure extends KeepSessionAliveState {
  final String errMessage;

  const KeepSessionAliveFailure({required this.errMessage});
    @override
  List<Object> get props => [errMessage];
}
