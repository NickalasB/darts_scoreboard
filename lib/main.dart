import 'package:darts_scoreboard/models/game_data.dart';
import 'package:darts_scoreboard/ui/score_column.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => GameData(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dart Scoreboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: MyHomePage(),
        home: Container(
          color: Colors.white,
          child: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final gameData = GameData.of(context);
    if (gameData.weHaveAWinner) {
      print('winner');
    }

    return Scaffold(
      backgroundColor: Colors.grey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: gameData.players
                    .map((p) => Expanded(child: ScoreColumn(player: p)))
                    .toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: CricketButton(
                  label: 'ADD PLAYER',
                  onClick: gameData.players.length < 4
                      ? () {
                          gameData.add(Player(
                              name: 'Player ${gameData.players.length + 1}'));
                        }
                      : null,
                )),
                Expanded(
                  child: CricketButton(
                    label: 'UNDO',
                  ),
                ),
                Expanded(
                  child: CricketButton(
                    label: 'RESET',
                    onClick: () => gameData.resetGame(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CricketButton extends StatelessWidget {
  const CricketButton({this.label, this.onClick});

  final String label;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: onClick,
      child: Text(label),
    );
  }
}
