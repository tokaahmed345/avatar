part of 'voice_text_cubit.dart';

sealed class VoiceTextState extends Equatable {
  const VoiceTextState();

  @override
  List<Object> get props => [];
}

final class VoiceTextInitial extends VoiceTextState {}
final class VoiceTextLoading extends VoiceTextState {}
final class VoiceTextSuccess extends VoiceTextState {
  final VoiceTextModel voiceText;

  const VoiceTextSuccess({required this.voiceText});
  @override
  List<Object> get props => [voiceText];
}
final class VoiceTextFailure extends VoiceTextState {
  final String errorMessage;

  const VoiceTextFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
