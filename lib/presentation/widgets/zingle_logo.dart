import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ZingleLogo extends StatelessWidget {
  const ZingleLogo({super.key, this.size = 96, this.showBadge = true});

  final double size;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF151022) : Colors.white,
          borderRadius: BorderRadius.circular(size * .22),
          boxShadow: [
            BoxShadow(
              blurRadius: size * .22,
              offset: Offset(0, size * .08),
              color: AppTheme.purple.withValues(alpha: .24),
            ),
          ],
        ),
        child: CustomPaint(painter: _LogoPainter(showBadge: showBadge)),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({required this.showBadge});

  final bool showBadge;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE7A7FF), AppTheme.purple, Color(0xFF4C1D95)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    final stem = Path()
      ..moveTo(size.width * .34, size.height * .68)
      ..lineTo(size.width * .34, size.height * .40)
      ..lineTo(size.width * .78, size.height * .30)
      ..quadraticBezierTo(size.width * .86, size.height * .32, size.width * .80, size.height * .42)
      ..lineTo(size.width * .52, size.height * .48)
      ..lineTo(size.width * .52, size.height * .68);
    canvas.drawPath(stem, paint);
    canvas.drawCircle(Offset(size.width * .34, size.height * .72), size.width * .13, paint);
    for (final x in [.18, .23, .82, .87]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(size.width * x, size.height * .52), width: size.width * .035, height: size.height * .22),
          const Radius.circular(8),
        ),
        paint,
      );
    }
    if (showBadge) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'Z',
          style: TextStyle(color: Colors.white, fontSize: size.width * .2, fontWeight: FontWeight.w900),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(size.width * .60, size.height * .52));
    }
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => oldDelegate.showBadge != showBadge;
}
