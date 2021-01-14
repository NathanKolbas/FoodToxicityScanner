import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as Vector;

// Gotta give credit where credit is due :)
// Great information and example code from https://github.com/nhancv/nc_flutter_util
class Waves extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Adjust this to change the size of the waves
    Size size = new Size(MediaQuery.of(context).size.width, 150.0);

    return Stack(
      children: <Widget>[
        new WavesBody(
          size: size,
          xOffset: 0,
          yOffset: 0,
          color: Colors.green.shade700,
          speed: 2500,
        ),
        new Opacity(
          opacity: 0.9,
          child: new WavesBody(
            size: size,
            xOffset: 80,
            yOffset: 10,
            color: Colors.green,
            speed: 2000,
          ),
        ),
      ],
    );
  }
}

class WavesBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;
  final int speed;

  WavesBody({
    Key key,
    @required
    this.size,
    this.xOffset,
    this.yOffset,
    this.color,
    this.speed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _WavesBodyState();
  }
}

class _WavesBodyState extends State<WavesBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: widget.speed)
    );

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset; i <= widget.size.width.toInt() + 2; i++) {
        animList1.add(
            new Offset(
                i.toDouble() + widget.xOffset,
                sin((animationController.value * 360 - i) % 360 * Vector.degrees2Radians)
                    * 20 + 50 + widget.yOffset));
      }
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      child: new AnimatedBuilder(
        animation: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => new ClipPath(
          child: new Container(
            width: widget.size.width,
            height: widget.size.height,
            color: widget.color,
          ),
          clipper: new WaveClipper(animationController.value, animList1),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;
  List<Offset> waveList1 = [];
  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.addPolygon(waveList1, false);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => animation != oldClipper.animation;
}