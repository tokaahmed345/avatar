import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/service/api_service.dart';
import 'package:avatar/core/utils/service/dio_consumer.dart';
import 'package:avatar/feature/auth/data/repo/log_out/log_out_repo.dart';
import 'package:avatar/feature/auth/data/repo/log_out/log_out_repo_impl.dart';
import 'package:avatar/feature/auth/data/repo/sign_in/sign_in_repo.dart';
import 'package:avatar/feature/auth/data/repo/sign_in/sign_in_repo_impl.dart';
import 'package:avatar/feature/auth/presentation/view_model/log_out_cubit/log_out_cubit.dart';
import 'package:avatar/feature/auth/presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:avatar/feature/chat/data/repos/message_repo.dart';
import 'package:avatar/feature/chat/data/repos/message_repo_impl.dart';
import 'package:avatar/feature/chat/presentation/view_model/cubit/message_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
Future<void> setUp() async {
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ApiService>(
      () => DioConsumer(dio: getIt<Dio>()));

  getIt.registerLazySingleton<SignInRepo>(
      () => SignInRepoImpl(apiService: getIt.get<ApiService>(),  sharedPreferences:getIt.get<SharedPrefs>(),));

  getIt.registerFactory<SignInCubit>(
      () => SignInCubit(getIt.get<SignInRepo>()));

  getIt.registerLazySingleton<SharedPrefs>(() => SharedPrefs());

  getIt.registerLazySingleton<LogOutRepo>(() => LogOutRepoImpl(apiService: getIt.get<ApiService>(), sharedPreferences: getIt.get<SharedPrefs>()));

  getIt.registerFactory<LogOutCubit>(
      () => LogOutCubit(getIt.get<LogOutRepo>()));
 getIt.registerLazySingleton<MessageRepo>(() => MessageRepoImpl(apiService: getIt.get<ApiService>(), sharedPreferences: getIt.get<SharedPrefs>()));

  getIt.registerFactory<MessageCubit>(
      () => MessageCubit(getIt.get<MessageRepo>()));
}
