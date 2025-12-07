import 'package:dio/dio.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

/// Helper class to extract user-friendly error messages from exceptions.
class ErrorMessageHelper {
  /// Gets a localized, user-friendly error message from an exception.
  /// 
  /// Handles DioException specifically for network errors, and provides
  /// generic fallback messages for other exceptions.
  static String getErrorMessage(Object error, AppLocalizations localizations) {
    if (error is DioException) {
      return _getDioErrorMessage(error, localizations);
    }
    
    // Generic error message for unknown exceptions
    return localizations.errorUnknown;
  }

  /// Gets a user-friendly message for a specific DioException.
  static String _getDioErrorMessage(
    DioException error,
    AppLocalizations localizations,
  ) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        // Check for specific connection error messages
        final message = error.message?.toLowerCase() ?? '';
        if (message.contains('failed host lookup') ||
            message.contains('no internet') ||
            message.contains('network is unreachable')) {
          return localizations.errorNoInternetConnection;
        }
        return localizations.errorConnectionFailed;

      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return localizations.errorConnectionFailed;

      case DioExceptionType.badResponse:
        // Server responded with error status code
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            return localizations.errorServerUnavailable;
          }
        }
        return localizations.errorConnectionFailed;

      case DioExceptionType.cancel:
        // Request was cancelled - usually not shown to user
        return localizations.errorConnectionFailed;

      case DioExceptionType.unknown:
        // Check error message for connection-related issues
        final message = error.message?.toLowerCase() ?? '';
        if (message.contains('failed host lookup') ||
            message.contains('no internet') ||
            message.contains('network') ||
            message.contains('connection')) {
          return localizations.errorNoInternetConnection;
        }
        return localizations.errorUnknown;

      default:
        return localizations.errorUnknown;
    }
  }

  /// Gets a specific error message for help request operations.
  static String getHelpRequestErrorMessage(
    Object error,
    AppLocalizations localizations,
  ) {
    final baseMessage = getErrorMessage(error, localizations);
    // If it's already a specific message, return it; otherwise use generic help error
    if (baseMessage == localizations.errorUnknown ||
        baseMessage == localizations.errorConnectionFailed) {
      return localizations.errorRequestHelpFailed;
    }
    return baseMessage;
  }

  /// Gets a specific error message for cancel help operations.
  static String getCancelHelpErrorMessage(
    Object error,
    AppLocalizations localizations,
  ) {
    final baseMessage = getErrorMessage(error, localizations);
    if (baseMessage == localizations.errorUnknown ||
        baseMessage == localizations.errorConnectionFailed) {
      return localizations.errorCancelHelpFailed;
    }
    return baseMessage;
  }

  /// Gets a specific error message for complete help operations.
  static String getCompleteHelpErrorMessage(
    Object error,
    AppLocalizations localizations,
  ) {
    final baseMessage = getErrorMessage(error, localizations);
    if (baseMessage == localizations.errorUnknown ||
        baseMessage == localizations.errorConnectionFailed) {
      return localizations.errorCompleteHelpFailed;
    }
    return baseMessage;
  }
}

