/// screenx — Centralised responsive configuration for Flutter.
///
/// Provides adaptive breakpoints, scalable unit conversions, and
/// layout helpers across Android, iOS, and Web from a single entry
/// point.
///
/// ## Quick start
///
/// 1. Wrap your `MaterialApp` builder:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => ScreenXLayout(child: child!),
/// )
/// ```
///
/// 2. Use the static accessor anywhere:
///
/// ```dart
/// Text(
///   'Hello',
///   style: TextStyle(fontSize: ScreenX.sp(16)),
/// )
/// Container(
///   width: ScreenX.wp(80),
///   height: ScreenX.dp(48),
/// )
/// ```
///
/// 3. Build breakpoint-reactive subtrees:
///
/// ```dart
/// ScreenXBuilder(
///   builder: (context, bp) =>
///       bp.isMobile ? const MobileNav() : const DesktopNav(),
/// )
/// ```
library screenx;

export 'src/breakpoints.dart';
export 'src/responsive_builder.dart';
export 'src/responsive_layout.dart';
export 'src/screen_util.dart';
export 'src/screen_x.dart';
