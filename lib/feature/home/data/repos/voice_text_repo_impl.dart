import 'package:avatar/core/utils/constant/end_points.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/core/utils/service/api_service.dart';
import 'package:avatar/feature/home/data/models/voice_text_model.dart';
import 'package:avatar/feature/home/data/repos/voice_text_repo.dart';
import 'package:dartz/dartz.dart';

class VoiceTextRepoImpl implements VoiceTextRepo {
  final ApiService apiService;
  final SharedPrefs sharedPreferences;
  VoiceTextRepoImpl({required this.apiService, required this.sharedPreferences});
  
  @override
  Future<Either<Failure, VoiceTextModel>> voiceText({required String businessId, required String message, required String language, required String userId}) async{
try {
      final access = await sharedPreferences.getAccessToken();

      final response = await apiService.post(
        EndPoints.voiceMessage,
        data: {"business_id":businessId,"message":message,"language":language,"user_id":userId },
                headers: {"token":access},

      );

      print('Access: $access');

      print("LOGIN RESPONSE 👉 $response");

      final result = VoiceTextModel.fromJson(response);

      return right(result);
    } on Failure catch (e) {
      print("Failure: ${e.errMessage}");
      return left(ServerFailure(errMessage: e.errMessage));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
  }


