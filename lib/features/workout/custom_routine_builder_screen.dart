import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/engines/exercise_catalog.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';
import 'exercise_preview_expandable.dart';
import 'session_exercise_panel.dart';

class CustomRoutineBuilderScreen extends ConsumerStatefulWidget {
  const CustomRoutineBuilderScreen({
    super.key,
    this.routineId,
    this.initialMuscleNames,
    this.initialSearch,
  });

  final String? routineId;
  final String? initialMuscleNames;
  final String? initialSearch;

  @override
  ConsumerState<CustomRoutineBuilderScreen> createState() =>
      _CustomRoutineBuilderScreenState();
}

class _CustomRoutineBuilderScreenState
    extends ConsumerState<CustomRoutineBuilderScreen> {
  final _nameCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  final _pickedIds = <String>[];
  var _muscles = <MuscleGroup>{};
  var _loading = true;
  String? _editId;
  String? _expandedPreviewId;

  @override
  void initState() {
    super.initState();
    final search = widget.initialSearch?.trim();
    if (search != null && search.isNotEmpty) {
      _searchCtrl.text = search;
    }
    final raw = widget.initialMuscleNames;
    if (raw != null && raw.isNotEmpty) {
      for (final part in raw.split(',')) {
        final name = part.trim();
        if (name.isEmpty) continue;
        try {
          _muscles.add(MuscleGroup.values.byName(name));
        } catch (_) {}
      }
    }
    _searchCtrl.addListener(() => setState(() {}));
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final id = widget.routineId;
    if (id == null) {
      setState(() => _loading = false);
      return;
    }
    final row =
        await ref.read(customRoutineRepositoryProvider).getById(id);
    if (!mounted) return;
    if (row != null) {
      _editId = row.id;
      _nameCtrl.text = row.name;
      _pickedIds.addAll(row.exerciseIds);
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _selectAllMuscles() {
    setState(() => _muscles = {});
  }

  void _toggleMuscle(MuscleGroup g) {
    setState(() {
      if (_muscles.isEmpty) {
        _muscles = {g};
        return;
      }
      if (_muscles.contains(g)) {
        if (_muscles.length > 1) {
          _muscles.remove(g);
        }
      } else {
        _muscles.add(g);
      }
    });
  }

  void _togglePick(String id) {
    setState(() {
      if (_pickedIds.contains(id)) {
        _pickedIds.remove(id);
      } else {
        _pickedIds.add(id);
      }
    });
  }

  void _togglePreview(String id) {
    setState(() {
      _expandedPreviewId = _expandedPreviewId == id ? null : id;
    });
  }

  void _removeAt(int index) {
    setState(() => _pickedIds.removeAt(index));
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name your routine first.')),
      );
      return;
    }
    if (_pickedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one exercise.')),
      );
      return;
    }
    final routine = CustomRoutine(
      id: _editId ?? const Uuid().v4(),
      name: name,
      exerciseIds: List.from(_pickedIds),
      updatedAt: DateTime.now(),
    );
    await ref.read(customRoutineRepositoryProvider).upsert(routine);
    ref.read(customRoutinesTickProvider.notifier).state++;
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profile = ref.watch(profileProvider).asData?.value;
    final exercisesAsync = ref.watch(exercisesForProfileProvider);
    final scheme = Theme.of(context).colorScheme;
    final showMuscleBoost = _muscles.isNotEmpty &&
        (_muscles.contains(MuscleGroup.chest) ||
            _muscles.contains(MuscleGroup.shoulders));

    return Scaffold(
      appBar: AppBar(
        title: Text(_editId == null ? 'New routine' : 'Edit routine'),
        leading: const NestedBackButton(fallbackLocation: '/workout'),
      ),
      body: exercisesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (bank) {
          final filtered = ExerciseCatalog.filterExercises(
            bank,
            muscleGroups: _muscles,
            query: _searchCtrl.text,
            gender: profile?.gender,
            equipment: profile?.equipment.toSet(),
          );
          final byId = {for (final e in bank) e.id: e};

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: AppSpacing.page,
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Routine name',
                        hintText: 'Chest & shoulders push',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Muscle focus',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: _muscles.isEmpty,
                          onSelected: (_) => _selectAllMuscles(),
                        ),
                        for (final g in MuscleGroup.values)
                          FilterChip(
                            label: Text(g.label),
                            selected: _muscles.contains(g),
                            onSelected: (_) => _toggleMuscle(g),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _searchCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Search exercises',
                      ),
                    ),
                    if (profile != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        _muscles.isEmpty
                            ? 'Showing all muscles · matched for ${profile.gender.label}'
                            : showMuscleBoost
                                ? 'Sorted for ${profile.gender.label} · chest & shoulders boosted'
                                : 'Sorted for ${profile.gender.label}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    if (_pickedIds.isNotEmpty) ...[
                      Text(
                        'Your picks',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: ReorderableListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          buildDefaultDragHandles: false,
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) newIndex--;
                              final item = _pickedIds.removeAt(oldIndex);
                              _pickedIds.insert(newIndex, item);
                            });
                          },
                          children: [
                            for (var i = 0; i < _pickedIds.length; i++)
                              _PickedExerciseRow(
                                key: ValueKey(_pickedIds[i]),
                                index: i,
                                title: byId[_pickedIds[i]]?.name ?? '…',
                                onRemove: () => _removeAt(i),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    Text(
                      'Add exercises',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      'Tap a row to preview frames · use + to add',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...filtered.expand((ex) {
                      final picked = _pickedIds.contains(ex.id);
                      final expanded = _expandedPreviewId == ex.id;
                      return [
                        CatalogExerciseRow(
                          exercise: ex,
                          selected: picked,
                          isExpanded: expanded,
                          onPreviewTap: () => _togglePreview(ex.id),
                          onTogglePick: () => _togglePick(ex.id),
                        ),
                        if (expanded)
                          ExercisePreviewExpandable(
                            exercise: ex,
                            selected: picked,
                            onAdd: () => _togglePick(ex.id),
                            onRemove: () => _togglePick(ex.id),
                          ),
                      ];
                    }),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No exercises match. Try All, another muscle chip, or search.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: AppSpacing.page,
                  child: PrimaryCta(
                    label: _pickedIds.isEmpty
                        ? 'Save routine'
                        : 'Save · ${_pickedIds.length} exercises',
                    onPressed: _save,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PickedExerciseRow extends StatelessWidget {
  const _PickedExerciseRow({
    super.key,
    required this.index,
    required this.title,
    required this.onRemove,
  });

  final int index;
  final String title;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final craft = context.craft;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: craft.surface,
        border: Border.all(color: craft.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.drag_handle, size: 22),
              ),
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close),
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              padding: const EdgeInsets.all(8),
              tooltip: 'Remove',
            ),
          ],
        ),
      ),
    );
  }
}