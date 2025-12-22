import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:avatar/feature/auth/presentation/view_model/cubit/sign_in_cubit.dart';
import 'package:avatar/feature/auth/presentation/widgets/sign_in_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<SignInCubit>(),
      child: Scaffold(body: SignInViewBody()),
    );
  }
}
