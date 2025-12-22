
import 'package:avatar/core/utils/router/routes_name.dart';
import 'package:avatar/feature/auth/presentation/sign_in.dart';
import 'package:avatar/feature/home/presentation/home_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    // redirect: (context, state) {
    //   final user = FirebaseAuth.instance.currentUser;
      
    //   if (user != null && state.name != RoutesName.home) {
    //     return RoutesName.home;
    //   }

    //   if (user == null && state.name == RoutesName.home) {
    //     return RoutesName.logIn;
    //   }

    //   return null;
    // },
    routes: [
          GoRoute(
        path: RoutesName.logIn,
        name: RoutesName.logIn,
        builder: (context, state) => const SignInView (),
      ),
      //     GoRoute(
      //   path: RoutesName.humanDetection,
      //   name: RoutesName.humanDetection,
      //   builder: (context, state) => const LivenessDetectionPage (),
      // ),
          GoRoute(
        path: RoutesName.home,
        name: RoutesName.home,
        builder: (context, state) => const HomeView (),
      ),
    ],
  );
}
