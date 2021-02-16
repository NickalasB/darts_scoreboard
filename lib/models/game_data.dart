import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class GameData extends ChangeNotifier {
  static GameData of(BuildContext context, {bool listen = true}) =>
      Provider.of<GameData>(context, listen: listen);

  bool _weHaveAWinner = false;
  bool get weHaveAWinner => _weHaveAWinner;

  final List<Player> _players =
      List<Player>.generate(2, (i) => Player(name: 'Player $i'));

  UnmodifiableListView<Player> get players => UnmodifiableListView(_players);

  void add(Player player) {
    _players.add(player);
    notifyListeners();
  }

  void removeAll() {
    _players.clear();
    _players.addAll(List<Player>.generate(2, (i) => Player(name: 'Player $i')));
    notifyListeners();
  }

  void thereIsAWinner() {
    _weHaveAWinner = true;
    notifyListeners();
  }
}

class Player {
  Player({
    @required this.name,
    this.score = 0,
  });

  String name;
  int score;

  void setScore(int score) {
    this.score = score;
  }

  void setName(String name) {
    this.name = name;
  }

  @override
  bool operator ==(o) => o is Player && name == o.name && score == o.score;

  @override
  int get hashCode => name.hashCode ^ score.hashCode;
}
