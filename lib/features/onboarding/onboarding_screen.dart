import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/models.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _step = 0;

  final _nameCtrl = TextEditingController();
  final _journeyCtrl =
      TextEditingController(text: AppConstants.defaultJourneyName);
  double _weight = 70;
  double _height = 170;
  int _age = 25;
  Gender _gender = Gender.preferNotToSay;
  ActivityLevel _activity = ActivityLevel.moderatelyActive;
  PrimaryGoal _goal = PrimaryGoal.consistency;
  ExperienceLevel _experience = ExperienceLevel.beginner;
  final Set<Equipment> _equipment = {Equipment.bodyweight};
  DietType _diet = DietType.vegetarian;
  final Set<Allergy> _allergies = {};
  bool _saving = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _journeyCtrl.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_step == 0 && _nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }
    if (_step < 4) {
      setState(() => _step++);
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
      return;
    }
    await _finish();
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    final existing = await ref.read(profileRepositoryProvider).getProfile();
    final profile = UserProfile(
      id: existing?.id ?? const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      journeyName: _journeyCtrl.text.trim().isEmpty
          ? AppConstants.defaultJourneyName
          : _journeyCtrl.text.trim(),
      weightKg: _weight,
      heightCm: _height,
      age: _age,
      gender: _gender,
      activityLevel: _activity,
      primaryGoal: _goal,
      experience: _experience,
      equipment: _equipment.toList(),
      dietType: _diet,
      allergies: _allergies.toList(),
      themeColorHex: existing?.themeColorHex ?? AppConstants.defaultAccentHex,
      coachTone: existing?.coachTone ?? CoachTone.friendly,
      themePreference: existing?.themePreference ?? ThemePreference.dark,
      onboardingComplete: true,
      cuisineRegion: existing?.cuisineRegion ?? CuisineRegion.panIndian,
      showMacros: existing?.showMacros ?? false,
    );
    await ref.read(profileRepositoryProvider).saveProfile(profile);
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  Text('${_step + 1}/5'),
                ],
              ),
            ),
            LinearProgressIndicator(value: (_step + 1) / 5),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _welcomeStep(),
                  _statsStep(),
                  _goalsStep(),
                  _equipmentStep(),
                  _dietStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_step > 0)
                    TextButton(
                      onPressed: () {
                        setState(() => _step--);
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut,
                        );
                      },
                      child: const Text('Back'),
                    ),
                  const Spacer(),
                  SizedBox(
                    width: 160,
                    child: FilledButton(
                      onPressed: _saving ? null : _next,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_step == 4 ? 'Start training' : 'Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _welcomeStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 24),
        Text(
          'Welcome, builder.',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Mood-aware workouts and Indian meal suggestions, tailored to you.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _nameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Your name',
            hintText: 'e.g. Arjun',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _journeyCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Name your journey',
            hintText: 'e.g. Iron Monsoon',
          ),
        ),
      ],
    );
  }

  Widget _statsStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SectionHeader(
          title: 'Body stats',
          subtitle: 'Used for personalization — you can update anytime.',
        ),
        const SizedBox(height: 24),
        Text('Weight: ${_weight.toStringAsFixed(0)} kg'),
        Slider(
          min: 35,
          max: 150,
          divisions: 115,
          value: _weight,
          onChanged: (v) => setState(() => _weight = v),
        ),
        Text('Height: ${_height.toStringAsFixed(0)} cm'),
        Slider(
          min: 140,
          max: 210,
          divisions: 70,
          value: _height,
          onChanged: (v) => setState(() => _height = v),
        ),
        Text('Age: $_age'),
        Slider(
          min: 14,
          max: 80,
          divisions: 66,
          value: _age.toDouble(),
          onChanged: (v) => setState(() => _age = v.round()),
        ),
        const SizedBox(height: 12),
        Text('Gender', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: Gender.values.map((g) {
            return ChoiceChip(
              label: Text(g.label),
              selected: _gender == g,
              onSelected: (_) => setState(() => _gender = g),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _goalsStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SectionHeader(
          title: 'Goals & experience',
          subtitle: 'This shapes intensity defaults and encouragement.',
        ),
        const SizedBox(height: 20),
        Text('Primary goal', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        ...PrimaryGoal.values.map((g) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SelectableCard(
              selected: _goal == g,
              onTap: () => setState(() => _goal = g),
              child: Text(g.label),
            ),
          );
        }),
        const SizedBox(height: 12),
        Text('Activity level', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ActivityLevel.values.map((a) {
            return ChoiceChip(
              label: Text(a.label),
              selected: _activity == a,
              onSelected: (_) => setState(() => _activity = a),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text('Experience', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ExperienceLevel.values.map((e) {
            return ChoiceChip(
              label: Text(e.label),
              selected: _experience == e,
              onSelected: (_) => setState(() => _experience = e),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _equipmentStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SectionHeader(
          title: 'Available equipment',
          subtitle: 'Routines will prefer what you actually have.',
        ),
        const SizedBox(height: 20),
        ...Equipment.values.map((e) {
          final on = _equipment.contains(e);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SelectableCard(
              selected: on,
              onTap: () {
                setState(() {
                  if (on) {
                    if (_equipment.length > 1) _equipment.remove(e);
                  } else {
                    _equipment.add(e);
                  }
                });
              },
              child: Row(
                children: [
                  Icon(on ? Icons.check_circle : Icons.circle_outlined),
                  const SizedBox(width: 12),
                  Text(e.label),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _dietStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SectionHeader(
          title: 'Diet & allergies',
          subtitle: 'Indian meal suggestions will auto-filter.',
        ),
        const SizedBox(height: 20),
        ...DietType.values.map((d) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SelectableCard(
              selected: _diet == d,
              onTap: () => setState(() => _diet = d),
              child: Text(d.label),
            ),
          );
        }),
        const SizedBox(height: 16),
        Text('Allergies', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: Allergy.values.map((a) {
            final on = _allergies.contains(a);
            return FilterChip(
              label: Text(a.label),
              selected: on,
              onSelected: (v) {
                setState(() {
                  if (v) {
                    _allergies.add(a);
                  } else {
                    _allergies.remove(a);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
