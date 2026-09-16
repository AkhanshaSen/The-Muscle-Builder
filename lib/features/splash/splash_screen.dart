import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/logging/app_log.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const _minShow = Duration(milliseconds: 900);
  static const _fadeOut = Duration(milliseconds: 280);

  var _opacity = 1.0;
  var _minElapsed = false;
  var _navigated = false;

  @override
  void initState() {
    super.initState();
    // Android 12+ masks the native splash icon in a circle; show Flutter UI ASAP.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FlutterNativeSplash.remove();
      AppLog.info('Splash', 'Native splash removed — showing full logo');
    });
    Future<void>.delayed(_minShow, () {
      if (!mounted) return;
      setState(() => _minElapsed = true);
      _tryNavigate();
    });
    // Never hang on splash if profile stream is slow.
    Future<void>.delayed(const Duration(seconds: 4), () {
      if (!mounted || _navigated) return;
      setState(() => _minElapsed = true);
      _tryNavigate(force: true);
    });
  }

  void _tryNavigate({bool force = false}) {
    if (_navigated || !_minElapsed) return;

    final profileAsync = ref.read(profileProvider);
    if (!force && profileAsync.isLoading && !profileAsync.hasValue) return;

    _navigated = true;
    final onboarded = profileAsync.value?.onboardingComplete == true;
    final target = onboarded ? '/home' : '/onboarding';

    AppLog.success(
      'Splash',
      'Splash finished — going to $target',
      {
        'onboarded': onboarded,
        'forced': force,
        'profileLoaded': profileAsync.hasValue,
      },
    );

    setState(() => _opacity = 0);
    Future<void>.delayed(_fadeOut, () {
      if (!mounted) return;
      context.go(target);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(profileProvider, (prev, next) {
      if ((prev?.isLoading ?? true) && next.hasValue) _tryNavigate();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: _fadeOut,
        curve: Curves.easeOut,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final side = constraints.maxWidth < constraints.maxHeight
                      ? constraints.maxWidth
                      : constraints.maxHeight;
                  return Image.asset(
                    'assets/icon/splash_logo.png',
                    width: side,
                    height: side,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
