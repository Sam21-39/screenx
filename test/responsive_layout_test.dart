// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenx/screenx.dart';

/// Wraps [child] in the minimal scaffold needed for ScreenXLayout
/// to initialise — a [MaterialApp] with ScreenXLayout in builder.
Widget buildApp({required Widget child, Size size = const Size(390, 844)}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: MaterialApp(
      builder: (context, appChild) => ScreenXLayout(child: appChild!),
      home: child,
    ),
  );
}

void main() {
  group('ScreenXLayout — initialisation', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        buildApp(child: const Text('hello', textDirection: TextDirection.ltr)),
      );
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('ScreenXData is present below ScreenXLayout', (tester) async {
      late BuildContext capturedCtx;
      await tester.pumpWidget(
        buildApp(
          child: Builder(
            builder: (ctx) {
              capturedCtx = ctx;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(ScreenXData.maybeOf(capturedCtx), isNotNull);
    });

    testWidgets('ScreenX static accessor is populated after build',
        (tester) async {
      await tester.pumpWidget(
        buildApp(child: const SizedBox.shrink()),
      );
      // Should not throw.
      expect(() => ScreenX.bp, returnsNormally);
      expect(() => ScreenX.sp(16), returnsNormally);
      expect(() => ScreenX.dp(16), returnsNormally);
      expect(() => ScreenX.wp(50), returnsNormally);
      expect(() => ScreenX.hp(50), returnsNormally);
    });
  });

  group('ScreenXLayout — breakpoint resolution', () {
    testWidgets('resolves xs for 375 px width', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: MaterialApp(
            builder: (_, child) => ScreenXLayout(child: child!),
            home: Builder(
              builder: (ctx) {
                expect(ScreenXData.of(ctx).breakpoint.isXS, isTrue);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('resolves xl for 1440 px width', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1440, 900)),
          child: MaterialApp(
            builder: (_, child) => ScreenXLayout(child: child!),
            home: Builder(
              builder: (ctx) {
                expect(ScreenXData.of(ctx).breakpoint.isXL, isTrue);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  });

  group('ScreenXBuilder — builder pattern', () {
    testWidgets('calls builder with correct breakpoint', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      ScreenBreakpoint? receivedBp;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: MaterialApp(
            builder: (_, child) => ScreenXLayout(child: child!),
            home: ScreenXBuilder(
              builder: (_, bp) {
                receivedBp = bp;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(receivedBp, isNotNull);
      expect(receivedBp!.isMobile, isTrue);
    });
  });

  group('ScreenXBuilder.switch_ — switch pattern', () {
    testWidgets('shows mobile widget on narrow screen', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(390, 844)),
          child: MaterialApp(
            builder: (_, child) => ScreenXLayout(child: child!),
            home: ScreenXBuilder.switch_(
              mobile: const Text('mobile'),
              tablet: const Text('tablet'),
              desktop: const Text('desktop'),
            ),
          ),
        ),
      );

      expect(find.text('mobile'), findsOneWidget);
      expect(find.text('tablet'), findsNothing);
      expect(find.text('desktop'), findsNothing);
    });

    testWidgets('falls back to mobile when tablet/desktop not provided',
        (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1440, 900)),
          child: MaterialApp(
            builder: (_, child) => ScreenXLayout(child: child!),
            home: ScreenXBuilder.switch_(
              mobile: const Text('mobile'),
            ),
          ),
        ),
      );

      expect(find.text('mobile'), findsOneWidget);
    });
  });
}
