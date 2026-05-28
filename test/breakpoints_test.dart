// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:screenx/screenx.dart';

void main() {
  group('ScreenBreakpoint.resolve', () {
    test('returns xs for width 0', () {
      final bp = ScreenBreakpoint.resolve(0);
      expect(bp.tier, ScreenBreakpointTier.xs);
    });

    test('returns xs for width 479', () {
      final bp = ScreenBreakpoint.resolve(479);
      expect(bp.tier, ScreenBreakpointTier.xs);
    });

    test('returns sm at exact threshold 480', () {
      final bp = ScreenBreakpoint.resolve(480);
      expect(bp.tier, ScreenBreakpointTier.sm);
    });

    test('returns sm for width 767', () {
      final bp = ScreenBreakpoint.resolve(767);
      expect(bp.tier, ScreenBreakpointTier.sm);
    });

    test('returns md at exact threshold 768', () {
      final bp = ScreenBreakpoint.resolve(768);
      expect(bp.tier, ScreenBreakpointTier.md);
    });

    test('returns md for width 1023', () {
      final bp = ScreenBreakpoint.resolve(1023);
      expect(bp.tier, ScreenBreakpointTier.md);
    });

    test('returns lg at exact threshold 1024', () {
      final bp = ScreenBreakpoint.resolve(1024);
      expect(bp.tier, ScreenBreakpointTier.lg);
    });

    test('returns lg for width 1279', () {
      final bp = ScreenBreakpoint.resolve(1279);
      expect(bp.tier, ScreenBreakpointTier.lg);
    });

    test('returns xl at exact threshold 1280', () {
      final bp = ScreenBreakpoint.resolve(1280);
      expect(bp.tier, ScreenBreakpointTier.xl);
    });

    test('returns xl for very large width', () {
      final bp = ScreenBreakpoint.resolve(3840);
      expect(bp.tier, ScreenBreakpointTier.xl);
    });
  });

  group('ScreenBreakpoint — exact tier booleans', () {
    test('isXS true only for xs tier', () {
      expect(ScreenBreakpoint.resolve(320).isXS, isTrue);
      expect(ScreenBreakpoint.resolve(480).isXS, isFalse);
    });

    test('isSM true only for sm tier', () {
      expect(ScreenBreakpoint.resolve(600).isSM, isTrue);
      expect(ScreenBreakpoint.resolve(320).isSM, isFalse);
      expect(ScreenBreakpoint.resolve(768).isSM, isFalse);
    });

    test('isMD true only for md tier', () {
      expect(ScreenBreakpoint.resolve(900).isMD, isTrue);
      expect(ScreenBreakpoint.resolve(600).isMD, isFalse);
      expect(ScreenBreakpoint.resolve(1024).isMD, isFalse);
    });

    test('isLG true only for lg tier', () {
      expect(ScreenBreakpoint.resolve(1100).isLG, isTrue);
      expect(ScreenBreakpoint.resolve(900).isLG, isFalse);
      expect(ScreenBreakpoint.resolve(1280).isLG, isFalse);
    });

    test('isXL true only for xl tier', () {
      expect(ScreenBreakpoint.resolve(1440).isXL, isTrue);
      expect(ScreenBreakpoint.resolve(1100).isXL, isFalse);
    });
  });

  group('ScreenBreakpoint — atLeast booleans', () {
    test('atLeastSM is false for xs, true for sm+', () {
      expect(ScreenBreakpoint.resolve(320).atLeastSM, isFalse);
      expect(ScreenBreakpoint.resolve(480).atLeastSM, isTrue);
      expect(ScreenBreakpoint.resolve(1280).atLeastSM, isTrue);
    });

    test('atLeastMD is false for xs/sm, true for md+', () {
      expect(ScreenBreakpoint.resolve(600).atLeastMD, isFalse);
      expect(ScreenBreakpoint.resolve(768).atLeastMD, isTrue);
      expect(ScreenBreakpoint.resolve(1280).atLeastMD, isTrue);
    });

    test('atLeastLG is true only for lg and xl', () {
      expect(ScreenBreakpoint.resolve(900).atLeastLG, isFalse);
      expect(ScreenBreakpoint.resolve(1024).atLeastLG, isTrue);
      expect(ScreenBreakpoint.resolve(1280).atLeastLG, isTrue);
    });

    test('atLeastXL is true only for xl', () {
      expect(ScreenBreakpoint.resolve(1100).atLeastXL, isFalse);
      expect(ScreenBreakpoint.resolve(1280).atLeastXL, isTrue);
    });
  });

  group('ScreenBreakpoint — atMost booleans', () {
    test('atMostSM is true for xs/sm, false for md+', () {
      expect(ScreenBreakpoint.resolve(320).atMostSM, isTrue);
      expect(ScreenBreakpoint.resolve(600).atMostSM, isTrue);
      expect(ScreenBreakpoint.resolve(768).atMostSM, isFalse);
    });

    test('atMostMD is false for lg and xl', () {
      expect(ScreenBreakpoint.resolve(900).atMostMD, isTrue);
      expect(ScreenBreakpoint.resolve(1024).atMostMD, isFalse);
    });
  });

  group('ScreenBreakpoint — group helpers', () {
    test('isMobile is true for xs and sm only', () {
      expect(ScreenBreakpoint.resolve(320).isMobile, isTrue);
      expect(ScreenBreakpoint.resolve(600).isMobile, isTrue);
      expect(ScreenBreakpoint.resolve(768).isMobile, isFalse);
    });

    test('isTablet is true only for md', () {
      expect(ScreenBreakpoint.resolve(900).isTablet, isTrue);
      expect(ScreenBreakpoint.resolve(600).isTablet, isFalse);
      expect(ScreenBreakpoint.resolve(1024).isTablet, isFalse);
    });

    test('isDesktop is true for lg and xl', () {
      expect(ScreenBreakpoint.resolve(1100).isDesktop, isTrue);
      expect(ScreenBreakpoint.resolve(1440).isDesktop, isTrue);
      expect(ScreenBreakpoint.resolve(900).isDesktop, isFalse);
    });
  });

  group('ScreenBreakpoint — equality', () {
    test('two instances with the same tier are equal', () {
      expect(
        ScreenBreakpoint.resolve(320),
        equals(ScreenBreakpoint.resolve(400)),
      );
    });

    test('instances with different tiers are not equal', () {
      expect(
        ScreenBreakpoint.resolve(320),
        isNot(equals(ScreenBreakpoint.resolve(600))),
      );
    });

    test('hashCode is consistent with equality', () {
      expect(
        ScreenBreakpoint.resolve(320).hashCode,
        equals(ScreenBreakpoint.resolve(400).hashCode),
      );
    });
  });

  group('ScreenBreakpoint — toString', () {
    test('includes tier name', () {
      expect(ScreenBreakpoint.resolve(320).toString(), contains('xs'));
      expect(ScreenBreakpoint.resolve(1280).toString(), contains('xl'));
    });
  });
}
