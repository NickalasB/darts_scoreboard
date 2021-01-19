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
  int numberOfPlayers = 0;
  List<Widget> playerColumns = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Cricket'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: playerColumns,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CricketButton(
                    label: 'ADD PLAYER',
                    onClick: numberOfPlayers < 4
                        ? () {
                            setState(() {
                              numberOfPlayers++;
                              playerColumns.add(
                                Expanded(
                                  child: ScoreColumn(
                                      playerNumber: numberOfPlayers),
                                ),
                              );
                            });
                          }
                        : null,
                  ),
                ),
                Expanded(
                  child: CricketButton(
                    label: 'UNDO',
                  ),
                ),
                Expanded(
                  child: CricketButton(
                    label: 'RESET',
                    onClick: () => setState(() {
                      playerColumns.clear();
                      playerColumns.addAll([
                        Expanded(child: const ScoreColumn(playerNumber: 1)),
                        Expanded(child: const ScoreColumn(playerNumber: 2)),
                      ]);
                      numberOfPlayers = playerColumns.length;
                    }),
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
