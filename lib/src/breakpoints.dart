/// Breakpoint definitions and resolution for screenx.
library;

import 'package:flutter/foundation.dart';

/// The five breakpoint tiers used by screenx.
///
/// Breakpoints form a mobile-first, contiguous scale defined by
/// minimum logical-pixel width thresholds:
///
/// | Tier | Min width | Typical form factor                         |
/// |------|-----------|---------------------------------------------|
/// | xs   | 0 px      | Compact phones, older iPhones               |
/// | sm   | 480 px    | Standard phones (majority of mobile users)  |
/// | md   | 768 px    | Large phones, small tablets, foldables      |
/// | lg   | 1024 px   | Tablets, small desktop windows, iPad        |
/// | xl   | 1280 px   | Full desktop, wide browsers, TV screens     |
enum ScreenBreakpointTier {
  /// Extra-small: logical width < 480 px.
  xs,

  /// Small: logical width 480 – 767 px.
  sm,

  /// Medium: logical width 768 – 1 023 px.
  md,

  /// Large: logical width 1 024 – 1 279 px.
  lg,

  /// Extra-large: logical width ≥ 1 280 px.
  xl,
}

/// A resolved breakpoint descriptor produced by `ScreenXLayout`
/// after the current screen width has been measured.
///
/// Use the boolean helpers rather than comparing against
/// [ScreenBreakpointTier] values directly:
///
/// ```dart
/// if (ScreenX.bp.isMobile)   { ... }  // xs or sm
/// if (ScreenX.bp.atLeastMD)  { ... }  // md, lg, or xl
/// if (ScreenX.bp.isDesktop)  { ... }  // lg or xl
/// ```
///
/// A [ScreenBreakpoint] is resolved via [ScreenBreakpoint.new].
/// Two instances with the same [tier] compare equal.
@immutable
class ScreenBreakpoint {
  /// Resolves a [ScreenBreakpoint] from a logical [width] in dp.
  ///
  /// The active tier is the highest whose minimum threshold
  /// [width] meets or exceeds.
  ///
  /// ```dart
  /// // width < 480   → xs
  /// // width < 768   → sm
  /// // width < 1024  → md
  /// // width < 1280  → lg
  /// // width ≥ 1280  → xl
  /// ```
  const ScreenBreakpoint(double width)
      : tier = width >= 1280
            ? ScreenBreakpointTier.xl
            : width >= 1024
                ? ScreenBreakpointTier.lg
                : width >= 768
                    ? ScreenBreakpointTier.md
                    : width >= 480
                        ? ScreenBreakpointTier.sm
                        : ScreenBreakpointTier.xs;

  /// The active breakpoint tier.
  final ScreenBreakpointTier tier;

  // ── Exact tier checks ──────────────────────────────────────────

  /// `true` when the screen is in the **xs** tier (< 480 px).
  bool get isXS => tier == ScreenBreakpointTier.xs;

  /// `true` when the screen is in the **sm** tier (480 – 767 px).
  bool get isSM => tier == ScreenBreakpointTier.sm;

  /// `true` when the screen is in the **md** tier (768 – 1 023 px).
  bool get isMD => tier == ScreenBreakpointTier.md;

  /// `true` when the screen is in the **lg** tier (1 024 – 1 279 px).
  bool get isLG => tier == ScreenBreakpointTier.lg;

  /// `true` when the screen is in the **xl** tier (≥ 1 280 px).
  bool get isXL => tier == ScreenBreakpointTier.xl;

  // ── "At least" checks (mobile-first) ──────────────────────────

  /// `true` when the screen is **sm or wider** (≥ 480 px).
  bool get atLeastSM => tier.index >= ScreenBreakpointTier.sm.index;

  /// `true` when the screen is **md or wider** (≥ 768 px).
  bool get atLeastMD => tier.index >= ScreenBreakpointTier.md.index;

  /// `true` when the screen is **lg or wider** (≥ 1 024 px).
  bool get atLeastLG => tier.index >= ScreenBreakpointTier.lg.index;

  /// `true` when the screen is **xl** (≥ 1 280 px).
  bool get atLeastXL => tier.index >= ScreenBreakpointTier.xl.index;

  // ── "At most" checks ──────────────────────────────────────────

  /// `true` when the screen is **sm or narrower** (< 768 px).
  bool get atMostSM => tier.index <= ScreenBreakpointTier.sm.index;

  /// `true` when the screen is **md or narrower** (< 1 024 px).
  bool get atMostMD => tier.index <= ScreenBreakpointTier.md.index;

  // ── Convenience groups ─────────────────────────────────────────

  /// `true` for mobile form factors: **xs** or **sm** (< 768 px).
  bool get isMobile => tier.index <= ScreenBreakpointTier.sm.index;

  /// `true` for tablet form factors: exactly **md** (768 – 1 023 px).
  bool get isTablet => tier == ScreenBreakpointTier.md;

  /// `true` for desktop form factors: **lg** or **xl** (≥ 1 024 px).
  bool get isDesktop => tier.index >= ScreenBreakpointTier.lg.index;

  // ── Kept for backward compatibility ───────────────────────────

  /// Resolves a [ScreenBreakpoint] from a logical [width] in dp.
  ///
  /// Prefer the [ScreenBreakpoint.new] constructor directly.
  // ignore: prefer_constructors_over_static_methods
  static ScreenBreakpoint resolve(double width) => ScreenBreakpoint(width);

  @override
  String toString() => 'ScreenBreakpoint(${tier.name})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenBreakpoint &&
          runtimeType == other.runtimeType &&
          tier == other.tier;

  @override
  int get hashCode => tier.hashCode;
}
