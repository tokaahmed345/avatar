import 'package:avatar/core/utils/assets/app_assets.dart';
import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/feature/chat/chat_view.dart';
import 'package:avatar/feature/home/presentation/widgets/glass_button.dart';
import 'package:avatar/feature/home/presentation/widgets/language_button.dart';
import 'package:flutter/material.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
    bool isChatOpen = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [

            Positioned.fill(
              child: Image.asset(
                AppAssets.homeBackground,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassIconButton(
                    icon: Icons.close,
                    onTap: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      LanguageButton(text: 'AR'),
                      const SizedBox(width: 12),
                      GlassIconButton(icon: Icons.volume_up),
                    ],
                  ),
                ],
              ),
            ),

          ChtaView(isChatOpen: isChatOpen, onClose: () { 
            setState(() {
              isChatOpen=false;
            });
           },),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: isChatOpen ? 280 : 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlassIconButton(icon: Icons.mic),
                  const SizedBox(width: 24),

                  Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primary.withOpacity(.6),
                    ),
                    child: const Icon(
                      Icons.multitrack_audio,
                      size: 40,
                      color: AppColors.whiteColor,
                    ),
                  ),

                  const SizedBox(width: 24),

             GlassIconButton     (
                    icon: Icons.chat,
                      isActive: isChatOpen,

                    onTap: () {
                      setState(() {
                        isChatOpen = !isChatOpen;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}