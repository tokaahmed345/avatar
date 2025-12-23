import 'package:avatar/core/utils/failure/failure.dart';
import 'package:avatar/feature/auth/data/model/sign_in_model.dart';
import 'package:dartz/dartz.dart';

abstract class  SignInRepo {
  Future<Either<Failure,SignInModel>>signIn({required String email,required String password });
}
