import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef HitCallback = Function({int point, int hitCount});

class AnimatedScoreBox extends StatefulWidget {
  const AnimatedScoreBox({this.point, this.onScore, this.onHit});

  final int point;
  final VoidCallback onScore;
  final HitCallback onHit;

  @override
  _AnimatedScoreBoxState createState() => _AnimatedScoreBoxState();
}

class _AnimatedScoreBoxState extends State<AnimatedScoreBox>
    with TickerProviderStateMixin {
  int hits = 0;
  int scoredPoints = 0;
  Paint pointPainter;

  final animationDuration = Duration(milliseconds: 250);
  double _progress = 0.0;
  double _progress2 = 0.0;
  double _progress3 = 0.0;

  Animation<double> animation1;
  Animation<double> animation2;
  Animation<double> animation3;

  AnimationController controller1;
  AnimationController controller2;
  AnimationController controller3;

  final lineTween = Tween(begin: 1.0, end: 0.0);
  final circleTween = Tween(begin: 0.0, end: 1.0);

  @override
  void initState() {
    super.initState();
    initializeAnimations();

    pointPainter = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  void initializeAnimations() {
    controller1 = AnimationController(duration: animationDuration, vsync: this);
    controller2 = AnimationController(duration: animationDuration, vsync: this);
    controller3 = AnimationController(duration: animationDuration, vsync: this);

    animation1 = lineTween.animate(controller1)
      ..addListener(() {
        setState(() {
          _progress = animation1.value;
        });
      });

    animation2 = lineTween.animate(controller2)
      ..addListener(() {
        setState(() {
          _progress2 = animation2.value;
        });
      });

    animation3 = circleTween.animate(controller3)
      ..addListener(() {
        setState(() {
          _progress3 = animation3.value;
        });
      });
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  void startAnimation(int hits) {
    if (hits == 1) {
      controller1.forward();
    }
    if (hits == 2) {
      controller2.forward();
    }
    if (hits == 3) {
      controller3.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            hits++;
            if (hits >= 4) {
              widget.onScore();
            } else {
              startAnimation(hits);
              widget.onHit(point: widget.point, hitCount: hits);
            }
          });
        },
        child: CustomPaint(
          painter: CricketPointPainter(
            pointPainter,
            hits,
            _progress,
            _progress2,
            _progress3,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                widget.point == 25 ? 'B' : widget.point.toString(),
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CricketPointPainter extends CustomPainter {
  const CricketPointPainter(
    this.pointPainter,
    this.hits,
    this.progress,
    this.progress2,
    this.progress3,
  );

  final Paint pointPainter;
  final int hits;
  final double progress;
  final double progress2;
  final double progress3;

  @override
  void paint(Canvas canvas, Size size) {
    final firstHitPath = Path()..lineTo(0, 0)..lineTo(size.width, size.height);

    final secondHitPath = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height);

    if (hits == 1) {
      canvas.drawLine(
        Offset(0.0, 0.0),
        Offset(size.width - size.width * progress,
            size.height - size.height * progress),
        pointPainter,
      );
    } else if (hits == 2) {
      canvas.drawPath(firstHitPath, pointPainter);
      canvas.drawLine(
        Offset(size.width, 0.0),
        Offset(size.width * progress2, size.height - size.height * progress2),
        pointPainter,
      );
    } else if (hits >= 3) {
      canvas.drawPath(firstHitPath, pointPainter);
      canvas.drawPath(secondHitPath, pointPainter);

      var rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: (size.height / 2) * .90,
      );

      canvas.drawArc(rect, -pi / 2, pi * 2 * progress3, false, pointPainter);
    }
  }

  @override
  bool shouldRepaint(CricketPointPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progress2 != progress2 ||
        oldDelegate.progress3 != progress3;
  }
}
