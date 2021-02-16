import 'package:darts_scoreboard/models/game_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlayerName extends StatelessWidget {
  const PlayerName(this.player);

  final Player player;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        onChanged: player.setName,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
        decoration: InputDecoration(hintText: player.name),
      ),
    );
  }
}
