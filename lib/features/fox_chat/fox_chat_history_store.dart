import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'fox_chat_message.dart';

/// Persists fox chat by calendar day; archives past days locally.
class FoxChatHistoryStore {
  static const activeDateKey = 'fox_chat_active_date';
  static const todayMessagesKey = 'fox_chat_today_messages';
  static const archiveKey = 'fox_chat_archive';
  static const maxArchiveDays = 120;

  static String dayKey(DateTime dt) {
    final local = DateTime(dt.year, dt.month, dt.day);
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  /// If the calendar day changed, archive yesterday and clear today's slot.
  Future<void> rolloverIfNeeded(DateTime now) async {
    final prefs = await SharedPreferences.getInstance();
    final today = dayKey(now);
    final active = prefs.getString(activeDateKey);

    if (active != null && active != today) {
      final raw = prefs.getString(todayMessagesKey);
      if (raw != null && raw.isNotEmpty) {
        final messages = decodeMessages(raw);
        if (messages.isNotEmpty) {
          await _appendArchive(prefs, active, messages);
        }
      }
      await prefs.remove(todayMessagesKey);
    }

    await prefs.setString(activeDateKey, today);
  }

  Future<List<FoxChatMessage>> loadToday() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(todayMessagesKey);
    if (raw == null || raw.isEmpty) return [];
    return decodeMessages(raw);
  }

  Future<void> saveToday(List<FoxChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(todayMessagesKey, encodeMessages(messages));
  }

  /// All archived days (oldest → newest), for future UI / export.
  Future<Map<String, List<FoxChatMessage>>> loadArchive() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(archiveKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is! List) return {};
    final out = <String, List<FoxChatMessage>>{};
    for (final entry in decoded) {
      if (entry is! Map) continue;
      final day = entry['day'];
      final msgs = entry['messages'];
      if (day is! String || msgs is! List) continue;
      out[day] = msgs
          .whereType<Map>()
          .map(FoxChatMessage.fromJson)
          .where((m) => m.text.isNotEmpty)
          .toList();
    }
    return out;
  }

  static String encodeMessages(List<FoxChatMessage> messages) {
    return jsonEncode(messages.map((m) => m.toJson()).toList());
  }

  static List<FoxChatMessage> decodeMessages(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map(FoxChatMessage.fromJson)
          .where((m) => m.text.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _appendArchive(
    SharedPreferences prefs,
    String day,
    List<FoxChatMessage> messages,
  ) async {
    final existing = await loadArchive();
    existing[day] = messages;
    final keys = existing.keys.toList()..sort();
    while (keys.length > maxArchiveDays) {
      existing.remove(keys.removeAt(0));
    }
    final payload = keys
        .map(
          (d) => {
            'day': d,
            'messages': existing[d]!.map((m) => m.toJson()).toList(),
          },
        )
        .toList();
    await prefs.setString(archiveKey, jsonEncode(payload));
  }
}
