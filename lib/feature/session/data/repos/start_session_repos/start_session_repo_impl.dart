import 'package:avatar/core/utils/constant/end_points.dart';
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/core/utils/service/api_service.dart';
import 'package:avatar/feature/session/data/models/start_session_model.dart';
import 'package:avatar/feature/session/data/repos/start_session_repos/start_session_repo.dart';
import 'package:dartz/dartz.dart';

class StartSessionRepoImpl implements StartSessionRepo {
  final ApiService apiService;

  StartSessionRepoImpl({required this.apiService});
  
  @override
  Future<Either<Failure, StartSession>> startSession() async{
  try {
   String  token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjY2Y4MTdhOGRmZTk0ZjllYWE0OTI0OTdmMTI2YWU5MSIsInNlc3Npb25faWQiOiJjMzZiOTA1Mi1lZWQwLTQ4YzEtYThlOC04NDc3ZDI3NmQ3MWEiLCJzb3VyY2UiOiJBUEkiLCJzdGFydF9zZXNzaW9uX2RhdGEiOnsibW9kZSI6IkNVU1RPTSIsImF2YXRhcl9pZCI6IjFjNjkwZmU3LTIzZTAtNDlmOS1iZmJhLTE0MzQ0NDUwMjg1YiIsImxpdmVraXRfY29uZmlnIjpudWxsfSwiZXhwIjoxNzY3NTUxMjMwfQ.qroPaPEf1KMeaSypfDLrErN7psZhf7wwUffHmxJGAa4";

      final response = await apiService.post(
        EndPoints.startSession,
                headers: {"Authorization":"Bearer $token"},

      );

      print('Access: $token');

      print("session Info 👉 $response");

      final result = StartSession.fromJson(response);

      return right(result);
    } on Failure catch (e) {
      print("Failure: ${e.errMessage}");
      return left(ServerFailure(errMessage: e.errMessage));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  
  }
  
}