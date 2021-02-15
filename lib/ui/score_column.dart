import 'dart:ui';

import 'package:darts_scoreboard/ui/player_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'animated_score_box.dart';

const cricketPoints = [20, 19, 18, 17, 16, 15, 25];

class ScoreColumn extends StatefulWidget {
  const ScoreColumn({this.playerNumber});

  final int playerNumber;

  @override
  _ScoreColumnState createState() => _ScoreColumnState();
}

class _ScoreColumnState extends State<ScoreColumn> {
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
          PlayerName(widget.playerNumber),
          Text(totalScore.toString(),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ...cricketPoints
              .map((p) => AnimatedScoreBox(p, (score) {
                    setState(() => totalScore = totalScore + score);
                    return score;
                  }))
              .toList()
        ],
      ),
    );
  }
}
