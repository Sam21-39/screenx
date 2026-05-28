/// iOS-specific screen metric helpers for screenx.
///
/// This library is internal to screenx and is not part of the
/// public API.
library;

import 'package:flutter/widgets.dart';

/// Provides iOS-specific corrections to raw screen metrics.
///
/// Accounts for:
/// - Safe-area insets from the notch (iPhone X and above).
/// - Dynamic Island region (iPhone 14 Pro and above).
/// - Home-indicator region at the bottom of notch-equipped devices.
/// - Dynamic Type scaling from iOS accessibility settings.
final class IOSMetrics {
  IOSMetrics._();

  /// Returns the usable logical **width** on iOS.
  ///
  /// Subtracts horizontal safe-area insets (left/right notch
  /// padding in landscape orientation) from [rawWidth].
  static double usableWidth(BuildContext context, double rawWidth) {
    final padding = MediaQuery.paddingOf(context);
    return rawWidth - padding.left - padding.right;
  }

  /// Returns the usable logical **height** on iOS.
  ///
  /// Subtracts the status-bar height (`padding.top`, which covers
  /// the notch / Dynamic Island) and the home-indicator height
  /// (`padding.bottom`) from [rawHeight].
  static double usableHeight(BuildContext context, double rawHeight) {
    final padding = MediaQuery.paddingOf(context);
    return rawHeight - padding.top - padding.bottom;
  }

  /// Returns the effective [TextScaler] for iOS.
  ///
  /// On iOS, Dynamic Type can produce scale factors well above 1.0.
  /// Flutter surfaces this through [MediaQuery.textScalerOf].
  static TextScaler textScaler(BuildContext context) =>
      MediaQuery.textScalerOf(context);
}
