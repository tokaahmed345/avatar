import 'package:avatar/core/utils/constant/end_points.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/core/utils/service/api_service.dart';
import 'package:avatar/feature/session/data/models/start_session_model.dart';
import 'package:avatar/feature/session/data/repos/start_session_repos/start_session_repo.dart';
import 'package:dartz/dartz.dart';

class StartSessionRepoImpl implements StartSessionRepo {
  final ApiService apiService;
final SharedPrefs prefs;
  StartSessionRepoImpl({required this.apiService, required this.prefs});
  
  @override
  Future<Either<Failure, StartSession>> startSession() async{
  try {
   String  token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZTViMDdlMWI1ODc0ZGU5OGM3Y2YzOTdjOGU0ZTRlZiIsInNlc3Npb25faWQiOiJlOGU1OTAyMy00ZDFjLTQ3MDktOTFjMC0yNjI5ZTczYjUzMWUiLCJzb3VyY2UiOiJBUEkiLCJzdGFydF9zZXNzaW9uX2RhdGEiOnsibW9kZSI6IkNVU1RPTSIsImF2YXRhcl9pZCI6IjFjNjkwZmU3LTIzZTAtNDlmOS1iZmJhLTE0MzQ0NDUwMjg1YiIsImxpdmVraXRfY29uZmlnIjpudWxsfSwiZXhwIjoxNzY3NjI4OTg5fQ.4e-hO3Ttsn-pUkvF5WwNMlGFaIZVP9f-IZtTixS9QiE";

      final response = await apiService.post(
        EndPoints.startSession,
                headers: {"Authorization":"Bearer $token"},

      );

      print('Access: $token');

      print("session Info 👉 $response");

      final result = StartSession.fromJson(response);
final sessionId= prefs.saveSessionId(result.data!.sessionId ?? '');
print(sessionId);
      return right(result);
    } on Failure catch (e) {
      print("Failure: ${e.errMessage}");
      return left(ServerFailure(errMessage: e.errMessage));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  
  }
  
}