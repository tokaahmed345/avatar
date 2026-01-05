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
   String  token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZTViMDdlMWI1ODc0ZGU5OGM3Y2YzOTdjOGU0ZTRlZiIsInNlc3Npb25faWQiOiJlOGU1OTAyMy00ZDFjLTQ3MDktOTFjMC0yNjI5ZTczYjUzMWUiLCJzb3VyY2UiOiJBUEkiLCJzdGFydF9zZXNzaW9uX2RhdGEiOnsibW9kZSI6IkNVU1RPTSIsImF2YXRhcl9pZCI6IjFjNjkwZmU3LTIzZTAtNDlmOS1iZmJhLTE0MzQ0NDUwMjg1YiIsImxpdmVraXRfY29uZmlnIjpudWxsfSwiZXhwIjoxNzY3NjI4OTg5fQ.4e-hO3Ttsn-pUkvF5WwNMlGFaIZVP9f-IZtTixS9QiE";
sessionId=  await prefs.getSessionId();
      final response = await apiService.post(
        EndPoints.stopSession,
        data: {
          "session_id":sessionId

        },
        headers: {"Authorization":"Bearer $token"},

      );

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