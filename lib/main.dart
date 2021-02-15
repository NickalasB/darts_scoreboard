import 'package:darts_scoreboard/ui/score_column.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
  int numberOfPlayers = 2;

  @override
  Widget build(BuildContext context) {
    List playerColumns(int playerCount) => List<Widget>.generate(
          playerCount,
          (i) => Expanded(child: ScoreColumn(playerNumber: i)),
        );

    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: playerColumns(numberOfPlayers),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: CricketButton(
                  label: 'ADD PLAYER',
                  onClick: numberOfPlayers < 4
                      ? () {
                          setState(() => numberOfPlayers++);
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
                    onClick: () => setState(() => numberOfPlayers = 2),
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
