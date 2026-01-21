import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'avatar_state.dart';
class AvatarCubit extends Cubit<String?> {
  AvatarCubit() : super(null);

  final SharedPrefs _prefs = getIt.get<SharedPrefs>();

  Future<void> loadAvatar() async {
    final url = await _prefs.getAvatarPreviewUrl();
    emit(url);
  }

  Future<void> clearAvatar() async {
    await _prefs.removeAvatarPreviewUrl();
    emit(null);
  }

  Future<void> saveAvatar(String url) async {
    await _prefs.saveAvatarPreviewUrl(url);
    emit(url);
  }
}

