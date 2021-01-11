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
                    print('Nick total $totalScore');
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

class _ScoreBoxState extends State<ScoreBox> {
  int hits = 0;
  int scoredPoints = 0;

  @override
  void initState() {
    super.initState();
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
            }
          });
        },
        child: CustomPaint(
          painter: CricketPointPainter(hits),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.point.toString(),
                        style: TextStyle(fontSize: 48),
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        hits <= 3 ? hits.toString() : '3',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CricketPointPainter extends CustomPainter {
  const CricketPointPainter(this.hits);

  final int hits;

  @override
  void paint(Canvas canvas, Size size) {
    final pointPainter = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final firstStartingPoint = Offset(0, 0);
    final firstEndingPoint = Offset(size.width, size.height);

    final secondStartingPoint = Offset(size.width, 0);
    final secondEndingPoint = Offset(0, size.height);

    final center = Offset(size.width / 2, size.height / 2);

    if (hits == 1) {
      canvas.drawLine(firstStartingPoint, firstEndingPoint, pointPainter);
    } else if (hits == 2) {
      canvas.drawLine(firstStartingPoint, firstEndingPoint, pointPainter);
      canvas.drawLine(secondStartingPoint, secondEndingPoint, pointPainter);
    } else if (hits >= 3) {
      canvas.drawLine(firstStartingPoint, firstEndingPoint, pointPainter);
      canvas.drawLine(secondStartingPoint, secondEndingPoint, pointPainter);
      canvas.drawCircle(center, (size.height / 2) * .95, pointPainter);
    }
  }

  @override
  bool shouldRepaint(CricketPointPainter oldDelegate) {
    return false;
  }
}
