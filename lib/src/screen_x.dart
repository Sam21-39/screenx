/// Static accessor for screenx responsive values.
library;

import 'package:screenx/src/breakpoints.dart';
import 'package:screenx/src/screen_util.dart';

/// Global static accessor for all screenx responsive values.
///
/// All members become available after `ScreenXLayout` has been
/// built at least once. Accessing any member before that point
/// throws an [AssertionError] in debug mode; in release mode a
/// `LateInitializationError` is thrown by the `late` fields.
///
/// ## Usage
///
/// ```dart
/// // Typography — honours system text-scale preference
/// TextStyle(fontSize: ScreenX.sp(16))
///
/// // Layout — semantic pass-through for logical pixels
/// EdgeInsets.all(ScreenX.dp(16))
///
/// // Viewport-relative sizing
/// Container(width: ScreenX.wp(80), height: ScreenX.hp(50))
///
/// // Breakpoint branching
/// if (ScreenX.bp.isMobile) { ... }
/// if (ScreenX.bp.atLeastMD) { ... }
/// ```
///
/// [ScreenX] has no constructor; it cannot be instantiated.
abstract final class ScreenX {
  static late ScreenBreakpoint _bp;
  static late ScreenUtil _util;
  static bool _initialised = false;

  // ── Public accessors ──────────────────────────────────────────

  /// The resolved [ScreenBreakpoint] for the current screen size.
  ///
  /// Prefer the boolean helpers on [ScreenBreakpoint] over raw
  /// [ScreenBreakpointTier] comparisons:
  ///
  /// ```dart
  /// ScreenX.bp.isMobile   // xs or sm
  /// ScreenX.bp.atLeastMD  // md, lg, or xl
  /// ScreenX.bp.isDesktop  // lg or xl
  /// ```
  static ScreenBreakpoint get bp {
    _assertInitialised('bp');
    return _bp;
  }

  /// Converts [value] to **scalable pixels** (typography).
  ///
  /// Applies the user's system text-scale preference so fonts
  /// render at the intended optical size on every device.
  /// Always use [sp] for `TextStyle.fontSize`; never use [dp].
  ///
  /// ```dart
  /// TextStyle(fontSize: ScreenX.sp(14))
  /// ```
  static double sp(double value) {
    _assertInitialised('sp');
    return _util.sp(value);
  }

  /// Converts [value] to **density-independent pixels** (layout).
  ///
  /// Flutter already operates in logical pixels, so this is a
  /// semantic pass-through that documents intent clearly.
  /// Use for padding, margins, border widths, and fixed dimensions.
  ///
  /// ```dart
  /// Padding(padding: EdgeInsets.all(ScreenX.dp(16)))
  /// ```
  static double dp(double value) {
    _assertInitialised('dp');
    return _util.dp(value);
  }

  /// Returns [percent] % of the current screen **width**.
  ///
  /// [percent] must be in the range 0 – 100.
  ///
  /// ```dart
  /// Container(width: ScreenX.wp(90))
  /// ```
  static double wp(double percent) {
    _assertInitialised('wp');
    return _util.wp(percent);
  }

  /// Returns [percent] % of the current screen **height**.
  ///
  /// [percent] must be in the range 0 – 100.
  ///
  /// ```dart
  /// Container(height: ScreenX.hp(25))
  /// ```
  static double hp(double percent) {
    _assertInitialised('hp');
    return _util.hp(percent);
  }

  // ── Framework-internal ────────────────────────────────────────

  /// Updates the static state from a new `ScreenXLayout` build.
  ///
  /// Called automatically by `ScreenXLayout`; application code
  /// must not call this method directly.
  // ignore: use_setters_to_change_properties
  static void update(ScreenBreakpoint bp, ScreenUtil util) {
    _bp = bp;
    _util = util;
    _initialised = true;
  }

  // ── Helpers ───────────────────────────────────────────────────

  static void _assertInitialised(String member) {
    assert(
      _initialised,
      'ScreenX.$member was called before ScreenXLayout was built.\n'
      '\n'
      'Ensure ScreenXLayout wraps your app:\n'
      '\n'
      '  MaterialApp(\n'
      '    builder: (context, child) => ScreenXLayout(child: child!),\n'
      '  )\n',
    );
  }
}
