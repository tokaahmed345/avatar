import 'package:avatar/core/utils/router/app_router.dart';
import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:flutter/material.dart';

void main() {
      setUp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
          debugShowCheckedModeBanner: false,
routerConfig: AppRouter.router,
 
      
    );
  }
}
