import 'package:flutter/material.dart';
import 'package:screenx/screenx.dart';

void main() => runApp(const ScreenXExampleApp());

class ScreenXExampleApp extends StatelessWidget {
  const ScreenXExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'screenx example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // ── Single init: wrap MaterialApp.builder once ────────────────
      builder: (context, child) => ScreenXLayout(child: child!),
      home: const ExampleHome(),
    );
  }
}

// ── Home ──────────────────────────────────────────────────────────────────────

class ExampleHome extends StatelessWidget {
  const ExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'screenx demo',
          // sp() — scales with the user's system text-size preference
          style: TextStyle(fontSize: ScreenX.sp(20)),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenX.dp(16)),
        children: const [
          _CurrentBreakpointCard(),
          SizedBox(height: 16),
          _UnitConverterCard(),
          SizedBox(height: 16),
          _BuilderPatternCard(),
          SizedBox(height: 16),
          _SwitchPatternCard(),
          SizedBox(height: 16),
          _BreakpointReferenceCard(),
        ],
      ),
    );
  }
}

// ── Current breakpoint ────────────────────────────────────────────────────────

class _CurrentBreakpointCard extends StatelessWidget {
  const _CurrentBreakpointCard();

  @override
  Widget build(BuildContext context) {
    // ScreenXBuilder rebuilds only when the breakpoint tier changes.
    return ScreenXBuilder(
      builder: (context, bp) {
        final color = _tierColor(bp);
        return _Card(
          title: 'Active breakpoint',
          child: Row(
            children: [
              Container(
                width: ScreenX.dp(12),
                height: ScreenX.dp(12),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(width: ScreenX.dp(8)),
              Text(
                bp.tier.name.toUpperCase(),
                style: TextStyle(
                  fontSize: ScreenX.sp(28),
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Spacer(),
              Text(
                _tierDescription(bp),
                style: TextStyle(
                  fontSize: ScreenX.sp(14),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _tierColor(ScreenBreakpoint bp) {
    if (bp.isXS) return Colors.red;
    if (bp.isSM) return Colors.orange;
    if (bp.isMD) return Colors.amber;
    if (bp.isLG) return Colors.green;
    return Colors.indigo;
  }

  String _tierDescription(ScreenBreakpoint bp) {
    if (bp.isMobile) return 'mobile';
    if (bp.isTablet) return 'tablet';
    return 'desktop';
  }
}

// ── Unit converter showcase ───────────────────────────────────────────────────

class _UnitConverterCard extends StatelessWidget {
  const _UnitConverterCard();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return _Card(
      title: 'Unit converters',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Row('sp(16)', '${ScreenX.sp(16).toStringAsFixed(1)} px',
              'scales with text accessibility setting'),
          _Row('dp(16)', '${ScreenX.dp(16).toStringAsFixed(1)} px',
              'logical pixel pass-through'),
          _Row('wp(50)', '${ScreenX.wp(50).toStringAsFixed(1)} px',
              '50 % of ${width.toStringAsFixed(0)} px width'),
          _Row('hp(25)', '${ScreenX.hp(25).toStringAsFixed(1)} px',
              '25 % of ${height.toStringAsFixed(0)} px height'),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.method, this.value, this.description);
  final String method;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenX.dp(4)),
      child: Row(
        children: [
          SizedBox(
            width: ScreenX.wp(22),
            child: Text(
              method,
              style: TextStyle(
                fontSize: ScreenX.sp(13),
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: ScreenX.wp(18),
            child: Text(
              value,
              style: TextStyle(fontSize: ScreenX.sp(13)),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: ScreenX.sp(12),
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Builder pattern ───────────────────────────────────────────────────────────

class _BuilderPatternCard extends StatelessWidget {
  const _BuilderPatternCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'ScreenXBuilder — builder pattern',
      child: ScreenXBuilder(
        builder: (context, bp) {
          if (bp.isMobile) {
            return const _LayoutChip(
              label: 'Mobile layout',
              icon: Icons.phone_android,
              color: Colors.orange,
            );
          }
          if (bp.isTablet) {
            return const _LayoutChip(
              label: 'Tablet layout',
              icon: Icons.tablet,
              color: Colors.amber,
            );
          }
          return const _LayoutChip(
            label: 'Desktop layout',
            icon: Icons.desktop_mac,
            color: Colors.indigo,
          );
        },
      ),
    );
  }
}

class _LayoutChip extends StatelessWidget {
  const _LayoutChip({
    required this.label,
    required this.icon,
    required this.color,
  });
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenX.dp(16),
        vertical: ScreenX.dp(12),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ScreenX.dp(8)),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: ScreenX.dp(20)),
          SizedBox(width: ScreenX.dp(8)),
          Text(
            label,
            style: TextStyle(
              fontSize: ScreenX.sp(15),
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Switch pattern ────────────────────────────────────────────────────────────

class _SwitchPatternCard extends StatelessWidget {
  const _SwitchPatternCard();

  @override
  Widget build(BuildContext context) {
    return const _Card(
      title: 'ScreenXBuilder.switch_ — switch pattern',
      child: ScreenXBuilder.switch_(
        mobile: _SwitchChip(
          label: 'Single-column (mobile)',
          columns: 1,
          color: Colors.orange,
        ),
        tablet: _SwitchChip(
          label: 'Two-column (tablet)',
          columns: 2,
          color: Colors.amber,
        ),
        desktop: _SwitchChip(
          label: 'Three-column (desktop)',
          columns: 3,
          color: Colors.indigo,
        ),
      ),
    );
  }
}

class _SwitchChip extends StatelessWidget {
  const _SwitchChip({
    required this.label,
    required this.columns,
    required this.color,
  });
  final String label;
  final int columns;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: ScreenX.sp(14), color: color)),
        SizedBox(height: ScreenX.dp(8)),
        Row(
          children: List.generate(
            columns,
            (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: i < columns - 1 ? ScreenX.dp(8) : 0,
                ),
                height: ScreenX.dp(40),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(ScreenX.dp(6)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Breakpoint reference (five tiers side-by-side) ────────────────────────────

class _BreakpointReferenceCard extends StatelessWidget {
  const _BreakpointReferenceCard();

  static const _tiers = [
    _TierInfo('xs', '0 px', 'Phone', Colors.red),
    _TierInfo('sm', '480 px', 'Phone+', Colors.orange),
    _TierInfo('md', '768 px', 'Tablet', Colors.amber),
    _TierInfo('lg', '1024 px', 'Desktop', Colors.green),
    _TierInfo('xl', '1280 px', 'Wide', Colors.indigo),
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Breakpoint scale — resize to see active tier highlight',
      child: ScreenXBuilder(
        builder: (context, bp) {
          return Row(
            children: _tiers
                .map(
                  (t) => Expanded(
                    child: _TierCell(info: t, active: t.name == bp.tier.name),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _TierInfo {
  const _TierInfo(this.name, this.minWidth, this.label, this.color);
  final String name;
  final String minWidth;
  final String label;
  final Color color;
}

class _TierCell extends StatelessWidget {
  const _TierCell({required this.info, required this.active});
  final _TierInfo info;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: ScreenX.dp(2)),
      padding: EdgeInsets.symmetric(vertical: ScreenX.dp(10)),
      decoration: BoxDecoration(
        color: active ? info.color : info.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(ScreenX.dp(6)),
        border: Border.all(
          color: active ? info.color : info.color.withValues(alpha: 0.2),
          width: active ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            info.name,
            style: TextStyle(
              fontSize: ScreenX.sp(13),
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : info.color,
            ),
          ),
          SizedBox(height: ScreenX.dp(2)),
          Text(
            info.minWidth,
            style: TextStyle(
              fontSize: ScreenX.sp(9),
              color: active ? Colors.white70 : Colors.grey[500],
            ),
          ),
          SizedBox(height: ScreenX.dp(2)),
          Text(
            info.label,
            style: TextStyle(
              fontSize: ScreenX.sp(9),
              color: active ? Colors.white70 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared card shell ─────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenX.dp(12)),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: EdgeInsets.all(ScreenX.dp(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ScreenX.sp(12),
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: ScreenX.dp(12)),
            child,
          ],
        ),
      ),
    );
  }
}
