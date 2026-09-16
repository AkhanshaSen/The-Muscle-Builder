import '../../core/constants/app_constants.dart';
import 'fox_chat_snapshot.dart';

/// In-app guide fox — crisp answers; lists use [listPrefix] for chat UI bullets.
class FoxChatAssistant {
  const FoxChatAssistant();

  static const listPrefix = '@list\n';

  String welcome(FoxChatSnapshot snap) {
    final journey = snap.journeyName?.trim();
    if (journey != null && journey.isNotEmpty) {
      return _plain(
        'Hey ${snap.firstName}! 🦊 I can help with "$journey" and anything in '
        '${AppConstants.appName} — tabs, today\'s plan, nutrition, progress, or backup.',
      );
    }
    return _plain(
      'Hey ${snap.firstName}! 🦊 Ask me anything about ${AppConstants.appName} — '
      'where to tap, what a screen does, or what your numbers mean today.',
    );
  }

  String reply(String question, FoxChatSnapshot snap) {
    final q = question.trim().toLowerCase();
    if (q.isEmpty) {
      return _plain('Ask a question above — e.g. "Where is backup?" or "What\'s my plan today?"');
    }

    final hit = _bestMatch(q, snap);
    if (hit != null) return hit;

    return _plain(
      'I don\'t have a specific answer for that, ${snap.firstName}. '
      'Try naming a tab (Home, Workout, Nutrition, Progress, Profile) or a task '
      '(check-in, log sets, export backup).',
    );
  }

  String _plain(String text) => text;

  String _list(List<String> items) {
    if (items.length == 1) return _plain(items.first);
    return '$listPrefix${items.join('\n')}';
  }

  String? _bestMatch(String q, FoxChatSnapshot snap) {
    final candidates = <_Candidate>[
      if (_any(q, ['hello', 'hi', 'hey', 'sup']))
        _Candidate(
          10,
          () => _plain(
            'Hey ${snap.firstName}! 👋 What do you want to do in the app right now? '
            'I can point you to the exact tab or setting.',
          ),
        ),
      if (_any(q, ['who are you', 'what are you', 'fox']))
        _Candidate(
          12,
          () => _plain(
            'I\'m the idle fox — your in-app guide for ${AppConstants.appName}. '
            'I explain screens and your stats; I don\'t replace your coach or log sets for you. '
            'Tap me anytime to chat; the small × on my corner turns me off in Settings.',
          ),
        ),
      if (_any(q, ['mascot', 'idle', 'remove fox', 'keep fox', 'disable fox']))
        _Candidate(
          14,
          () => _list([
            'Turn on: Profile → Settings → Idle fox mascot → Show idle fox',
            'Tap the fox → open/close this chat',
            'Fox × (top-right of mascot) → mascot off',
            'Chat × → closes chat only; fox stays',
          ]),
        ),
      if (_any(q, ['app name', 'what is this app', 'muscle builder', 'about app']))
        _Candidate(
          15,
          () => _plain(
            '${AppConstants.appName} is your mood-aware training companion: daily check-in, '
            'muscle-targeted workouts, Indian nutrition ideas, hydration, and progress — '
            'stored locally on this device.',
          ),
        ),
      if (_any(q, ['tab', 'navigate', 'navigation', 'bottom bar', 'screens', 'main tab']))
        _Candidate(
          14,
          () => _list([
            'Home — today\'s routine, hydration, check-in, plan summary',
            'Workout — open today\'s plan and run a live session',
            'Nutrition — pre/post workout fuel cards (tap to expand meals)',
            'Progress — stats, charts, day history, guides',
            'Profile — You (goals) + Settings (theme, fox, backup)',
          ]),
        ),
      if (_any(q, ['home', 'today', 'greeting']))
        _Candidate(
          13,
          () {
            final week = snap.workoutsThisWeek;
            final weekBit = week != null ? ' You\'ve logged $week workout(s) this week.' : '';
            return _plain(
              'Home is your dashboard: journey title, coach tip, weekly routine, '
              'hydration glass, and either today\'s plan or a check-in prompt.$weekBit '
              'Pull down to refresh.',
            );
          },
        ),
      if (_any(q, ['check-in', 'check in', 'mood', 'how feel', 'daily check']))
        _Candidate(
          14,
          () => snap.hasCheckInToday
              ? _plain(
                  'You\'ve already checked in today ✓ Your mood helped build today\'s plan '
                  'and the encouragement you\'ll see during sets.',
                )
              : _plain(
                  'No check-in yet today. On Home, open the mood check-in (tired, stressed, '
                  'energetic, etc.). That drives exercise selection and coach copy for the day.',
                ),
        ),
      if (_any(q, ['workout', 'gym', 'session', 'exercise', 'plan today', 'today plan']))
        _Candidate(
          15,
          () => _workoutReply(q, snap),
        ),
      if (_any(q, ['nutrition', 'meal', 'food', 'fuel', 'eat', 'protein', 'indian']))
        _Candidate(
          14,
          () => _plain(
            'Open the Nutrition tab for pre- and post-workout fuel cards with Indian-friendly '
            'meals. Tap a card to read macros and ideas. After check-in, your workout plan can '
            'surface linked pre/post meals on Home and Workout.',
          ),
        ),
      if (_any(q, ['progress', 'stats', 'sets', 'history', 'chart']))
        _Candidate(
          14,
          () => _progressReply(snap),
        ),
      if (_any(q, ['profile', 'settings', 'theme', 'color', 'birthday', 'about you']))
        _Candidate(
          14,
          () => _list([
            'Profile → You: name, birthday (auto age), goals, journey name',
            'Profile → Settings: accent color, light/dark, coach tone, weekly routine',
            'Settings → Idle fox mascot: show/hide me',
            'Profile → Backup: export/import your data file',
          ]),
        ),
      if (_any(q, ['backup', 'export', 'import', 'restore', 'save data']))
        _Candidate(
          13,
          () => _plain(
            'Profile tab → scroll to Backup → Export writes a JSON backup you can save '
            '(Files, Drive, etc.). Import on a new install restores workouts and profile. '
            'Nothing leaves your phone unless you share that file.',
          ),
        ),
      if (_any(q, ['hydration', 'water', 'drink']))
        _Candidate(
          12,
          () => _plain(
            'On Home, use the hydration card — tap the glass to add water for today. '
            'Progress shows recent hydration if you want trends.',
          ),
        ),
      if (_any(q, ['rest day', 'rest', 'cheat', 'skip']))
        _Candidate(
          12,
          () => snap.isRestLoggedToday
              ? _plain(
                  'Today is logged as a non-gym day, so Home may show a rest/cheat card '
                  'instead of the plan. You can still choose train anyway to bring the plan back.',
                )
              : _plain(
                  'From Home\'s routine section, log today as gym, rest, or cheat. '
                  'A rest day hides the workout plan unless you explicitly train anyway.',
                ),
        ),
      if (_any(q, ['coach', 'tone', 'encouragement', 'tough love', 'friendly']))
        _Candidate(
          12,
          () {
            final tone = snap.coachToneLabel;
            final yours = tone != null ? ' Your coach tone is "$tone".' : '';
            return _plain(
              'Profile → Settings → Coach personality: Tough love, Friendly, or Calm data.'
              '$yours That changes Home tips and messages when you finish a set.',
            );
          },
        ),
      if (_any(q, ['onboard', 'first time', 'getting started']))
        _Candidate(
          11,
          () => _list([
            'Complete onboarding (name, goals, preferences)',
            'Home → daily mood check-in',
            'Workout → open plan → Start session',
            'Log each set; Progress updates automatically',
          ]),
        ),
      if (_any(q, ['version', 'build', 'developer', 'who made']))
        _Candidate(
          10,
          () => _plain(
            snap.appVersion != null
                ? 'App version ${snap.appVersion}. ${AppConstants.buildVersionLabel(snap.appVersion!)}'
                : AppConstants.buildVersionLabel('1.0.0'),
          ),
        ),
      if (_any(q, ['help', 'how do i', 'how to', 'where']))
        _Candidate(
          9,
          () => _plain(
            'Tell me the goal in plain words — e.g. "change theme", "export backup", '
            '"start workout". I\'ll give the exact Profile/Settings path.',
          ),
        ),
      if (_any(q, [
        'weekly routine',
        'weekly pattern',
        'deload',
        'gym and rest',
        'edit my week',
      ]))
        _Candidate(
          13,
          () => _plain(
            'Profile → Settings → Weekly routine: set which days are gym, rest, or cheat, '
            'deload week toggle, and your repeat pattern. Home\'s routine card reflects what you log each day.',
          ),
        ),
      if (_any(q, ['start session', 'log sets', 'log reps', 'live session']))
        _Candidate(
          14,
          () => _plain(
            'Workout tab → open today\'s plan → Start session. Each exercise lets you log '
            'sets, reps, and RPE; Progress and Home update as you complete sets.',
          ),
        ),
    ];

    if (candidates.isEmpty) return null;
    candidates.sort((a, b) => b.score.compareTo(a.score));
    return candidates.first.build();
  }

  String _workoutReply(String q, FoxChatSnapshot snap) {
    if (_any(q, ['today', 'now', 'this morning'])) {
      if (snap.isRestLoggedToday) {
        return _plain(
          'Today is marked as rest on your routine log. Check Home for the rest card; '
          'use train anyway if you still want today\'s lifting plan.',
        );
      }
      if (snap.todaysExerciseCount != null) {
        final min = snap.todaysGymMinutes;
        final time = min != null ? ', about $min minutes planned' : '';
        final check = snap.hasCheckInToday
            ? ''
            : ' Finish mood check-in on Home first if it\'s still asking.';
        return _plain(
          'Today\'s plan: ${snap.todaysExerciseCount} exercises$time. '
          'Go Workout tab → today\'s plan → Start session to log sets.$check',
        );
      }
      return snap.hasCheckInToday
          ? _plain(
              'You checked in, but I don\'t see exercises loaded yet. Pull to refresh on Home '
              'or reopen the check-in flow.',
            )
          : _plain(
              'Start on Home with today\'s mood check-in — that generates your tailored workout plan.',
            );
    }
    final week = snap.workoutsThisWeek;
    final weekBit =
        week != null ? ' You have $week completed workout(s) this week.' : '';
    return _plain(
      'Workout tab lists today\'s plan in order. Open a session to log reps and RPE; '
      'Progress and Home stats update as you go.$weekBit',
    );
  }

  String _progressReply(FoxChatSnapshot snap) {
    final sets = snap.setsToday;
    if (sets != null && sets > 0) {
      return _plain(
        'You\'ve logged $sets set(s) today. Progress tab shows charts, per-day breakdowns, '
        'and Guides for training tips — tap any day for details.',
      );
    }
    return _plain(
      'Progress tab tracks completed workouts, set volume, hydration, and history. '
      'Open a date for a full day view, or Guides for exercise help.',
    );
  }

  bool _any(String q, List<String> needles) {
    for (final n in needles) {
      if (q.contains(n)) return true;
    }
    return false;
  }
}

class _Candidate {
  _Candidate(this.score, this.build);

  final int score;
  final String Function() build;
}
