class AppConstants {
  static const appName = 'The Muscle Builder';
  static const defaultAccentHex = '#FF6B35';
  static const defaultJourneyName = 'My Journey';
  static const developerName = 'Akhansha Sen';
}

class EncouragementCopy {
  static String forMood({
    required String mood,
    required String tone,
    required String name,
  }) {
    final first = name.isEmpty ? 'champ' : name.split(' ').first;

    return switch ((mood, tone)) {
      ('tired', 'toughLove') =>
        'Tired or not, $first — you showed up. That\'s what separates builders from quitters.',
      ('tired', 'friendly') =>
        'Showing up today matters more than intensity, $first. Proud of you! 💪',
      ('tired', 'calmData') =>
        'Low-energy days still count toward consistency. Light volume is a smart call.',
      ('stressed', 'toughLove') =>
        'Channel the stress into the iron, $first. Leave it on the floor.',
      ('stressed', 'friendly') =>
        'A good session can reset your mind. You\'ve got this, $first!',
      ('stressed', 'calmData') =>
        'Moderate intensity with controlled breathing often reduces perceived stress.',
      ('low', 'toughLove') =>
        'Low days don\'t cancel progress. Show up. Do the work.',
      ('low', 'friendly') =>
        'Even a short session is a win when you\'re feeling low. I\'m cheering for you!',
      ('low', 'calmData') =>
        'Recovery-friendly volume today protects long-term adherence.',
      ('energetic', 'toughLove') =>
        'Energy\'s high — use it. Push with intent, $first.',
      ('energetic', 'friendly') =>
        'You\'re buzzing today! Let\'s make it a great session 🔥',
      ('energetic', 'calmData') =>
        'High energy supports progressive overload. Track RPE carefully.',
      ('motivated', 'toughLove') =>
        'Motivation fades. Discipline doesn\'t. Lock in, $first.',
      ('motivated', 'friendly') =>
        'Love that fire, $first! Let\'s turn motivation into muscle.',
      ('motivated', 'calmData') =>
        'High motivation is ideal for skill practice and progressive sets.',
      _ => 'Ready when you are, $first. Let\'s build.',
    };
  }

  static String tipOfDay(String tone) {
    return switch (tone) {
      'toughLove' => 'Excuses don\'t grow muscle. Sets do.',
      'friendly' => 'One more rep than yesterday is still progress!',
      'calmData' => 'Progressive overload + protein timing compounds over weeks.',
      _ => 'Consistency beats intensity over the long run.',
    };
  }

  static String forSetComplete({
    required int setNumber,
    required int totalSetsInSession,
    required String tone,
    required String name,
    required String verdictLabel,
  }) {
    final first = name.isEmpty ? 'champ' : name.split(' ').first;
    final milestone = totalSetsInSession == 1
        ? 'First set in the book'
        : totalSetsInSession % 5 == 0
            ? '$totalSetsInSession sets today — stacking wins'
            : 'Set $setNumber locked in';

    return switch (tone) {
      'toughLove' =>
        '$milestone, $first. $verdictLabel. Next set — no negotiation.',
      'calmData' =>
        '$milestone. Pace: $verdictLabel. $totalSetsInSession set(s) logged to Progress.',
      _ =>
        '$milestone! $verdictLabel. Progress updated — you\'ve got this, $first 💪',
    };
  }
}
