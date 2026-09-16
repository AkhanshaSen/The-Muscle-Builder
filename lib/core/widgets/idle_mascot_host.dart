import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../logging/app_log.dart';
import '../../features/fox_chat/fox_chat_panel.dart';

/// Idle fox overlay — opt-in via Settings; tap fox for chat, × to turn off.
class IdleMascotHost extends ConsumerStatefulWidget {
  const IdleMascotHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<IdleMascotHost> createState() => _IdleMascotHostState();
}

class _IdleMascotHostState extends ConsumerState<IdleMascotHost> {
  static const _idle = Duration(seconds: 10);
  static const _clipHold = Duration(seconds: 20);
  static const _clipAssets = [
    'assets/mascot/idle_fox.webp',
    // GIF — Android Skia often fails on our animated WebP skip clip.
    'assets/mascot/ski_fox.gif',
  ];

  Timer? _idleTimer;
  Timer? _clipCycleTimer;
  var _visible = false;
  var _chatOpen = false;
  /// Owned here so chat open/close never resets the clip via child remounts.
  var _clipIndex = 0;
  String _lastMascotLog = '';

  void _logMascotState(String reason) {
    final enabled = ref.read(idleMascotEnabledProvider);
    final snap =
        'enabled=$enabled visible=$_visible chat=$_chatOpen clip=${_clipAssets[_clipIndex]}';
    if (snap == _lastMascotLog) return;
    _lastMascotLog = snap;
    AppLog.info('Mascot', reason, {
      'enabled': enabled,
      'foxVisible': _visible,
      'chatOpen': _chatOpen,
      'clip': _clipAssets[_clipIndex],
    });
    AppLog.visibility(
      'Fox mascot overlay',
      visible: enabled && _visible,
      details: {'chatOpen': _chatOpen},
    );
    AppLog.visibility(
      'Fox chat panel',
      visible: enabled && _visible && _chatOpen,
    );
  }

  @override
  void initState() {
    super.initState();
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncWithSettings());
  }

  void _syncWithSettings() {
    if (!mounted) return;
    if (!ref.read(idleMascotEnabledProvider)) return;
    if (_visible) {
      if (!_chatOpen) _armClipCycle();
      return;
    }
    setState(() => _visible = true);
    _armClipCycle();
    _logMascotState('Synced with settings — showing fox');
  }

  @override
  void reassemble() {
    super.reassemble();
    // Hot reload: drop stale timers and re-arm clip cycle if the fox is out.
    _pauseClipCycle();
    if (_visible && !_chatOpen && ref.read(idleMascotEnabledProvider)) {
      _armClipCycle();
    }
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
    _idleTimer?.cancel();
    _clipCycleTimer?.cancel();
    super.dispose();
  }

  void _onPointer(PointerEvent event) {
    if (event is! PointerDownEvent) return;
    if (!ref.read(idleMascotEnabledProvider)) return;
    if (_visible) return;
    _armIdle();
  }

  void _armIdle() {
    _idleTimer?.cancel();
    if (!ref.read(idleMascotEnabledProvider)) return;
    if (_visible) return;
    _idleTimer = Timer(_idle, () {
      if (!mounted) return;
      if (!ref.read(idleMascotEnabledProvider)) return;
      setState(() => _visible = true);
      _armClipCycle();
    });
  }

  void _armClipCycle() {
    _clipCycleTimer?.cancel();
    if (!_visible || _chatOpen) return;
    _clipCycleTimer = Timer.periodic(_clipHold, (_) {
      if (!mounted || _chatOpen || !_visible) return;
      setState(() => _clipIndex = (_clipIndex + 1) % _clipAssets.length);
      _logMascotState('Clip rotated');
    });
  }

  void _pauseClipCycle() {
    _clipCycleTimer?.cancel();
    _clipCycleTimer = null;
  }

  void _onFoxTap() {
    AppLog.tap(
      _chatOpen ? 'Fox (close chat)' : 'Fox (open chat)',
      details: {'clip': _clipAssets[_clipIndex]},
    );
    _pauseClipCycle();
    setState(() => _chatOpen = !_chatOpen);
    if (!_chatOpen) _armClipCycle();
    _logMascotState(_chatOpen ? 'Chat opened' : 'Chat closed');
  }

  void _closeFoxChat() {
    if (!_chatOpen) return;
    AppLog.tap('Fox chat backdrop / close');
    _pauseClipCycle();
    setState(() => _chatOpen = false);
    _armClipCycle();
    _logMascotState('Chat closed');
  }

  Future<void> _dismissFox() async {
    AppLog.tap('Fox dismiss (×)');
    _idleTimer?.cancel();
    _pauseClipCycle();
    setState(() {
      _visible = false;
      _chatOpen = false;
      _clipIndex = 0;
    });
    await ref.read(idleMascotEnabledProvider.notifier).setEnabled(false);
    _logMascotState('Fox dismissed and setting turned off');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(idleMascotEnabledProvider, (prev, next) {
      if (next) {
        AppLog.success('Mascot', 'Setting turned ON');
        setState(() {
          _visible = true;
          if (prev == false) _clipIndex = 0;
        });
        _idleTimer?.cancel();
        _armClipCycle();
        _logMascotState('Enabled in settings');
      } else {
        AppLog.info('Mascot', 'Setting turned OFF');
        _idleTimer?.cancel();
        _pauseClipCycle();
        setState(() {
          _visible = false;
          _chatOpen = false;
          _clipIndex = 0;
        });
        _logMascotState('Disabled in settings');
      }
    });

    final enabled = ref.watch(idleMascotEnabledProvider);
    if (!enabled) {
      return widget.child;
    }

    final bottom = MediaQuery.paddingOf(context).bottom + 72;
    final screenW = MediaQuery.sizeOf(context).width;
    final chatWidth = 280.0.clamp(200.0, screenW - 24);
    final clipAsset = _clipAssets[_clipIndex];

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_visible && _chatOpen)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeFoxChat,
              child: const ColoredBox(color: Color(0x18000000)),
            ),
          ),
        if (_visible && _chatOpen)
          Positioned(
            right: 10,
            bottom: bottom + 72 + 6,
            width: chatWidth,
            child: FoxChatPanel(onClose: _closeFoxChat),
          ),
        if (_visible)
          Positioned(
            right: 10,
            bottom: bottom,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _onFoxTap,
                  child: SizedBox(
                    width: 108,
                    height: 72,
                    child: _FoxClipImage(
                      key: ValueKey<String>(clipAsset),
                      asset: clipAsset,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: -4,
                  child: _FoxDismissButton(onDismiss: _dismissFox),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Small × beside the fox (AI Meow–style) — turns mascot off in Settings.
class _FoxDismissButton extends StatelessWidget {
  const _FoxDismissButton({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 2,
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.92),
      shape: CircleBorder(
        side: BorderSide(
          color: scheme.outline.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onDismiss,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: SizedBox(
            width: 14,
            height: 14,
            child: Icon(
              Icons.close_rounded,
              size: 10,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.9),
            ),
          ),
        ),
      ),
    );
  }
}

/// Keeps the [Image] element alive across unrelated parent rebuilds (chat open).
class _FoxClipImage extends StatefulWidget {
  const _FoxClipImage({super.key, required this.asset});

  final String asset;

  @override
  State<_FoxClipImage> createState() => _FoxClipImageState();
}

class _FoxClipImageState extends State<_FoxClipImage> {
  static const _skiAsset = 'assets/mascot/ski_fox.gif';
  static const _boxW = 108.0;
  static const _boxH = 72.0;
  static const _skiDrawW = 122.0;
  static const _skiDrawH = 82.0;

  @override
  Widget build(BuildContext context) {
    final isSki = widget.asset == _skiAsset;
    return SizedBox(
      width: _boxW,
      height: _boxH,
      child: ClipRect(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            widget.asset,
            key: ValueKey<String>(widget.asset),
            width: isSki ? _skiDrawW : _boxW,
            height: isSki ? _skiDrawH : _boxH,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
            excludeFromSemantics: true,
            errorBuilder: (context, error, stackTrace) {
              AppLog.error(
                'Mascot',
                'Fox animation failed to load',
                error: error,
                stackTrace: stackTrace,
                details: {'asset': widget.asset},
              );
              return Icon(
                Icons.pets_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.primary.withValues(
                      alpha: 0.5,
                    ),
              );
            },
          ),
        ),
      ),
    );
  }
}
