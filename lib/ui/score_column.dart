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
    final gameData = GameData.of(context, listen: false);

    final playersWhoHaveClosedThisPoint = gameData.players.where((element) {
      return element.hitMap[point] == 3;
    });

    final canScore = playersWhoHaveClosedThisPoint.contains(widget.player) &&
        playersWhoHaveClosedThisPoint.length != gameData.players.length;

    if (canScore && !gameData.weHaveAWinner) {
      final newScore = widget.player.score + point;
      setState(() => widget.player.setScore(newScore));
    }
  }

  void updateHits({@required int point, @required int hits}) {
    final gameData = GameData.of(context, listen: false);

    widget.player.setHits(point: point, hits: hits);

    final doesHaveEveryPointClosed = cricketPoints
            .every((point) => widget.player.hitMap.containsKey(point)) &&
        widget.player.hitMap.values.every((hitCount) => hitCount == 3);

    final doesHaveHighScore = gameData.players
        .where((p) => p != widget.player)
        .map((e) => e.score)
        .every((s) => widget.player.score >= s);

    final gameIsOver = doesHaveEveryPointClosed && doesHaveHighScore;

    if (gameIsOver) {
      gameData.gameOver();
    }
  }
}
