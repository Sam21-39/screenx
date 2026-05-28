# Changelog

All notable changes to **screenx** are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-05-28

### Added

- `ScreenXLayout` widget — single entry point for package initialisation.
  Place once inside `MaterialApp.builder`; all responsive values become
  available throughout the widget tree.
- `ScreenX` static accessor — provides `bp`, `sp()`, `dp()`, `wp()`, and
  `hp()` without requiring a `BuildContext`.
- `ScreenBreakpoint` — resolved breakpoint descriptor with boolean helpers
  (`isMobile`, `isTablet`, `isDesktop`, `atLeastMD`, …).
- `ScreenBreakpointTier` enum — five-tier mobile-first scale: `xs`, `sm`,
  `md`, `lg`, `xl`.
- `ScreenXData` — `InheritedWidget` that propagates breakpoint changes
  through the tree with zero unnecessary rebuilds.
- `ScreenXBuilder` — builder-pattern widget that rebuilds its subtree only
  when the active breakpoint tier changes.
- `ScreenXBuilder.switch_` constructor — discrete child widgets per
  breakpoint tier with automatic fallback to the nearest smaller tier.
- `ScreenUtil` — unit conversion engine:
  - `sp(value)` — scalable pixels accounting for system text-scale preference.
  - `dp(value)` — density-independent pixels for layout dimensions.
  - `wp(percent)` — percentage of current screen width.
  - `hp(percent)` — percentage of current screen height.
- Platform-specific metric adapters for Android, iOS, and Web (internal).
- Full dartdoc coverage on every public API member.
- ≥ 90 % unit and widget test coverage.
- Runnable example application in `example/`.
- GitHub Actions CI/CD:
  - `ci.yaml` — format, analyze, test, pana gate (≥ 110) on every PR to `develop`.
  - `release.yaml` — validate, pana gate (≥ 120), publish to pub.dev via OIDC, and create GitHub Release on `v*.*.*` tag push.

[Unreleased]: https://github.com/Sam21-39/screenx/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Sam21-39/screenx/releases/tag/v1.0.0
