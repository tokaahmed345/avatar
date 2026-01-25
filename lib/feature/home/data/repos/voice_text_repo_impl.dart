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
  Future<Either<Failure, VoiceTextModel>> voiceText({required String businessId, required String avatartId, required String language, required int userId,required String contextId,required String voiceId}) async{
try {
      final access = await sharedPreferences.getAccessToken();
 

      final response = await apiService.post(
        EndPoints.voiceMessage,
        data: {"business_id":businessId,"avatar_id":avatartId,"language":language,"admin_id":userId,"context_id": contextId,"voice_id":voiceId},
                headers: {"token":access},

      );
      print("avatar 👉 $avatartId");
      print(" context 👉 $contextId");

      print('Access: $access');
print("VoiceText Response 👉 $response");


      final result = VoiceTextModel.fromJson(response);
      
   await sharedPreferences.saveSessionId(
  result.sessionId!.toString(),
);
   await sharedPreferences.saveSessionToken(
  result.sessionToken!.toString(),
);


      return right(result);
    } on Failure catch (e) {
      print("Failure: ${e.errMessage}");
      return left(ServerFailure(errMessage: e.errMessage));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
  }


