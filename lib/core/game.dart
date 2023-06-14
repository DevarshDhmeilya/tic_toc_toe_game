import 'package:flutter/material.dart';
import 'package:tic_toc_toe/core/widgets.dart';
import '../utils/structs.dart';
import '../utils/var.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const String p1 = "X", p2 = "O";
  late String currPlay;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currPlay = p1;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderText(curr: currPlay),
            GameContainer(state: context, used: occupied, onTap: _handleBoxTap),
            RestartButton(press: _handleRestartButtonPressed),
          ],
        ),
      ),
    );
  }

  void _handleBoxTap(int index) {
    if (gameEnd || occupied[index].isNotEmpty) {
      return;
    }

    setState(() {
      occupied[index] = currPlay;
      changeTurn();
      checkForWinner();
      checkForDraw();
    });
  }

  void _handleRestartButtonPressed() {
    setState(() {
      initializeGame();
    });
  }

  void changeTurn() {
    currPlay = (currPlay == p1) ? p2 : p1;
  }

  void checkForWinner() {
    for (var winningPos in winningList) {
      if (occupied[winningPos[0]].isNotEmpty &&
          occupied[winningPos[0]] == occupied[winningPos[1]] &&
          occupied[winningPos[0]] == occupied[winningPos[2]]) {
        showGameOverMessage("Player ${occupied[winningPos[0]]} Won");
        gameEnd = true;
        return;
      }
    }
  }

  void checkForDraw() {
    if (gameEnd) return;
    bool draw = occupied.every((occupiedP) => occupiedP.isNotEmpty);
    if (draw) {
      showGameOverMessage("Draw");
      gameEnd = true;
    }
  }

  void showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey,
        content: Text(message,
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
