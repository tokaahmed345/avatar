import 'package:avatar/core/utils/service/api_service.dart';
import 'package:avatar/core/utils/service/dio_consumer.dart';
import 'package:avatar/feature/auth/data/repo/sign_in_repo.dart';
import 'package:avatar/feature/auth/data/repo/sign_in_repo_impl.dart';
import 'package:avatar/feature/auth/presentation/view_model/cubit/sign_in_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ApiService>(
      () => DioConsumer(dio: getIt<Dio>()));

  getIt.registerLazySingleton<SignInRepo>(
      () => SignInRepoImpl(apiService: getIt.get<ApiService>()));

  getIt.registerFactory<SignInCubit>(
      () => SignInCubit(getIt.get<SignInRepo>()));
}
