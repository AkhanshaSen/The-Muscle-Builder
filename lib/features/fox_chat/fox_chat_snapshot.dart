/// Live app facts the fox can weave into replies.
class FoxChatSnapshot {
  const FoxChatSnapshot({
    this.userName,
    this.journeyName,
    this.coachToneLabel,
    this.workoutsThisWeek,
    this.setsToday,
    this.hasCheckInToday = false,
    this.todaysExerciseCount,
    this.todaysGymMinutes,
    this.isRestLoggedToday = false,
    this.appVersion,
  });

  final String? userName;
  final String? journeyName;
  final String? coachToneLabel;
  final int? workoutsThisWeek;
  final int? setsToday;
  final bool hasCheckInToday;
  final int? todaysExerciseCount;
  final int? todaysGymMinutes;
  final bool isRestLoggedToday;
  final String? appVersion;

  String get firstName {
    final raw = userName?.trim();
    if (raw == null || raw.isEmpty) return 'friend';
    return raw.split(' ').first;
  }
}
