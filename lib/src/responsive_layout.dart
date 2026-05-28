/// ScreenXLayout bootstrap widget and ScreenXData InheritedWidget.
library;

import 'package:flutter/material.dart';

import 'package:screenx/src/breakpoints.dart';
import 'package:screenx/src/responsive_builder.dart';
import 'package:screenx/src/screen_util.dart';
import 'package:screenx/src/screen_x.dart';

/// Initialises screenx and makes responsive values available to
/// the widget tree below it.
///
/// Place [ScreenXLayout] **once** inside the `builder` callback of
/// [MaterialApp] or [WidgetsApp], passing the framework-provided
/// child through unchanged:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => ScreenXLayout(child: child!),
///   home: const MyHomePage(),
/// )
/// ```
///
/// After the first build:
/// - The [ScreenX] static accessor is ready to use anywhere
///   (no [BuildContext] required).
/// - [ScreenXData] is inserted into the tree so that [ScreenXBuilder]
///   widgets rebuild automatically when the breakpoint tier changes.
///
/// [ScreenXLayout] reacts to orientation changes and window resizes
/// automatically — Flutter's [LayoutBuilder] triggers a rebuild
/// whenever the available constraints change.
class ScreenXLayout extends StatelessWidget {
  /// Creates a [ScreenXLayout].
  ///
  /// [child] is typically the Navigator provided by [MaterialApp]'s
  /// `builder` callback.
  const ScreenXLayout({required this.child, super.key});

  /// The subtree that gains access to [ScreenX] and [ScreenXData].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final bp = ScreenBreakpoint.resolve(constraints.maxWidth);
        final util = ScreenUtil(context: ctx, constraints: constraints);

        // Keep the static accessor in sync so code that doesn't
        // have a BuildContext can still read responsive values.
        ScreenX.update(bp, util);

        return ScreenXData(
          breakpoint: bp,
          util: util,
          child: child,
        );
      },
    );
  }
}

/// An [InheritedWidget] that carries the current [ScreenBreakpoint]
/// and [ScreenUtil] through the widget tree.
///
/// Inserted automatically by [ScreenXLayout]; you rarely need to
/// interact with [ScreenXData] directly. [ScreenXBuilder] depends
/// on it to trigger efficient, tier-scoped rebuilds.
///
/// Advanced consumers can read it via [ScreenXData.of]:
///
/// ```dart
/// final bp = ScreenXData.of(context).breakpoint;
/// ```
class ScreenXData extends InheritedWidget {
  /// Creates a [ScreenXData].
  ///
  /// [breakpoint] and [util] are computed by [ScreenXLayout] on
  /// each layout pass.
  const ScreenXData({
    required this.breakpoint,
    required this.util,
    required super.child,
    super.key,
  });

  /// The breakpoint resolved for the current screen width.
  final ScreenBreakpoint breakpoint;

  /// The unit-conversion helper for the current screen dimensions.
  final ScreenUtil util;

  /// Returns the nearest [ScreenXData] ancestor, or `null` if none
  /// exists.
  ///
  /// Calling this establishes a dependency: the widget calling
  /// [maybeOf] rebuilds whenever [ScreenXData.updateShouldNotify]
  /// returns `true`.
  static ScreenXData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScreenXData>();

  /// Returns the nearest [ScreenXData] ancestor.
  ///
  /// Throws an [AssertionError] in debug mode if no ancestor is
  /// found — which means [ScreenXLayout] is not in the tree above
  /// the calling widget.
  static ScreenXData of(BuildContext context) {
    final data = maybeOf(context);
    assert(
      data != null,
      'ScreenXData.of() called with a context that has no ScreenXData '
      'ancestor.\n'
      'Ensure ScreenXLayout wraps your app:\n'
      '\n'
      '  MaterialApp(\n'
      '    builder: (context, child) => ScreenXLayout(child: child!),\n'
      '  )\n',
    );
    return data!;
  }

  /// Notifies dependents only when the breakpoint **tier** changes —
  /// not on every pixel of window resize.
  ///
  /// This means [ScreenXBuilder] widgets remain idle while the user
  /// is resizing a browser window within the same tier, and only
  /// rebuild when the layout crosses a threshold.
  @override
  bool updateShouldNotify(ScreenXData oldWidget) =>
      breakpoint != oldWidget.breakpoint;
}
