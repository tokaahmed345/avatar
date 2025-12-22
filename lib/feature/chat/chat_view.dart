
import 'package:avatar/feature/chat/presentation/widgets/chat_view_body.dart';
import 'package:flutter/material.dart';

class ChtaView extends StatelessWidget {
  const ChtaView({super.key, required this.isChatOpen, required this.onClose,});
  final bool isChatOpen;
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) {
    return  ChatViewBody(isChatOpen: isChatOpen, onClose: onClose);

}
}



