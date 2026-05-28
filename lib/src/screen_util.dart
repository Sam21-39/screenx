/// Unit conversion utilities for screenx.
library;

import 'package:flutter/widgets.dart';

import 'package:screenx/src/responsive_layout.dart';
import 'package:screenx/src/screen_x.dart';

/// Converts design-time values to runtime-appropriate logical pixel
/// values anchored to the current screen dimensions and the device's
/// accessibility settings.
///
/// Instances are created internally by [ScreenXLayout] on each build
/// and are not meant to be constructed directly by application code.
/// Access all conversions via the static [ScreenX] class instead.
class ScreenUtil {
  /// Creates a [ScreenUtil] from a [BuildContext] and
  /// [BoxConstraints].
  ///
  /// Reads [MediaQuery] data at construction time. Subsequent
  /// MediaQuery changes are reflected on the next [ScreenXLayout]
  /// rebuild (triggered automatically by orientation changes and
  /// window resizes).
  ScreenUtil({
    required BuildContext context,
    required BoxConstraints constraints,
  })  : _width = constraints.maxWidth,
        _height = constraints.maxHeight,
        _textScaler = MediaQuery.textScalerOf(context);

  final double _width;
  final double _height;
  final TextScaler _textScaler;

  /// The logical screen width in density-independent pixels.
  double get screenWidth => _width;

  /// The logical screen height in density-independent pixels.
  double get screenHeight => _height;

  /// Converts [value] to **scalable pixels**.
  ///
  /// Accounts for the user's system text-size preference
  /// (Android accessibility text scale, iOS Dynamic Type, browser
  /// default font size). Always use this for font sizes.
  ///
  /// ```dart
  /// Text('Hello', style: TextStyle(fontSize: ScreenX.sp(16)))
  /// ```
  double sp(double value) => _textScaler.scale(value);

  /// Converts [value] to **density-independent pixels**.
  ///
  /// Flutter already operates in logical pixels, so this is a
  /// semantic pass-through that communicates intent clearly.
  /// Use for padding, margin, border widths, and fixed dimensions.
  ///
  /// ```dart
  /// Padding(padding: EdgeInsets.all(ScreenX.dp(16)))
  /// ```
  // ignore: avoid_returning_this
  double dp(double value) => value;

  /// Returns [percent] % of the current screen **width**.
  ///
  /// [percent] must be in the range 0 – 100.
  ///
  /// ```dart
  /// Container(width: ScreenX.wp(80))   // 80 % of screen width
  /// ```
  double wp(double percent) => _width * percent / 100;

  /// Returns [percent] % of the current screen **height**.
  ///
  /// [percent] must be in the range 0 – 100.
  ///
  /// ```dart
  /// Container(height: ScreenX.hp(50))  // 50 % of screen height
  /// ```
  double hp(double percent) => _height * percent / 100;
}
