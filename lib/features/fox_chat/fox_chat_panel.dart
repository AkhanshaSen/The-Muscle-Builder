import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import 'fox_chat_assistant.dart';
import 'fox_chat_message.dart';
import 'fox_chat_providers.dart';
import 'fox_chat_quick_topics.dart';

/// Compact frosted chat bubble above the mascot (AI Meow–style).
class FoxChatPanel extends ConsumerStatefulWidget {
  const FoxChatPanel({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  ConsumerState<FoxChatPanel> createState() => _FoxChatPanelState();
}

class _FoxChatPanelState extends ConsumerState<FoxChatPanel> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  var _sending = false;
  var _typing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(foxChatProvider.notifier).ensureWelcome();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _scrollToEnd() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    if (!_scroll.hasClients) return;
    await _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _sending) return;
    setState(() {
      _sending = true;
      _typing = true;
    });
    _controller.clear();
    await ref.read(foxChatProvider.notifier).send(trimmed);
    if (mounted) {
      setState(() {
        _typing = false;
        _sending = false;
      });
    }
    await _scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(foxChatProvider);
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;

    ref.listen(foxChatProvider, (prev, next) {
      if ((prev?.length ?? 0) < next.length) _scrollToEnd();
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        // Parent Column(end) can pass unbounded width — cap like AI Meow (~220px).
        final panelW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 280.0;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) {
            return Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, (1 - t) * 10),
                child: Transform.scale(
                  scale: 0.96 + 0.04 * t,
                  alignment: Alignment.bottomCenter,
                  child: child,
                ),
              ),
            );
          },
          child: SizedBox(
            width: panelW,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.92),
                    border: Border.all(
                      color: accent.withValues(alpha: 0.45),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(onClose: widget.onClose),
                        SizedBox(
                          height: 148,
                          child: ListView.builder(
                            controller: _scroll,
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                            itemCount:
                                messages.length + (_typing ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (_typing && index == messages.length) {
                                return const _TypingBubble();
                              }
                              return _CompactBubble(
                                message: messages[index],
                                maxBubbleWidth: panelW * 0.88,
                              );
                            },
                          ),
                        ),
                        _QuickActions(onPick: _send),
                        _InputRow(
                          controller: _controller,
                          sending: _sending,
                          onSend: () => _send(_controller.text),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: scheme.primary.withValues(alpha: 0.25)),
        ),
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
      ),
      child: Row(
        children: [
          Text('🦊', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Fox chat',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Material(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.9),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onClose,
              child: SizedBox(
                width: 28,
                height: 28,
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: foxQuickTopics.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final topic = foxQuickTopics[index];
          return _QuickChip(
            label: topic.label,
            color: scheme,
            onTap: () => onPick(topic.prompt),
          );
        },
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final ColorScheme color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.surfaceContainerHighest.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: Text(
            label,
            maxLines: 1,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color.primary,
                ),
          ),
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: scheme.primary.withValues(alpha: 0.2)),
        ),
        color: scheme.surface.withValues(alpha: 0.45),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              enableInteractiveSelection: false,
              style: Theme.of(context).textTheme.bodySmall,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              contextMenuBuilder: (context, editableTextState) =>
                  const SizedBox.shrink(),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Ask about ${AppConstants.appName}…',
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                filled: true,
                fillColor: scheme.surface.withValues(alpha: 0.75),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: scheme.primary.withValues(alpha: 0.45),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: scheme.primary.withValues(alpha: 0.35),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: scheme.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Material(
            color: scheme.primary,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: sending ? null : onSend,
              child: SizedBox(
                width: 34,
                height: 34,
                child: Center(
                  child: sending
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.onPrimary,
                          ),
                        )
                      : Icon(Icons.arrow_upward_rounded,
                          size: 18, color: scheme.onPrimary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactBubble extends StatelessWidget {
  const _CompactBubble({
    required this.message,
    required this.maxBubbleWidth,
  });

  final FoxChatMessage message;
  final double maxBubbleWidth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBubbleWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isUser
                  ? scheme.primary.withValues(alpha: 0.92)
                  : scheme.primaryContainer.withValues(alpha: 0.85),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: Radius.circular(isUser ? 10 : 3),
                bottomRight: Radius.circular(isUser ? 3 : 10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: _MessageBody(
                text: message.text,
                isUser: isUser,
                color: isUser ? scheme.onPrimary : scheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBody extends StatelessWidget {
  const _MessageBody({
    required this.text,
    required this.isUser,
    required this.color,
  });

  final String text;
  final bool isUser;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          height: 1.4,
          color: color,
        );

    if (!isUser && text.startsWith(FoxChatAssistant.listPrefix)) {
      final items = text
          .substring(FoxChatAssistant.listPrefix.length)
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: style),
                  Expanded(child: Text(items[i], style: style)),
                ],
              ),
            ),
        ],
      );
    }

    return Text(text, style: style);
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.primaryContainer.withValues(alpha: 0.65),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              '…',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: scheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
