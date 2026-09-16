import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'fox_chat_panel.dart';

/// Full-screen fallback if routed directly (mascot uses [FoxChatPanel] inline).
class FoxChatScreen extends StatelessWidget {
  const FoxChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FoxChatPanel(onClose: () => context.pop()),
          ),
        ),
      ),
    );
  }
}
