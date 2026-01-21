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

   String  token =await prefs.getSessionToken() ;

      final response = await apiService.post(
        EndPoints.startSession,
                headers: {"Authorization":"Bearer $token"},

      );

      print('Access: $token');

      print("session Info 👉 $response");

      final result = StartSession.fromJson(response);
// final sessionId= prefs.saveSessionId(result.data!.sessionId ?? '');
// print(sessionId);
      return right(result);
    } on Failure catch (e) {
      print("Failure: ${e.errMessage}");
      return left(ServerFailure(errMessage: e.errMessage));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  
  }
  
}