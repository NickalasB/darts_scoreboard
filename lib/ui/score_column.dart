import 'dart:ui';

import 'package:darts_scoreboard/models/game_data.dart';
import 'package:darts_scoreboard/ui/player_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'animated_score_box.dart';

const cricketPoints = [20, 19, 18, 17, 16, 15, 25];

class ScoreColumn extends StatefulWidget {
  const ScoreColumn({this.player});

  final Player player;

  @override
  _ScoreColumnState createState() => _ScoreColumnState();
}

class _ScoreColumnState extends State<ScoreColumn> {
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
          PlayerName(widget.player.name),
          Text(widget.player.score.toString(),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ...cricketPoints.map((p) => AnimatedScoreBox(p, () => updateScore(p)))
        ],
      ),
    );
  }

  void updateScore(int point) {
    final newScore = widget.player.score + point;
    setState(() => widget.player.setScore(newScore));
    // TODO(me): change this as it's just for demo purposes
    if (newScore == 60) {
      print('We have a winner');
      GameData.of(context, listen: false).thereIsAWinner();
    }
  }
}
