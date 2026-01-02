import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:avatar/feature/chat/presentation/view_model/cubit/message_cubit.dart';
import 'package:avatar/feature/chat/presentation/widgets/chat_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChtaView extends StatelessWidget {
  const ChtaView({
    super.key,
    required this.isChatOpen,
    required this.onClose,
    required this.selectedLanguage,
  });
  final bool isChatOpen;
  final VoidCallback onClose;
  final String selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt.get<MessageCubit>(),
     
      child: ChatViewBody(
        isChatOpen: isChatOpen,
        onClose: onClose,
        selectedLanguage: selectedLanguage,
      ),
    );
  }
}
