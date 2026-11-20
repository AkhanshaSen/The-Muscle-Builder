import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// Clears in-memory catalog caches when the app returns to foreground.
class ReferenceCatalogLifecycle extends ConsumerStatefulWidget {
  const ReferenceCatalogLifecycle({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ReferenceCatalogLifecycle> createState() =>
      _ReferenceCatalogLifecycleState();
}

class _ReferenceCatalogLifecycleState extends ConsumerState<ReferenceCatalogLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshReferenceCatalog(ref);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}