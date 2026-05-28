// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenx/screenx.dart';

/// Pumps a widget that constructs a [ScreenUtil] inside a
/// [MediaQuery] with the given overrides, then calls [fn] with
/// the resulting [ScreenUtil].
Future<void> pumpUtil(
  WidgetTester tester, {
  required double width,
  required double height,
  required void Function(ScreenUtil) fn,
  TextScaler textScaler = TextScaler.noScaling,
}) async {
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: Size(width, height),
        textScaler: textScaler,
      ),
      child: Builder(
        builder: (context) {
          final util = ScreenUtil(
            context: context,
            constraints: BoxConstraints(maxWidth: width, maxHeight: height),
          );
          fn(util);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
}

void main() {
  group('ScreenUtil — screenWidth / screenHeight', () {
    testWidgets('exposes the constraint dimensions', (tester) async {
      await pumpUtil(
        tester,
        width: 390,
        height: 844,
        fn: (util) {
          expect(util.screenWidth, 390);
          expect(util.screenHeight, 844);
        },
      );
    });
  });

  group('ScreenUtil.sp', () {
    testWidgets('returns value unchanged when text scale is 1×',
        (tester) async {
      await pumpUtil(
        tester,
        width: 390,
        height: 844,
        fn: (util) => expect(util.sp(16), closeTo(16, 0.001)),
      );
    });

    testWidgets('scales up with 1.5× text scale factor', (tester) async {
      await pumpUtil(
        tester,
        width: 390,
        height: 844,
        textScaler: const TextScaler.linear(1.5),
        fn: (util) => expect(util.sp(16), closeTo(24, 0.001)),
      );
    });

    testWidgets('scales down with 0.8× text scale factor', (tester) async {
      await pumpUtil(
        tester,
        width: 390,
        height: 844,
        textScaler: const TextScaler.linear(0.8),
        fn: (util) => expect(util.sp(20), closeTo(16, 0.001)),
      );
    });

    testWidgets('returns zero for zero input', (tester) async {
      await pumpUtil(
        tester,
        width: 390,
        height: 844,
        fn: (util) => expect(util.sp(0), 0),
      );
    });
  });

  group('ScreenUtil.dp', () {
    testWidgets('is a semantic pass-through', (tester) async {
      await pumpUtil(
        tester,
        width: 390,
        height: 844,
        fn: (util) {
          expect(util.dp(16), 16);
          expect(util.dp(0), 0);
          expect(util.dp(100), 100);
        },
      );
    });
  });

  group('ScreenUtil.wp', () {
    testWidgets('returns correct percentage of screen width', (tester) async {
      await pumpUtil(
        tester,
        width: 400,
        height: 800,
        fn: (util) {
          expect(util.wp(100), 400);
          expect(util.wp(50), 200);
          expect(util.wp(25), 100);
          expect(util.wp(0), 0);
        },
      );
    });
  });

  group('ScreenUtil.hp', () {
    testWidgets('returns correct percentage of screen height', (tester) async {
      await pumpUtil(
        tester,
        width: 400,
        height: 800,
        fn: (util) {
          expect(util.hp(100), 800);
          expect(util.hp(50), 400);
          expect(util.hp(25), 200);
          expect(util.hp(0), 0);
        },
      );
    });
  });
}
