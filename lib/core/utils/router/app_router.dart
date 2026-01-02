import 'package:avatar/core/utils/router/routes_name.dart';
import 'package:avatar/feature/auth/presentation/sign_in.dart';
import 'package:avatar/feature/home/presentation/home_view.dart';
import 'package:go_router/go_router.dart';


class AppRouter {
  final String initialRoute;
  late final GoRouter router;

  AppRouter(this.initialRoute) {
    router = GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(
          path: RoutesName.logIn,
          name: RoutesName.logIn,
          builder: (context, state) => const SignInView(),
        ),
        GoRoute(
          path: RoutesName.home,
          name: RoutesName.home,
          builder: (context, state) => const HomeView(),
        ),
      ],
    );
  }
}
