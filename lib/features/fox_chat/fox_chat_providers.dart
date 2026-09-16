import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import 'fox_chat_assistant.dart';
import 'fox_chat_history_store.dart';
import 'fox_chat_message.dart';
import 'fox_chat_snapshot.dart';

final foxChatAssistantProvider = Provider<FoxChatAssistant>(
  (ref) => const FoxChatAssistant(),
);

final foxChatHistoryStoreProvider = Provider<FoxChatHistoryStore>(
  (ref) => FoxChatHistoryStore(),
);

class FoxChatNotifier extends Notifier<List<FoxChatMessage>> {
  static const _assistant = FoxChatAssistant();

  FoxChatHistoryStore get _store => ref.read(foxChatHistoryStoreProvider);

  String? _sessionDay;
  var _loadedFromDisk = false;

  @override
  List<FoxChatMessage> build() => [];

  Future<void> _persist() async {
    await _store.saveToday(state);
  }

  /// Archives prior days and resets in-memory thread when the date changes.
  Future<void> _syncCalendarDay() async {
    await _store.rolloverIfNeeded(DateTime.now());
    final today = FoxChatHistoryStore.dayKey(DateTime.now());
    if (_sessionDay == today) return;
    _sessionDay = today;
    _loadedFromDisk = false;
    state = [];
  }

  /// New calendar day → fresh thread; same day → restore from disk.
  Future<void> ensureWelcome() async {
    await _syncCalendarDay();

    if (!_loadedFromDisk) {
      _loadedFromDisk = true;
      final saved = await _store.loadToday();
      if (saved.isNotEmpty) {
        state = saved;
        return;
      }
    }

    if (state.isNotEmpty) return;

    final snap = await _loadSnapshot();
    state = [
      FoxChatMessage(
        isUser: false,
        text: _assistant.welcome(snap),
        sentAt: DateTime.now(),
      ),
    ];
    await _persist();
  }

  Future<void> send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty) return;

    await _syncCalendarDay();

    final snap = await _loadSnapshot();
    final userMsg = FoxChatMessage(
      isUser: true,
      text: text,
      sentAt: DateTime.now(),
    );
    state = [...state, userMsg];
    await _persist();

    await Future<void>.delayed(const Duration(milliseconds: 420));

    final reply = _assistant.reply(text, snap);
    state = [
      ...state,
      FoxChatMessage(
        isUser: false,
        text: reply,
        sentAt: DateTime.now(),
      ),
    ];
    await _persist();
  }

  Future<FoxChatSnapshot> _loadSnapshot() async {
    final profile = ref.read(profileProvider).asData?.value;
    int? workouts;
    int? setsToday;
    try {
      workouts = await ref.read(workoutsThisWeekProvider.future);
    } catch (_) {}
    try {
      setsToday = await ref.read(setsTodayProvider.future);
    } catch (_) {}

    final checkIn = await ref.read(todaysCheckInProvider.future);
    final status = await ref.read(todayStatusProvider.future);
    final plan = status.plan;
    String? version;
    try {
      final info = await ref.read(packageInfoProvider.future);
      version = info.version;
    } catch (_) {}

    return FoxChatSnapshot(
      userName: profile?.name,
      journeyName: profile?.journeyName,
      coachToneLabel: profile?.coachTone.label,
      workoutsThisWeek: workouts,
      setsToday: setsToday,
      hasCheckInToday: checkIn != null,
      todaysExerciseCount: plan?.exercises.length,
      todaysGymMinutes: plan?.gymMinutes,
      isRestLoggedToday: status.isRestLogged,
      appVersion: version,
    );
  }
}

final foxChatProvider =
    NotifierProvider<FoxChatNotifier, List<FoxChatMessage>>(FoxChatNotifier.new);
