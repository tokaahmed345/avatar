import 'package:avatar/core/utils/constant/end_points.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/core/utils/service/api_service.dart';
import 'package:avatar/feature/session/data/models/stop_session_model.dart';
import 'package:avatar/feature/session/data/repos/stop_session_repos/stop_session_repo.dart';
import 'package:dartz/dartz.dart';

class StopSessionRepoImpl implements StopSessionRepo {
  final ApiService apiService;
final SharedPrefs prefs;
  StopSessionRepoImpl({required this.apiService, required this.prefs});
  @override
  Future<Either<Failure, StopSessionModel>> stopSession({required String sessionId})async {

 try {
   String  token =await prefs.getSessionToken() ;
   sessionId=  await prefs.getSessionId();
      final response = await apiService.post(
        EndPoints.stopSession,
        data: {
          "session_id":sessionId

        },
        headers: {"Authorization":"Bearer $token"},

      );
print(sessionId);

      print('Access: $token');

      print("session result 👉 $response");
      print("session id 👉 $sessionId");

      final result = StopSessionModel.fromJson(response);
      return right(result);
    } on Failure catch (e) {
      print("Failure: ${e.errMessage}");
      return left(ServerFailure(errMessage: e.errMessage));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  
 
  }

}