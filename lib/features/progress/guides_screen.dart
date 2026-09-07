import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/common_widgets.dart';
import '../../data/seed/pro_nutrition_guides.dart';

/// Compact list of coach-approved nutrition links (opened from Profile).
class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  Future<void> _open(BuildContext context, ProNutritionGuide guide) async {
    final uri = Uri.parse(guide.url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open ${guide.source}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach reading'),
        leading: const NestedBackButton(fallbackLocation: '/profile'),
        toolbarHeight: 48,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        itemCount: proNutritionGuides.length + 1,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
              child: Text(
                'Food Pharmer + pro education — opens in your browser. '
                'Educational only, not medical advice.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            );
          }
          final g = proNutritionGuides[i - 1];
          return ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            leading: Icon(Icons.menu_book_outlined, color: scheme.primary),
            title: Text(
              g.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text('${g.source} · ${g.benefit}', maxLines: 2),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => _open(context, g),
          );
        },
      ),
    );
  }
}
