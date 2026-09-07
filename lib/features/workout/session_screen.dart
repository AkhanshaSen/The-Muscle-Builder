import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/engines/gym_session_sizing.dart';
import '../../domain/engines/overload_engine.dart';
import '../../domain/engines/set_pace.dart';
import '../../domain/models/models.dart';
import 'exercise_posture_gallery.dart';

enum _SessionPanel { form, train }

class _CompletedSetInfo {
  const _CompletedSetInfo({
    required this.durationSeconds,
    required this.reps,
    required this.weightKg,
    required this.verdict,
  });

  final int durationSeconds;
  final int reps;
  final double weightKg;
  final SetPaceVerdict verdict;
}

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  WorkoutSession? _session;
  WorkoutPlan? _plan;
  Map<String, List<String>> _demoById = {};
  int _exerciseIndex = 0;
  int _setIndex = 0;
  bool _resting = false;
  int _restLeft = 0;
  Timer? _restTimer;
  /// Stronger water cue between exercises (vs short between-set rest).
  bool _waterBreak = false;
  int _sessionWaterGlasses = 0;

  bool _setTimerRunning = false;
  int _setElapsedSeconds = 0;
  Timer? _setTimer;

  final Map<String, _CompletedSetInfo> _completedSets = {};
  SetPaceVerdict? _lastVerdict;
  String? _lastFeedback;

  final _weightCtrl = TextEditingController(text: '20');
  final _repsCtrl = TextEditingController();
  double _rpe = 7;
  _SessionPanel _panel = _SessionPanel.train;
  OverloadSuggestion? _overload;
  String? _lastLoadedExerciseId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final session = await ref
        .read(workoutRepositoryProvider)
        .getSessionById(widget.sessionId);
    if (session == null) return;
    final plan =
        await ref.read(workoutRepositoryProvider).getPlanById(session.planId);
    final bank = await ref.read(seedRepositoryProvider).loadExercises();
    if (!mounted) return;
    setState(() {
      _session = session;
      _plan = plan?.copyWith(exercises: GymSessionSizing.activeExercises(plan));
      _demoById = {for (final e in bank) e.id: e.demoImages};
      if (plan != null && plan.exercises.isNotEmpty) {
        _repsCtrl.text = '${plan.exercises.first.reps}';
      }
      // First glance at form, then train.
      _panel = _SessionPanel.form;
      _setTimerRunning = false;
    });
    await _refreshOverload();
  }

  Future<void> _refreshOverload() async {
    final current = _current;
    if (current == null) return;
    if (_lastLoadedExerciseId == current.exerciseId && _overload != null) {
      return;
    }
    final last = await ref
        .read(workoutRepositoryProvider)
        .lastPerformanceForExercise(current.exerciseId);
    final suggestion = OverloadEngine.suggest(
      exerciseId: current.exerciseId,
      lastSets: last,
      plannedSets: current.sets,
      plannedReps: current.reps,
    );
    final weight = OverloadEngine.prefillWeight(suggestion, last);
    if (!mounted) return;
    setState(() {
      _overload = suggestion;
      _lastLoadedExerciseId = current.exerciseId;
      _weightCtrl.text = weight == weight.roundToDouble()
          ? '${weight.toInt()}'
          : weight.toStringAsFixed(1);
      if (suggestion != null &&
          suggestion.averageRpe <= 7 &&
          !suggestion.bumpWeight) {
        _repsCtrl.text = '${suggestion.suggestedReps}';
      }
    });
  }

  List<String> _imagesFor(PlannedExercise exercise) {
    if (exercise.demoImages.isNotEmpty) return exercise.demoImages;
    return _demoById[exercise.exerciseId] ?? const [];
  }

  String _setKey(String exerciseId, int setNumber) => '$exerciseId:$setNumber';

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  SetPaceTarget _targetFor(PlannedExercise exercise) {
    final reps = int.tryParse(_repsCtrl.text) ?? exercise.reps;
    return SetPaceTarget.forExercise(
      reps: reps,
      exerciseName: exercise.name,
    );
  }

  Color _toneColor(ColorTone tone, ColorScheme scheme) => switch (tone) {
        ColorTone.neutral => scheme.onSurface.withValues(alpha: 0.7),
        ColorTone.good => const Color(0xFF4CAF50),
        ColorTone.warning => const Color(0xFFFFC107),
        ColorTone.bad => const Color(0xFFFF5252),
      };

  @override
  void dispose() {
    _restTimer?.cancel();
    _setTimer?.cancel();
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    super.dispose();
  }

  PlannedExercise? get _current {
    final plan = _plan;
    if (plan == null || plan.exercises.isEmpty) return null;
    if (_exerciseIndex >= plan.exercises.length) return null;
    return plan.exercises[_exerciseIndex];
  }

  int get _totalSetsPlanned {
    final plan = _plan;
    if (plan == null) return 0;
    return plan.exercises.fold<int>(0, (sum, e) => sum + e.sets);
  }

  void _startSetTimer({bool resetElapsed = true}) {
    _setTimer?.cancel();
    setState(() {
      _setTimerRunning = true;
      if (resetElapsed) _setElapsedSeconds = 0;
      _lastVerdict = null;
      _lastFeedback = null;
      _panel = _SessionPanel.train;
    });
    _setTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_setTimerRunning) return;
      setState(() => _setElapsedSeconds++);
    });
  }

  void _stopSetTimer() {
    _setTimer?.cancel();
    _setTimer = null;
    _setTimerRunning = false;
  }

  void _pauseOrResumeSetTimer() {
    if (_resting) return;
    if (_setTimerRunning) {
      _setTimer?.cancel();
      setState(() => _setTimerRunning = false);
    } else {
      _startSetTimer(resetElapsed: false);
    }
  }

  void _showFormPanel() {
    if (_setTimerRunning) {
      _setTimer?.cancel();
      _setTimerRunning = false;
    }
    setState(() => _panel = _SessionPanel.form);
  }

  void _showTrainPanel({bool startTimer = false}) {
    setState(() => _panel = _SessionPanel.train);
    if (startTimer && !_setTimerRunning && !_resting) {
      _startSetTimer(resetElapsed: _setElapsedSeconds == 0);
    }
  }

  void _startRest(int seconds, {bool waterBreak = false}) {
    _stopSetTimer();
    _restTimer?.cancel();
    setState(() {
      _resting = true;
      _restLeft = seconds;
      _waterBreak = waterBreak;
      _panel = _SessionPanel.train;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_restLeft <= 1) {
        t.cancel();
        setState(() {
          _resting = false;
          _restLeft = 0;
          _waterBreak = false;
        });
        // Brief form peek optional — go straight to next set ready (paused).
        setState(() {
          _panel = _SessionPanel.train;
          _setElapsedSeconds = 0;
          _setTimerRunning = false;
        });
      } else {
        setState(() => _restLeft--);
      }
    });
  }

  Future<void> _logRestWaterGlass() async {
    final hydro = await ref
        .read(metricsRepositoryProvider)
        .getOrCreateHydration(DateTime.now());
    await ref.read(metricsRepositoryProvider).setGlasses(
          DateTime.now(),
          hydro.glasses + 1,
        );
    ref.read(metricsTickProvider.notifier).state++;
    if (!mounted) return;
    setState(() => _sessionWaterGlasses++);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Water logged · keep sipping'),
      ),
    );
  }

  Future<void> _completeSet({int? setNumberOverride}) async {
    final current = _current;
    final session = _session;
    if (current == null || session == null || _resting) return;

    final setNumber = setNumberOverride ?? (_setIndex + 1);
    if (setNumber != _setIndex + 1) return;
    if (_completedSets.containsKey(_setKey(current.exerciseId, setNumber))) {
      return;
    }

    final reps = int.tryParse(_repsCtrl.text) ?? current.reps;
    final weight = double.tryParse(_weightCtrl.text) ?? 0;
    final duration = _setElapsedSeconds;
    final target = _targetFor(current);
    final verdict = SetPaceEvaluator.verdict(duration, target);

    _stopSetTimer();

    await ref.read(workoutRepositoryProvider).logSet(
          SetLog(
            id: const Uuid().v4(),
            sessionId: session.id,
            exerciseId: current.exerciseId,
            setNumber: setNumber,
            repsCompleted: reps,
            weightKg: weight,
            rpe: _rpe.round(),
            completed: true,
            durationSeconds: duration,
          ),
        );

    setState(() {
      _completedSets[_setKey(current.exerciseId, setNumber)] =
          _CompletedSetInfo(
        durationSeconds: duration,
        reps: reps,
        weightKg: weight,
        verdict: verdict,
      );
      _lastVerdict = verdict;
      _lastFeedback =
          '${verdict.label} · ${_formatDuration(duration)} (target ${target.rangeLabel})';
    });

    final setsDoneNow = _completedSets.length;
    final profile = await ref.read(profileRepositoryProvider).getProfile();
    final cheer = EncouragementCopy.forSetComplete(
      setNumber: setNumber,
      totalSetsInSession: setsDoneNow,
      tone: profile?.coachTone.name ?? 'friendly',
      name: profile?.name ?? '',
      verdictLabel: verdict.label,
    );

    ref.read(sessionProgressTickProvider.notifier).state++;
    ref.invalidate(setsTodayProvider);
    ref.invalidate(setsThisWeekProvider);

    if (!mounted) return;
    if (_rpe.round() >= 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'RPE 9+ — consider lowering load next set, or mark that muscle under Avoid on your next check-in.',
          ),
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: _toneColor(
          SetPaceEvaluator.toneFor(verdict),
          Theme.of(context).colorScheme,
        ).withValues(alpha: 0.95),
        content: Text(cheer, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );

    final isLastSet = setNumber >= current.sets;
    final isLastExercise = _exerciseIndex + 1 >= (_plan?.exercises.length ?? 0);

    if (isLastSet && isLastExercise) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      await _finish();
      return;
    }

    if (isLastSet) {
      setState(() {
        _exerciseIndex++;
        _setIndex = 0;
        final next = _current;
        if (next != null) _repsCtrl.text = '${next.reps}';
        _lastLoadedExerciseId = null;
        _overload = null;
      });
      await _refreshOverload();
      _startRest(
        (current.restSeconds + 15).clamp(45, 180),
        waterBreak: true,
      );
    } else {
      setState(() => _setIndex = setNumber);
      _startRest(current.restSeconds, waterBreak: false);
    }
  }

  Future<void> _skipSet() async {
    final current = _current;
    if (current == null || _resting) return;
    _stopSetTimer();
    final isLastSet = _setIndex + 1 >= current.sets;
    final isLastExercise = _exerciseIndex + 1 >= (_plan?.exercises.length ?? 0);
    if (isLastSet && isLastExercise) {
      await _finish();
      return;
    }
    if (isLastSet) {
      setState(() {
        _exerciseIndex++;
        _setIndex = 0;
        final next = _current;
        if (next != null) _repsCtrl.text = '${next.reps}';
        _setElapsedSeconds = 0;
        _panel = _SessionPanel.form;
        _lastLoadedExerciseId = null;
        _overload = null;
      });
      await _refreshOverload();
    } else {
      setState(() {
        _setIndex++;
        _setElapsedSeconds = 0;
      });
      _startSetTimer();
    }
  }

  Future<void> _swap() async {
    final current = _current;
    final plan = _plan;
    final profile = await ref.read(profileRepositoryProvider).getProfile();
    if (current == null || plan == null || profile == null) return;

    final checkIn = await ref.read(workoutRepositoryProvider).getTodaysCheckIn();
    final equipment = checkIn?.equipmentOverride ?? profile.equipment;

    final bank = await ref.read(seedRepositoryProvider).loadExercises();
    final exclude = plan.exercises.map((e) => e.exerciseId).toSet();
    final swapped = ref.read(routineEngineProvider).swapExercise(
          current: current,
          availableEquipment: equipment,
          experience: profile.experience,
          bank: bank,
          excludeIds: exclude,
        );

    if (swapped == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No suitable swap found')),
      );
      return;
    }

    final updated = List<PlannedExercise>.from(plan.exercises);
    updated[_exerciseIndex] = swapped;
    final newPlan = await ref
        .read(workoutRepositoryProvider)
        .updatePlanExercises(plan.id, updated);
    setState(() {
      _plan = newPlan;
      _repsCtrl.text = '${swapped.reps}';
      _setIndex = 0;
      _setElapsedSeconds = 0;
      _panel = _SessionPanel.form;
      _setTimerRunning = false;
      _lastLoadedExerciseId = null;
      _overload = null;
    });
    await _refreshOverload();
  }

  Future<void> _finish() async {
    _restTimer?.cancel();
    _stopSetTimer();
    await ref.read(workoutRepositoryProvider).completeSession(widget.sessionId);
    await ref.read(routineRepositoryProvider).markGymCompletedToday();
    ref.read(dayLogsTickProvider.notifier).state++;
    ref.invalidate(todaysPlanProvider);
    ref.invalidate(completedSessionsProvider);
    ref.invalidate(workoutsThisWeekProvider);
    ref.invalidate(setsTodayProvider);
    ref.invalidate(setsThisWeekProvider);
    if (!mounted) return;

    final plan = _plan ??
        await () async {
          final session = await ref
              .read(workoutRepositoryProvider)
              .getSessionById(widget.sessionId);
          if (session == null) return null;
          return ref
              .read(workoutRepositoryProvider)
              .getPlanById(session.planId);
        }();
    final burn = plan?.estimatedBurnKcal ?? 0;
    final fuel = plan?.mealFuelKcal ?? 0;
    final balance = plan?.calorieBalanceKcal ?? 0;
    final muscles = plan?.exercises
            .expand((e) => e.muscleGroups)
            .toSet()
            .map((m) => m.label)
            .join(', ') ??
        'your targets';
    final balanceLine = balance >= 0
        ? 'Meals cover the session with ~$balance kcal left for recovery.'
        : 'Session burned ~${balance.abs()} kcal more than pre+post meals logged.';

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session complete'),
        content: Text(
          'Nice work.\n\n'
          'Workout burn: ~$burn kcal\n'
          'Pre + post fuel: $fuel kcal\n'
          '$balanceLine\n\n'
          'Improved today: $muscles',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/nutrition?timing=post');
            },
            child: const Text('See meals'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/progress');
            },
            child: const Text('Progress'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _current;
    if (_session == null || _plan == null || current == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    final target = _targetFor(current);
    final liveTone = SetPaceEvaluator.liveTone(_setElapsedSeconds, target);
    final liveColor = _toneColor(liveTone, scheme);
    final overall = _completedSets.length / _totalSetsPlanned.clamp(1, 999);

    return Scaffold(
      appBar: AppBar(
        leading: const NestedBackButton(fallbackLocation: '/workout'),
        title: Text(
          'Exercise ${_exerciseIndex + 1} of ${_plan!.exercises.length}',
        ),
        actions: [
          TextButton(onPressed: _finish, child: const Text('Finish')),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: overall.clamp(0.05, 1.0),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  current.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set ${_setIndex + 1}/${current.sets} · target ${current.reps} reps · ${_completedSets.length} sets logged',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!_resting) ...[
                  const SizedBox(height: 12),
                  SegmentedButton<_SessionPanel>(
                    segments: const [
                      ButtonSegment(
                        value: _SessionPanel.form,
                        icon: Icon(Icons.accessibility_new),
                        label: Text('Form'),
                      ),
                      ButtonSegment(
                        value: _SessionPanel.train,
                        icon: Icon(Icons.timer_outlined),
                        label: Text('Train'),
                      ),
                    ],
                    selected: {_panel},
                    onSelectionChanged: (s) {
                      final next = s.first;
                      if (next == _SessionPanel.form) {
                        _showFormPanel();
                      } else {
                        _showTrainPanel();
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _resting
                  ? _buildRestPanel(scheme)
                  : _panel == _SessionPanel.form
                      ? _buildFormPanel(current, scheme)
                      : _buildTrainPanel(current, target, liveColor, scheme),
            ),
          ),
          if (!_resting) _buildStickyActions(scheme),
        ],
      ),
    );
  }

  Widget _buildStickyActions(ColorScheme scheme) {
    final onForm = _panel == _SessionPanel.form;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Material(
      elevation: 0,
      color: const Color(0xFF161616),
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        top: false,
        maintainBottomViewPadding: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + (bottomInset > 0 ? 0 : 0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_setTimerRunning && _panel == _SessionPanel.train)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Paused at ${_formatDuration(_setElapsedSeconds)} — Resume when ready',
                    style: const TextStyle(
                      color: Color(0xFFFFC107),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Row(
                children: [
                  if (onForm) ...[
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _showTrainPanel(startTimer: true),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(
                          _setElapsedSeconds == 0
                              ? 'Got it — start set'
                              : 'Back to timer',
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pauseOrResumeSetTimer,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _setTimerRunning
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(_setTimerRunning ? 'Pause' : 'Resume'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: () => _completeSet(),
                        icon: const Icon(Icons.check_rounded),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Done · ${_formatDuration(_setElapsedSeconds)}',
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(onPressed: _skipSet, child: const Text('Skip set')),
                  TextButton(onPressed: _swap, child: const Text('Swap')),
                  const Spacer(),
                  if (!onForm)
                    TextButton.icon(
                      onPressed: _showFormPanel,
                      icon: const Icon(Icons.accessibility_new, size: 18),
                      label: const Text('Check form'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestPanel(ColorScheme scheme) {
    final bottomPad = MediaQuery.viewPaddingOf(context).bottom + 24;
    return ScrollConfiguration(
      behavior: const NoStretchScrollBehavior(),
      child: ListView(
      key: const ValueKey('rest'),
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPad),
      children: [
        const SizedBox(height: 24),
        Icon(Icons.hourglass_top_rounded, size: 48, color: scheme.primary),
        const SizedBox(height: 16),
        if (_lastFeedback != null) ...[
          Text(
            _lastVerdict?.label ?? 'Set logged',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(_lastFeedback!, textAlign: TextAlign.center),
          const SizedBox(height: 24),
        ],
        Text(
          _waterBreak ? 'Rest · water break' : 'Rest',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          _formatDuration(_restLeft),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          _setIndex == 0
              ? 'Next: ${_current?.name ?? 'exercise'}'
              : 'Next: set ${_setIndex + 1}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Card(
          color: scheme.primaryContainer.withValues(alpha: 0.35),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.water_drop, color: scheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _waterBreak
                            ? 'Between moves — sip ~150–250 ml before the next exercise.'
                            : 'Quick sip between sets. Stay ahead of thirst.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: _logRestWaterGlass,
                  icon: const Icon(Icons.add),
                  label: Text(
                    _sessionWaterGlasses == 0
                        ? 'Log a glass'
                        : 'Log a glass · $_sessionWaterGlasses this session',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {
            _restTimer?.cancel();
            setState(() {
              _resting = false;
              _restLeft = 0;
              _waterBreak = false;
              _panel = _SessionPanel.form;
              _setElapsedSeconds = 0;
              _setTimerRunning = false;
            });
          },
          child: const Text('Skip rest · preview form'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () {
            _restTimer?.cancel();
            setState(() {
              _resting = false;
              _restLeft = 0;
              _waterBreak = false;
            });
            _startSetTimer();
          },
          child: const Text('Skip rest · start next set now'),
        ),
      ],
      ),
    );
  }

  Widget _buildFormPanel(PlannedExercise current, ColorScheme scheme) {
    return ScrollConfiguration(
      behavior: const NoStretchScrollBehavior(),
      child: ListView(
      key: const ValueKey('form'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          'Review form, then start the set',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Timer stays paused here so you can look without rushing.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.65),
              ),
        ),
        const SizedBox(height: 16),
        ExercisePostureGallery(
          imageUrls: _imagesFor(current),
          height: 190,
        ),
        if (current.formCues.isNotEmpty) ...[
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Do this',
            subtitle: 'Follow these in order before you start the set.',
            icon: Icons.check_circle,
            iconColor: scheme.primary,
            items: current.formCues,
            numbered: true,
          ),
        ],
        if (current.commonMistakes.isNotEmpty) ...[
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Avoid',
            icon: Icons.close_rounded,
            iconColor: const Color(0xFFFF5252),
            items: current.commonMistakes,
          ),
        ],
        const SizedBox(height: 16),
        _compactLogFields(),
        const SizedBox(height: 20),
        Text(
          'Coming up',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _plan!.exercises.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final e = _plan!.exercises[i];
              final active = i == _exerciseIndex;
              final done = i < _exerciseIndex;
              return Chip(
                avatar: Icon(
                  done
                      ? Icons.check_circle
                      : active
                          ? Icons.play_circle_fill
                          : Icons.circle_outlined,
                  size: 18,
                  color: active || done ? scheme.primary : null,
                ),
                label: Text(
                  e.name,
                  style: TextStyle(
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                backgroundColor: active
                    ? scheme.primary.withValues(alpha: 0.18)
                    : null,
              );
            },
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildTrainPanel(
    PlannedExercise current,
    SetPaceTarget target,
    Color liveColor,
    ColorScheme scheme,
  ) {
    final progress =
        (_setElapsedSeconds / target.tooSlowSeconds).clamp(0.0, 1.0);

    return ScrollConfiguration(
      behavior: const NoStretchScrollBehavior(),
      child: ListView(
      key: const ValueKey('train'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        if (_overload != null) ...[
          Material(
            color: scheme.secondaryContainer.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: scheme.secondary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _overload!.message,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Set timer',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Target ${target.rangeLabel}',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDuration(_setElapsedSeconds),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: liveColor,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    color: liveColor,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  SetPaceEvaluator.liveStatus(_setElapsedSeconds, target),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: liveColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Tick sets as you finish',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 1; i <= current.sets; i++)
              _setChip(current, i, target, scheme),
          ],
        ),
        const SizedBox(height: 16),
        _compactLogFields(),
      ],
      ),
    );
  }

  Widget _setChip(
    PlannedExercise current,
    int setNumber,
    SetPaceTarget target,
    ColorScheme scheme,
  ) {
    final key = _setKey(current.exerciseId, setNumber);
    final info = _completedSets[key];
    final done = info != null;
    final isCurrent = !done && setNumber == _setIndex + 1;
    final locked = !done && setNumber > _setIndex + 1;

    return FilterChip(
      selected: done || isCurrent,
      showCheckmark: done,
      label: Text(
        done
            ? 'Set $setNumber · ${_formatDuration(info.durationSeconds)}'
            : isCurrent
                ? 'Set $setNumber · now'
                : 'Set $setNumber',
      ),
      onSelected: locked || done || _resting
          ? null
          : (_) => _completeSet(setNumberOverride: setNumber),
      selectedColor: done
          ? _toneColor(SetPaceEvaluator.toneFor(info.verdict), scheme)
              .withValues(alpha: 0.25)
          : scheme.primary.withValues(alpha: 0.2),
    );
  }

  Widget _compactLogFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'kg',
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _repsCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Reps',
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'RPE',
              isDense: true,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _rpe.round(),
                isDense: true,
                items: [
                  for (var i = 1; i <= 10; i++)
                    DropdownMenuItem(value: i, child: Text('$i')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _rpe = v.toDouble());
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
    this.subtitle,
    this.numbered = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final List<String> items;
  final bool numbered;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 10),
            ...items.asMap().entries.map((entry) {
              final i = entry.key;
              final c = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (numbered)
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: iconColor.withValues(alpha: 0.2),
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: iconColor,
                          ),
                        ),
                      )
                    else
                      Icon(icon, size: 16, color: iconColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (numbered)
                            Text(
                              'Step ${i + 1}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          Text(c),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
