/// Web-specific screen metric helpers for screenx.
///
/// This library is internal to screenx and is not part of the
/// public API.
library;

import 'package:flutter/widgets.dart';

/// Provides Web-specific corrections to raw screen metrics.
///
/// Accounts for:
/// - Browser viewport dimensions (excluding browser chrome such as
///   the address bar and bookmarks toolbar).
/// - Scrollbar width on desktop browsers (Flutter Web's
///   `LayoutBuilder` already excludes this from its constraints).
/// - Browser default font-size setting for text scaling.
final class WebMetrics {
  WebMetrics._();

  /// Returns the usable logical **width** for web.
  ///
  /// Flutter Web's `LayoutBuilder` constraints already represent
  /// the viewport content width (browser scrollbar width excluded),
  /// so [rawWidth] is returned as-is.
  static double usableWidth(BuildContext context, double rawWidth) => rawWidth;

  /// Returns the usable logical **height** for web.
  ///
  /// The Flutter Web viewport height excludes the browser chrome,
  /// so [rawHeight] is returned as-is.
  static double usableHeight(BuildContext context, double rawHeight) =>
      rawHeight;

  /// Returns the effective [TextScaler] for web.
  ///
  /// On web, scaling is derived from the browser's default font-size
  /// setting rather than an OS-level accessibility preference.
  /// Flutter surfaces this through [MediaQuery.textScalerOf].
  static TextScaler textScaler(BuildContext context) =>
      MediaQuery.textScalerOf(context);
}
