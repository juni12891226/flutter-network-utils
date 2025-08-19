import 'dart:developer' as dev;

enum LogLevel { success, info, warning, error, debug }

/// Utility class for flexible debug logging in Flutter apps.
/// Runs only in debug mode via `assert`
/// Supports log levels, tags, and optional breakpoint for pausing execution.
class NetworkDebugUtils {
  static void debugLog(
    String message, {
    LogLevel logLevel = LogLevel.debug,
    bool breakPoint = false,
    String? tag,
  }) {
    assert(() {
      if (breakPoint) dev.debugger();
      _logMessage(message, logLevel: logLevel, tag: tag);
      return true;
    }());
  }

  static void _logMessage(
    String message, {
    required LogLevel logLevel,
    String? tag,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = logLevel.toString().split('.').last.toUpperCase();
    final effectiveTag = tag ?? 'TeCNetworkLayer-DebugUtils';
    final formattedMessage = '[$timestamp][$levelStr] $message';
    dev.log(
      formattedMessage,
      name: '$effectiveTag - @TeC-NetworkLayer 2025',
      level: _mapLogLevelToInt(logLevel),
    );
  }

  static int _mapLogLevelToInt(LogLevel level) {
    switch (level) {
      case LogLevel.success:
        return 850;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.debug:
        return 700;
    }
  }
}

// What does breakPoint: true do?
// It triggers a debugger breakpoint using:
//
// dart
// Copy
// Edit
// if (breakPoint) dev.debugger();
// ✅ This line:
// Calls debugger() from dart:developer
//
// Pauses execution if the debugger is attached
//
// Allows you to inspect variables, call stack, widget tree, etc.
//
// Only works in debug mode (since it’s wrapped in assert)
//
// 💡 Use case example:
// dart
// Copy
// Edit
// DebugUtils.debugLog(
// "This shouldn't happen!",
// logLevel: LogLevel.error,
// breakPoint: true,
// tag: "PaymentFlow"
// );
// When this code runs in debug mode, it will:
//
// Log the message with LogLevel.error
//
// Pause execution at that point
//
// Open the debug console or IDE breakpoint panel
//
// Let you inspect app state, variables, etc.
//
// ⚠️ Important Notes:
// debugger() has no effect in release or profile modes.
//
// If no debugger is connected, it does nothing.
//
// It’s safe to leave in code during dev, but remove or disable for production.
//
// ✅ Summary
// Parameter	Purpose
// message	The log content
// logLevel	Severity level (e.g. debug, error)
// tag	Optional tag to group logs
// breakPoint	Triggers a debugger pause in debug mode when true
//
// Use breakPoint: true like a temporary breakpoint without placing it in your IDE. It's excellent for catching logic bugs or unexpected states.
