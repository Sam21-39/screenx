/// Breakpoint-reactive builder widget for screenx.
library;

import 'package:flutter/widgets.dart';

import 'package:screenx/src/breakpoints.dart';
import 'package:screenx/src/responsive_layout.dart';

/// Rebuilds its subtree when the active [ScreenBreakpointTier]
/// changes, and only then — not on every pixel of window resize.
///
/// [ScreenXBuilder] depends on the nearest [ScreenXData] ancestor
/// inserted by [ScreenXLayout]. It must therefore be placed
/// somewhere below [ScreenXLayout] in the widget tree.
///
/// ## Builder pattern — full control
///
/// ```dart
/// ScreenXBuilder(
///   builder: (context, bp) {
///     return bp.isMobile
///         ? const MobileNav()
///         : const DesktopNav();
///   },
/// )
/// ```
///
/// ## Switch pattern — discrete widgets per tier
///
/// Use [ScreenXBuilder.switch_] when you want to hand a different
/// widget to each breakpoint group without writing conditional
/// logic yourself. At least `mobile` is required; `tablet` and
/// `desktop` fall back to the nearest smaller tier when omitted.
///
/// ```dart
/// ScreenXBuilder.switch_(
///   mobile:  const MobileNav(),
///   tablet:  const TabletNav(),
///   desktop: const DesktopNav(),
/// )
/// ```
class ScreenXBuilder extends StatelessWidget {
  /// Creates a [ScreenXBuilder] using a [builder] function.
  ///
  /// [builder] receives the current [BuildContext] and the
  /// resolved [ScreenBreakpoint] and must return a non-null widget.
  const ScreenXBuilder({
    required Widget Function(BuildContext, ScreenBreakpoint) builder,
    super.key,
  })  : _builder = builder,
        _mobile = null,
        _tablet = null,
        _desktop = null;

  /// Creates a [ScreenXBuilder] using discrete child widgets.
  ///
  /// [mobile] is required and is used as the ultimate fallback.
  /// [tablet] is shown for the `md` tier when provided.
  /// [desktop] is shown for `lg` and `xl` tiers when provided.
  const ScreenXBuilder.switch_({
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
    super.key,
  })  : _mobile = mobile,
        _tablet = tablet,
        _desktop = desktop,
        _builder = null;

  final Widget Function(BuildContext, ScreenBreakpoint)? _builder;
  final Widget? _mobile;
  final Widget? _tablet;
  final Widget? _desktop;

  @override
  Widget build(BuildContext context) {
    final bp = ScreenXData.of(context).breakpoint;

    // Assign to a local so Dart's flow analysis can narrow the type.
    final builder = _builder;
    if (builder != null) return builder(context, bp);

    // Switch pattern: fall back to nearest smaller tier.
    if (bp.isDesktop && _desktop != null) return _desktop!;
    if (bp.atLeastMD && _tablet != null) return _tablet!;
    return _mobile!;
  }
}
