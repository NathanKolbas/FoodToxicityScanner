import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Credit where credit is due :) https://stackoverflow.com/questions/64224395/how-to-animate-line-draw-in-custom-painter-in-flutter
class SemicircleAnimatedPath extends StatefulWidget {
  final Color strokeColor;
  final double strokeWidth;

  SemicircleAnimatedPath({Key key, this.strokeColor, this.strokeWidth}) : super(key: key);

  @override
  _SemicircleAnimatedPathState createState() => _SemicircleAnimatedPathState();
}

class _SemicircleAnimatedPathState extends State<SemicircleAnimatedPath> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color strokeColor = widget.strokeColor ?? Colors.black;
    double strokeWidth = widget.strokeWidth ?? 10.0;

    return CustomPaint(
      painter: AnimatedPathPainter(_animation, strokeColor, strokeWidth),
      size: Size(250.0, 125.0),
    );
  }
}

class AnimatedPathPainter extends CustomPainter {
  final Animation<double> _animation;
  final Color _color;
  final double _strokeWidth;

  AnimatedPathPainter(this._animation, this._color, this._strokeWidth) : super(repaint: _animation);

  Path _createPath(Size size) {
    return Path()
    ..addArc(
      Rect.fromCenter(
        center: Offset(size.height, size.width / 2),
        height: size.height * 2,
        width: size.width,
      ),
      math.pi,
      math.pi
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final animationPercent = this._animation.value;

    final path = createAnimatedPath(_createPath(size), animationPercent);

    final Paint paint = Paint();
    paint.color = _color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = _strokeWidth;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Path createAnimatedPath(Path originalPath, double animationPercent) {
  // ComputeMetrics can only be iterated once!
  final totalLength = originalPath.computeMetrics().fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

  final currentLength = totalLength * animationPercent;

  return extractPathUntilLength(originalPath, currentLength);
}

Path extractPathUntilLength(Path originalPath, double length) {
  var currentLength = 0.0;

  final path = new Path();

  var metricsIterator = originalPath.computeMetrics().iterator;

  while (metricsIterator.moveNext()) {
    var metric = metricsIterator.current;

    var nextLength = currentLength + metric.length;

    final isLastSegment = nextLength > length;
    if (isLastSegment) {
      final remainingLength = length - currentLength;
      final pathSegment = metric.extractPath(0.0, remainingLength);

      path.addPath(pathSegment, Offset.zero);
      break;
    } else {
      // There might be a more efficient way of extracting an entire path
      final pathSegment = metric.extractPath(0.0, metric.length);
      path.addPath(pathSegment, Offset.zero);
    }

    currentLength = nextLength;
  }

  return path;
}

// Old code that was used to create the semicricle before figuring out out to animate it
// Could come in handy later

// class SemicirclePainter extends CustomPainter {
//   SemicirclePainter({@required this.color});
//   final Color color;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = color;
//     canvas.drawArc(
//       Rect.fromCenter(
//         center: Offset(size.height, size.width / 2),
//         height: size.height * 2,
//         width: size.width,
//       ),
//       math.pi,
//       math.pi,
//       false,
//       paint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
//
// class SemicircleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     return new Path()
//       ..addOval(new Rect.fromCircle(
//           center: new Offset(size.width / 2, size.height),
//           radius: size.width * 0.45))
//       ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height + 1))
//       ..fillType = PathFillType.evenOdd;
//   }
//
//   @override
//   bool shouldReclip(SemicircleClipper oldClipper) => true;
// }
