import 'dart:ui';

import 'package:darts_scoreboard/models/game_data.dart';
import 'package:darts_scoreboard/ui/player_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'animated_score_box.dart';

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
          PlayerName(widget.player),
          Text(
            widget.player.score.toString(),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          ...cricketPoints.map(
            (p) => AnimatedScoreBox(
              point: p,
              onScore: () => updateScore(p),
              onHit: ({point, hitCount}) => updateHits(
                point: point,
                hits: hitCount,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateScore(int point) {
    final newScore = widget.player.score + point;
    setState(() => widget.player.setScore(newScore));
  }

  void updateHits({@required int point, @required int hits}) {
    widget.player.setHits(point: point, hits: hits);

    if (cricketPoints
            .every((point) => widget.player.hitMap.containsKey(point)) &&
        widget.player.hitMap.values.every((hitCount) => hitCount == 3)) {
      GameData.of(context, listen: false).gameOver();
    }
  }
}
