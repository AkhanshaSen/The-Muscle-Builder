import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Muted, looping demo clip when a [demoVideoUrl] exists.
class ExerciseSilentVideo extends StatefulWidget {
  const ExerciseSilentVideo({
    super.key,
    required this.url,
    this.height = 160,
  });

  final String url;
  final double height;

  @override
  State<ExerciseSilentVideo> createState() => _ExerciseSilentVideoState();
}

class _ExerciseSilentVideoState extends State<ExerciseSilentVideo> {
  VideoPlayerController? _controller;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final c = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await c.initialize();
      await c.setVolume(0);
      await c.setLooping(true);
      await c.play();
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() => _controller = c);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return const SizedBox.shrink();
    final c = _controller;
    if (c == null || !c.value.isInitialized) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: c.value.size.width,
            height: c.value.size.height,
            child: VideoPlayer(c),
          ),
        ),
      ),
    );
  }
}