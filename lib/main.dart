import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/router/app_router.dart';
import 'package:avatar/core/utils/router/routes_name.dart';
import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();

  final sharedPrefs = getIt.get<SharedPrefs>();
  final bool loggedIn = await sharedPrefs.isLoggedIn(); 

  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    final initialRoute = loggedIn ? RoutesName.home : RoutesName.logIn;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter(initialRoute).router,
    );
  }
}
