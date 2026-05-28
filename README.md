# screenx

[![pub.dev](https://img.shields.io/pub/v/screenx.svg)](https://pub.dev/packages/screenx)
[![pub points](https://img.shields.io/pub/points/screenx)](https://pub.dev/packages/screenx/score)
[![platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web-blue)](https://pub.dev/packages/screenx)
[![license](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![CI](https://github.com/Sam21-39/screenx/actions/workflows/ci.yaml/badge.svg)](https://github.com/Sam21-39/screenx/actions/workflows/ci.yaml)
[![Sponsor](https://img.shields.io/badge/Sponsor-Appamania-EA4AAA?style=flat&logo=buy-me-a-coffee&logoColor=white)](https://paywithchai.in/appamania)

Centralised responsive configuration for Flutter — adaptive breakpoints, scalable unit converters, and a zero-boilerplate layout widget that works across **Android, iOS, and Web** from a single entry point.

---

## Features

- **One-line setup** — wrap `MaterialApp.builder` once; everything else just works.
- **Five-tier breakpoint system** — `xs / sm / md / lg / xl` covering phones through wide desktops.
- **Static accessor** — use `ScreenX.sp()`, `ScreenX.dp()`, `ScreenX.wp()`, `ScreenX.hp()`, and `ScreenX.bp` anywhere, no `BuildContext` required.
- **Efficient rebuilds** — `ScreenXData` notifies descendants only when the breakpoint *tier* changes, not on every pixel of a window resize.
- **Builder widget** — `ScreenXBuilder` for full control, or `ScreenXBuilder.switch_` for discrete per-tier widgets.

---

## Getting started

Add the dependency:

```yaml
dependencies:
  screenx: ^1.0.0
```

Wrap your app **once**:

```dart
MaterialApp(
  builder: (context, child) => ScreenXLayout(child: child!),
  home: const MyHomePage(),
)
```

That's it. Every responsive value is now available anywhere in the tree.

---

## Usage

### Static accessor — no BuildContext needed

```dart
Text(
  'Hello',
  style: TextStyle(fontSize: ScreenX.sp(16)), // honours system text scale
)

Padding(
  padding: EdgeInsets.all(ScreenX.dp(16)),    // logical pixel pass-through
)

Container(
  width:  ScreenX.wp(80),   // 80 % of screen width
  height: ScreenX.hp(50),   // 50 % of screen height
)
```

### Breakpoint branching

```dart
if (ScreenX.bp.isMobile)  { /* xs or sm — < 768 px  */ }
if (ScreenX.bp.isTablet)  { /* md only  — 768–1023 px */ }
if (ScreenX.bp.isDesktop) { /* lg or xl — ≥ 1024 px */ }
if (ScreenX.bp.atLeastMD) { /* md, lg, or xl          */ }
```

### ScreenXBuilder — builder pattern

Rebuilds its subtree only when the breakpoint **tier** changes:

```dart
ScreenXBuilder(
  builder: (context, bp) {
    return bp.isMobile
        ? const MobileNav()
        : const DesktopNav();
  },
)
```

### ScreenXBuilder.switch\_ — discrete widgets per tier

At least `mobile` is required; `tablet` and `desktop` fall back to the nearest smaller tier when omitted:

```dart
ScreenXBuilder.switch_(
  mobile:  const MobileLayout(),
  tablet:  const TabletLayout(),
  desktop: const DesktopLayout(),
)
```

---

## Breakpoints

| Tier | Min width | Group   | Typical device                              |
|------|-----------|---------|---------------------------------------------|
| xs   | 0 px      | mobile  | Compact phones, older iPhones               |
| sm   | 480 px    | mobile  | Standard phones (majority of mobile users)  |
| md   | 768 px    | tablet  | Large phones, small tablets, foldables      |
| lg   | 1024 px   | desktop | Tablets, small desktop windows, iPad        |
| xl   | 1280 px   | desktop | Full desktop, wide browsers, TV screens     |

Boolean helpers on `ScreenBreakpoint`:

| Helper         | True when                   |
|----------------|-----------------------------|
| `isXS`         | tier == xs                  |
| `isSM`         | tier == sm                  |
| `isMD`         | tier == md                  |
| `isLG`         | tier == lg                  |
| `isXL`         | tier == xl                  |
| `isMobile`     | xs or sm                    |
| `isTablet`     | md only                     |
| `isDesktop`    | lg or xl                    |
| `atLeastSM`    | sm, md, lg, or xl           |
| `atLeastMD`    | md, lg, or xl               |
| `atLeastLG`    | lg or xl                    |
| `atMostSM`     | xs or sm                    |
| `atMostMD`     | xs, sm, or md               |

---

## API reference

### ScreenXLayout

```dart
ScreenXLayout({required Widget child})
```

Bootstrap widget. Place once inside `MaterialApp.builder`. Reacts automatically to orientation changes and window resizes.

### ScreenX (static accessor)

| Member        | Description                                                          |
|---------------|----------------------------------------------------------------------|
| `ScreenX.bp`  | Resolved `ScreenBreakpoint` for the current screen width.            |
| `ScreenX.sp(value)` | Scalable pixels — multiplied by the system text-scale. Use for font sizes. |
| `ScreenX.dp(value)` | Density-independent pixels — semantic pass-through. Use for padding, margins, borders. |
| `ScreenX.wp(percent)` | Percentage (0–100) of the current screen **width**.            |
| `ScreenX.hp(percent)` | Percentage (0–100) of the current screen **height**.           |

### ScreenXBuilder

```dart
// Builder pattern
ScreenXBuilder(builder: (BuildContext ctx, ScreenBreakpoint bp) => widget)

// Switch pattern
ScreenXBuilder.switch_({
  required Widget mobile,
  Widget? tablet,
  Widget? desktop,
})
```

---

## Platform support

| Android | iOS | Web |
|:-------:|:---:|:---:|
| ✅ | ✅ | ✅ |

---

## Example

A full runnable example is in the [`example/`](example/) directory. It demonstrates:

- Single `ScreenXLayout` initialisation
- `sp()` and `dp()` usage in typography and layout
- `ScreenXBuilder` builder pattern (mobile / tablet / desktop layouts)
- `ScreenXBuilder.switch_` switch pattern
- A live five-tier breakpoint reference that highlights the active tier as the window is resized

---

## Contributing

Contributions are welcome — open an issue before submitting a large PR.

- [Report a bug](https://github.com/Sam21-39/screenx/issues/new?template=bug_report.md)
- [Request a feature](https://github.com/Sam21-39/screenx/issues/new?template=feature_request.md)
- [Open a pull request](https://github.com/Sam21-39/screenx/pulls)

---

## Support

`screenx` is free and open source, built with ☕ by **Sumit Pal** ([@appamania](https://appamania.in)).

| Tier | Link | What it means |
|------|------|---------------|
| ☕ A sip of chai | [₹20](https://paywithchai.in/appamania) | You liked the package |
| 🍵 A full cup | [₹50](https://paywithchai.in/appamania) | It saved you real time |
| 🚀 Keep the lights on | [₹100](https://paywithchai.in/appamania) | You ship with it in prod |

[![Buy me a Chai](https://img.shields.io/badge/☕%20Buy%20me%20a%20Chai-FF5722?style=for-the-badge&logo=upi&logoColor=white)](https://paywithchai.in/appamania)

---

## Additional information

- Issue tracker: [github.com/Sam21-39/screenx/issues](https://github.com/Sam21-39/screenx/issues)
- API documentation: [pub.dev/documentation/screenx/latest](https://pub.dev/documentation/screenx/latest/)

---

## License

MIT © [Sumit Pal](https://appamania.in)
