abstract class CloudSyncPort {
  Future<void> syncProfile(Map<String, dynamic> profile);
  Future<void> syncSession(Map<String, dynamic> session);
  Future<void> pullRemote();
  Stream<bool> get isOnline;
}

/// No-op cloud sync placeholder. Swap for Firebase/Supabase later.
class NoOpCloudSync implements CloudSyncPort {
  @override
  Future<void> syncProfile(Map<String, dynamic> profile) async {}

  @override
  Future<void> syncSession(Map<String, dynamic> session) async {}

  @override
  Future<void> pullRemote() async {}

  @override
  Stream<bool> get isOnline => Stream.value(false);
}
