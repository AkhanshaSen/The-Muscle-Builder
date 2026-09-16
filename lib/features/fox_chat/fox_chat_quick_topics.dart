/// Tappable chat shortcuts — ordered by how often users get stuck in-app.
///
/// RCA (why these topics):
/// 1. **Orientation** — new/exploring users need tab map first (mascot = discovery).
/// 2. **Daily loop** — check-in → plan → session is the core job; highest repeat intent.
/// 3. **Nutrition** — differentiator (Indian fuel); users forget it’s a separate tab.
/// 4. **Progress** — “did it save?” after logging sets; stats/history anxiety.
/// 5. **Routine edge cases** — rest/cheat/train-anyway confuses people on Home.
/// 6. **Data & device** — backup before phone swap; low frequency but high stakes.
/// 7. **Personalization** — coach tone/theme once users settle in.
/// 8. **Habits** — hydration + weekly routine are secondary but visible on Home/Settings.
class FoxQuickTopic {
  const FoxQuickTopic({required this.label, required this.prompt});

  final String label;
  final String prompt;
}

const foxQuickTopics = <FoxQuickTopic>[
  FoxQuickTopic(
    label: 'App tabs',
    prompt: 'What are the main tabs and what does each do?',
  ),
  FoxQuickTopic(
    label: 'Get started',
    prompt: 'How do I get started after onboarding?',
  ),
  FoxQuickTopic(
    label: 'Check-in',
    prompt: 'How does the daily mood check-in work?',
  ),
  FoxQuickTopic(
    label: "Today's plan",
    prompt: 'What is my workout plan for today?',
  ),
  FoxQuickTopic(
    label: 'Start session',
    prompt: 'How do I start a workout session and log sets?',
  ),
  FoxQuickTopic(
    label: 'Nutrition',
    prompt: 'Where are pre and post workout meals?',
  ),
  FoxQuickTopic(
    label: 'Progress',
    prompt: 'What can I see on the Progress tab?',
  ),
  FoxQuickTopic(
    label: 'Rest days',
    prompt: 'How do rest days and train anyway work?',
  ),
  FoxQuickTopic(
    label: 'Hydration',
    prompt: 'How do I log water on Home?',
  ),
  FoxQuickTopic(
    label: 'Weekly routine',
    prompt: 'Where do I edit my weekly gym and rest pattern?',
  ),
  FoxQuickTopic(
    label: 'Backup',
    prompt: 'How do I backup and restore my data?',
  ),
  FoxQuickTopic(
    label: 'Coach tone',
    prompt: 'How do I change coach personality and theme?',
  ),
  FoxQuickTopic(
    label: 'Fox mascot',
    prompt: 'How do I turn the idle fox on or off?',
  ),
];
