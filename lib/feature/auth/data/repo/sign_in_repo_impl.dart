import 'package:avatar/core/utils/constant/end_points.dart';
import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/core/utils/service/api_service.dart';
import 'package:avatar/feature/auth/data/model/sign_in_model.dart';
import 'package:avatar/feature/auth/data/repo/sign_in_repo.dart';
import 'package:dartz/dartz.dart';

class SignInRepoImpl implements SignInRepo{
  final ApiService apiService;

  SignInRepoImpl({required this.apiService});
  @override
  Future<Either<Failure, SignInModel>> signIn({required String email, required String password})async {
  try {
  final data=  await apiService.post(EndPoints.signIn, data: {
    email:email,
    password:password
  });
final result =   SignInModel.fromJson(data);
return right(result);
} on Failure catch (e) {
return left(ServerFailure(errMessage:e.errMessage));
}catch(e){
  return left(ServerFailure(errMessage:e.toString()));

}
  
  }
}