/// Android-specific screen metric helpers for screenx.
///
/// This library is internal to screenx and is not part of the
/// public API.
library;

import 'package:flutter/widgets.dart';

/// Provides Android-specific corrections to raw screen metrics.
///
/// Accounts for:
/// - Navigation bar height differences between gesture navigation
///   (Android 10+, swipe-based) and three-button navigation.
/// - Status bar height offsets in edge-to-edge mode.
/// - Text scale factor from Android accessibility settings.
final class AndroidMetrics {
  AndroidMetrics._();

  /// Returns the usable logical **width** on Android.
  ///
  /// `LayoutBuilder` constraints on Android already represent the
  /// content area width (horizontal insets are zero on portrait
  /// phones), so [rawWidth] is returned as-is.
  static double usableWidth(BuildContext context, double rawWidth) => rawWidth;

  /// Returns the usable logical **height** on Android.
  ///
  /// Subtracts the system status bar (`padding.top`) and
  /// navigation bar (`padding.bottom`) so that `hp()` percentages
  /// are relative to the actual content area rather than the full
  /// display height.
  static double usableHeight(BuildContext context, double rawHeight) {
    final padding = MediaQuery.paddingOf(context);
    return rawHeight - padding.top - padding.bottom;
  }

  /// Returns the effective text scale factor for Android.
  ///
  /// Reads the user's font-size preference from Android
  /// accessibility settings via Flutter's [MediaQuery.textScalerOf].
  static TextScaler textScaler(BuildContext context) =>
      MediaQuery.textScalerOf(context);
}
