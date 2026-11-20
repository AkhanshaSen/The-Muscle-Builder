/// Thrown when [SeedRepository] must load from Supabase but cannot.
class ReferenceDataUnavailableException implements Exception {
  ReferenceDataUnavailableException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => cause == null
      ? 'ReferenceDataUnavailableException: $message'
      : 'ReferenceDataUnavailableException: $message ($cause)';
}