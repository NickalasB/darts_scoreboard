import 'dart:math';
import 'dart:ui';

import 'package:darts_scoreboard/ui/player_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const cricketPoints = [20, 19, 18, 17, 16, 15, 25];
typedef ScoreCallback = Function(int);

class ScoreColumn extends StatefulWidget {
  const ScoreColumn();

  @override
  _ScoreColumnState createState() => _ScoreColumnState();
}

class _ScoreColumnState extends State<ScoreColumn> {
  final scoreCallBack = ScoreCallback;
  int totalScore = 0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const PlayerName(),
          Text(totalScore.toString(),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              )),
          ...cricketPoints
              .map(
                (p) => ScoreBox(p, (score) {
                  setState(() {
                    totalScore = totalScore + score;
                  });

                  return score;
                }),
              )
              .toList()
        ],
      ),
    );
  }
}

class ScoreBox extends StatefulWidget {
  const ScoreBox(this.point, this.score);

  final int point;
  final ScoreCallback score;

  @override
  _ScoreBoxState createState() => _ScoreBoxState();
}

class _ScoreBoxState extends State<ScoreBox>
    with SingleTickerProviderStateMixin {
  int hits = 0;
  int scoredPoints = 0;
  double _progress = 0.0;
  Paint pointPainter;

  final crossTween = Tween(begin: 1.0, end: 0.0);
  // TODO(me): The circle needs a 0 - 1 tween
  final circleTween = Tween(begin: 0.0, end: 1.0);

  Animation<double> animation1;

  AnimationController controller1;

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);

    animation1 = crossTween.animate(controller1)
      ..addListener(() {
        setState(() {
          _progress = animation1.value;
        });
      });

    pointPainter = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  void startAnimation() {
    controller1.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            hits++;
            if (hits >= 4) {
              widget.score(widget.point);
            } else {
              startAnimation();
            }
          });
        },
        child: CustomPaint(
          foregroundPainter: CricketPointPainter(pointPainter, hits, _progress),
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
  const CricketPointPainter(this.pointPainter, this.hits, this.progress);

  final Paint pointPainter;
  final int hits;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: (size.height / 2) * .90);

    final firstHitPath = Path()..lineTo(0, 0)..lineTo(size.width, size.height);

    final secondHitPath = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height);

    final thirdHitPath = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: (size.height / 2) * .90));

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
        Offset(size.width * progress, size.height - size.height * progress),
        pointPainter,
      );
    } else if (hits >= 3) {
      canvas.drawPath(firstHitPath, pointPainter);
      canvas.drawPath(secondHitPath, pointPainter);

      canvas.drawArc(rect, -pi / 2, pi * 2 * progress, false, pointPainter);

      // canvas.drawPath(thirdHitPath, pointPainter);
    }
  }

  @override
  bool shouldRepaint(CricketPointPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
