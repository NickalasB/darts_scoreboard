import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlayerName extends StatelessWidget {
  const PlayerName(this.playerName);

  final String playerName;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
        decoration: InputDecoration(hintText: playerName),
      ),
    );
  }
}
