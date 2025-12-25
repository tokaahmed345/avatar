import 'package:avatar/core/utils/constant/end_points.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/core/utils/service/api_service.dart';
import 'package:avatar/feature/chat/data/models/message_model.dart';
import 'package:avatar/feature/chat/data/repos/message_repo.dart';
import 'package:dartz/dartz.dart';

class MessageRepoImpl implements MessageRepo {
  final ApiService apiService;
  final SharedPrefs sharedPreferences;
  MessageRepoImpl({required this.apiService, required this.sharedPreferences});

  @override
  Future<Either<Failure, MessageModel>> getMessage({required String businessId,required String question,required String language}) async {
    try {
      final access = await sharedPreferences.getAccessToken();

      final response = await apiService.post(
        EndPoints.message,
        data: {"business_id":businessId,"question":question,"language":language },
                headers: {"token":access},

      );

      print('Access: $access');

      print("LOGIN RESPONSE 👉 $response");

      final result = MessageModel.fromJson(response);

      return right(result);
    } on Failure catch (e) {
      print("Failure: ${e.errMessage}");
      return left(ServerFailure(errMessage: e.errMessage));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
