/// Base class for all handled failures inside NetSpeed.
///
/// Every exception carries a [messageKey] that maps directly to a key in
/// the localization ARB files, so the presentation layer never has to
/// guess how to translate a raw error string.
sealed class AppException implements Exception {
  const AppException(this.messageKey);

  final String messageKey;

  @override
  String toString() => 'AppException($messageKey)';
}

/// Thrown when the device has no usable internet connection
/// (either no network interface, or a network with no real internet
/// access behind it, e.g. a captive portal).
class NoInternetException extends AppException {
  const NoInternetException() : super('noInternetMessage');
}

/// Thrown when the speed test server could not be reached or selected.
class ServerUnavailableException extends AppException {
  const ServerUnavailableException() : super('serverErrorMessage');
}

/// Thrown when any phase of the test exceeds its allotted time.
class TestTimeoutException extends AppException {
  const TestTimeoutException() : super('timeoutErrorMessage');
}

/// Thrown when connectivity drops in the middle of a running test.
class ConnectionLostException extends AppException {
  const ConnectionLostException() : super('connectionLostMessage');
}

/// Thrown when the user explicitly cancels a running test.
class TestCancelledException extends AppException {
  const TestCancelledException() : super('testCancelledMessage');
}

/// Fallback for any unexpected/unclassified failure.
class UnknownTestException extends AppException {
  const UnknownTestException([this.detail]) : super('serverErrorMessage');

  final String? detail;
}
