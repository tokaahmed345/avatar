import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:avatar/feature/home/presentation/view_model/cubit/voice_text_cubit.dart';
import 'package:avatar/feature/home/presentation/widgets/home_view_body.dart';
import 'package:avatar/feature/session/presentation/view_model/start_session_cubit/start_session_cubit.dart';
import 'package:avatar/feature/session/presentation/view_model/stop_session_cubit/stop_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt.get<VoiceTextCubit>()),
              BlocProvider(create: (context) => getIt.get<StartSessionCubit>()),
               BlocProvider(create: (context) => getIt.get<StopSessionCubit>()),

            ],
            child: HomeViewBody(),
          ),
        ),
      ),
    );
  }
}
