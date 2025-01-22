import 'package:flutter/widgets.dart';

/// A logger utility class for logging different levels of messages.
///
/// The `NaxaLibreLogger` class provides static methods to log messages with different severity levels:
/// success, error, warning, and general messages. These logs are formatted with emojis to visually
/// indicate the type of message in the debug console.
///
/// Methods:
/// - [logSuccess]: Logs a success message with a green checkmark emoji.
/// - [logError]: Logs an error message with a red cross emoji.
/// - [logWarning]: Logs a warning message with a yellow warning emoji.
/// - [logMessage]: Logs a general message with arrow symbols for clarity.

class NaxaLibreLogger {
  /// Logs a success message with a green checkmark emoji.
  ///
  /// The message is printed to the debug console with a success symbol (✅).
  static void logSuccess(dynamic message) {
    debugPrint('✅✅✅ ${message?.toString()} ✅✅✅');
  }

  /// Logs an error message with a red cross emoji.
  ///
  /// The message is printed to the debug console with an error symbol (❌).
  static void logError(dynamic message) {
    debugPrint('❌❌❌ ${message?.toString()} ❌❌❌');
  }

  /// Logs a warning message with a yellow warning emoji.
  ///
  /// The message is printed to the debug console with a warning symbol (⚠️).
  static void logWarning(dynamic message) {
    debugPrint('⚠️⚠️⚠️ ${message?.toString()} ⚠️⚠️⚠️');
  }

  /// Logs a general message with arrow symbols.
  ///
  /// The message is printed to the debug console with arrows pointing to and from the message (➡️⬅️).
  static void logMessage(dynamic message) {
    debugPrint('➡️➡️➡️ ${message?.toString()} ⬅️⬅️⬅️');
  }
}
