import 'package:avatar/core/utils/constant/end_points.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/core/utils/service/api_service.dart';
import 'package:avatar/feature/auth/data/model/log_out_model.dart';
import 'package:avatar/feature/auth/data/repo/log_out/log_out_repo.dart';
import 'package:dartz/dartz.dart';

class LogOutRepoImpl implements LogOutRepo {
  final ApiService apiService;
  final SharedPrefs sharedPreferences;
  LogOutRepoImpl({required this.apiService, required this.sharedPreferences});

  @override
  Future<Either<Failure, LogOutModel>> logOut() async {
    try {
      final refresh = await sharedPreferences.getRefreshToken();

      final response = await apiService.post(
        EndPoints.logout,
        data: {"refresh": refresh},
      );

      final access = await sharedPreferences.getAccessToken();
      print('Access: $access');
      print('Refresh: $refresh');

      print("LOGIN RESPONSE 👉 $response");

      final result = LogOutModel.fromJson(response);
      await sharedPreferences.removeAccessToken();
      await sharedPreferences.removeRefreshToken();
      await sharedPreferences.saveIsLoggedIn(false);
      await sharedPreferences.removeAvatarPreviewUrl();
      await sharedPreferences.removeAvatarId();
      await sharedPreferences.removeContextId();

      return right(result);
    } on Failure catch (e) {
      print("Failure: ${e.errMessage}");
      return left(ServerFailure(errMessage: e.errMessage));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
