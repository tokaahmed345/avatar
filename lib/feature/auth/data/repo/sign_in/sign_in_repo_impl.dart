import 'package:avatar/core/utils/constant/end_points.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/core/utils/service/api_service.dart';
import 'package:avatar/feature/auth/data/model/sign_in_model.dart';
import 'package:avatar/feature/auth/data/repo/sign_in/sign_in_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInRepoImpl implements SignInRepo {
  final ApiService apiService;
final SharedPrefs sharedPreferences;
  SignInRepoImpl({required this.apiService, required this.sharedPreferences, });

  @override
  Future<Either<Failure, SignInModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        EndPoints.signIn,
        data: {
          "email": email,
          "password": password,
        },
      );

  await sharedPreferences.saveAccessToken(response['access']);
      await sharedPreferences.saveRefreshToken(response['refresh']);
final access = await sharedPreferences.getAccessToken();
final refresh = await sharedPreferences.getRefreshToken();

print('Access: $access');
print('Refresh: $refresh');

print("LOGIN RESPONSE 👉 $response");



      final result = SignInModel.fromJson(response);
      await sharedPreferences.saveBusinessId(
  result.admin!.business.toString(),
);
   await sharedPreferences.saveUserId(
  result.admin!.id.toString(),
);
//    await sharedPreferences.saveAvatarId(
//   result.avatarconfig!.avatar_id.toString(),
// );
//    await sharedPreferences.saveContextId(
//   result.avatarconfig!.context_id.toString(),

// );

final avatarId = result.avatarconfig!.avatar_id;
final contextId = result.avatarconfig!.context_id;

print("AvatarId from API 👉 $avatarId");
print("ContextId from API 👉 $contextId");

if (avatarId != null && contextId != null) {
  await sharedPreferences.saveAvatarId(avatarId);
  await sharedPreferences.saveContextId(contextId);
}


      return right(result);
    } on Failure catch (e) {
      print("Failure: ${e.errMessage}");
      return left(ServerFailure(errMessage: e.errMessage));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
