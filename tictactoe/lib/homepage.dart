// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

enum Difficuty { EASY, MEDIUM, HARD }

class HomePageState extends State<HomePage> {
  // Define Audio Players
  String HUMAN_PLAYER = "X";
  String COMPUTER_PLAYER = "O";
  String label = ' ';
  String _gameDif = 'EASY';

  var _gameDifficulty = 1;
  Future _settings(BuildContext context, String message) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select the Difficulty Level'),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('Easy'),
                onPressed: () {
                  Navigator.pop(context, Difficuty.EASY);
                },
              ),
              SimpleDialogOption(
                child: const Text('Medium'),
                onPressed: () {
                  Navigator.pop(context, Difficuty.MEDIUM);
                },
              ),
              SimpleDialogOption(
                child: const Text('Hard'),
                onPressed: () {
                  Navigator.pop(context, Difficuty.HARD);
                },
              ),
            ],
          );
        })) {
      case Difficuty.EASY:
        _gameDifficulty = 1;
        _gameDif = 'EASY';
        break;
      case Difficuty.MEDIUM:
        _gameDifficulty = 2;
        _gameDif = 'MEDIUM';
        break;
      case Difficuty.HARD:
        _gameDifficulty = 3;
        _gameDif = 'HARD';
        break;
    }
    print('The selection was Choice = $_gameDifficulty');
  }

  //other
  void _aboutDialog(BuildContext context, String message) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AboutDialog(
            applicationIcon: Image.asset(
              'assets/ttt_icon.png',
              height: 50,
              width: 50,
            ),
            applicationName: 'Tic Tac Toe',
            applicationVersion: '0.0.1',
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 15), child: Text(message))
            ],
          );
        });
  }

  String gameStatus = "X's Turn";
  static const BOARD_SIZE = 9;
  var hit = 0;
  var win = 0;
  var turn = 0;
  var mBoard = ["", "", "", "", "", "", "", "", ""];
  var rnd = Random(BOARD_SIZE);
  var mRand = Random();
  int humanScore = 0;
  int computerScore = 0;
  int tieScore = 0;
  late bool gameOver = false;

bool getWinningMove() {
  for (int i = 0; i < BOARD_SIZE; i++) {
    if (mBoard[i] != HUMAN_PLAYER && mBoard[i] != COMPUTER_PLAYER) {
      var curr = mBoard[i];
      mBoard[i] = COMPUTER_PLAYER;
      if (checkForWinner() == 3) {
        print("Computer is moving to ${i + 1}");
        return true;
      } else {
        mBoard[i] = curr;
      }
    }
  }
  return false;
}

bool getBlockingMove() {
  for (int i = 0; i < BOARD_SIZE; i++) {
    if (mBoard[i] != HUMAN_PLAYER && mBoard[i] != COMPUTER_PLAYER) {
      var curr = mBoard[i]; // Save the current value
      mBoard[i] = HUMAN_PLAYER;
      if (checkForWinner() == 2) {
        mBoard[i] = COMPUTER_PLAYER;
        print("Computer is moving to ${i + 1}");
        return true;
      } else {
        mBoard[i] = curr; // Restore the original value if not a blocking move
      }
    }
  }
  return false;
}

  void getRandomMove() {
    int move;
    int holder;
    do {
      move = mRand.nextInt(BOARD_SIZE);
    }
    //rando
    while (mBoard[move] == HUMAN_PLAYER || mBoard[move] == COMPUTER_PLAYER);
    holder = move + 1;
    print("Computer is moving to " '$holder');
    mBoard[move] = COMPUTER_PLAYER;
  }

void getComputerMove() {
  if (_gameDifficulty == 1) {
    getRandomMove();
  } //easy
  else if (_gameDifficulty == 2) {
    if (!getWinningMove()) {
      getRandomMove();
    }
  } //med
  else if (_gameDifficulty == 3) {
    if (!getWinningMove()) {
      if (!getBlockingMove()) {
        getRandomMove();
      }
    }
  } //hard
}

  int checkForWinner() {
    var replace = mBoard;
    for (int i = 0; i <= 6; i += 3) {
      if (mBoard[i] == HUMAN_PLAYER &&
          mBoard[i + 1] == HUMAN_PLAYER &&
          mBoard[i + 2] == HUMAN_PLAYER) return 2;

      if (mBoard[i] == COMPUTER_PLAYER &&
          mBoard[i + 1] == COMPUTER_PLAYER &&
          mBoard[i + 2] == COMPUTER_PLAYER) return 3;
    }

    for (int i = 0; i <= 2; i++) {
      if (mBoard[i] == HUMAN_PLAYER &&
          mBoard[i + 3] == HUMAN_PLAYER &&
          mBoard[i + 6] == HUMAN_PLAYER) return 2;

      if (mBoard[i] == COMPUTER_PLAYER &&
          mBoard[i + 3] == COMPUTER_PLAYER &&
          mBoard[i + 6] == COMPUTER_PLAYER) return 3;
    }

    if ((mBoard[0] == HUMAN_PLAYER &&
            mBoard[4] == HUMAN_PLAYER &&
            mBoard[8] == HUMAN_PLAYER) ||
        (mBoard[2] == HUMAN_PLAYER &&
            mBoard[4] == HUMAN_PLAYER &&
            mBoard[6] == HUMAN_PLAYER)) return 2;

    if ((mBoard[0] == COMPUTER_PLAYER &&
            mBoard[4] == COMPUTER_PLAYER &&
            mBoard[8] == COMPUTER_PLAYER) ||
        (mBoard[2] == COMPUTER_PLAYER &&
            mBoard[4] == COMPUTER_PLAYER &&
            mBoard[6] == COMPUTER_PLAYER)) return 3;

    for (int i = 0; i < BOARD_SIZE; i++) {
      if (!(replace[i] == HUMAN_PLAYER) && !(replace[i] == COMPUTER_PLAYER)) {
        return 0;
      }
    }

    return 1;
  }

  void checkGameStatus() {
    int winner = checkForWinner();
    if (winner != 0) {
      setState(() {
        gameOver = true;
        if (winner == 2) {
          gameStatus = "$HUMAN_PLAYER wins!";
          humanScore++;
        } else if (winner == 3) {
          gameStatus = "$COMPUTER_PLAYER wins!";
          computerScore++;
        } else {
          gameStatus = "It's a tie.";
          tieScore++;
        }
      });
  } else {
    int moveCount = mBoard.where((cell) => cell.isNotEmpty).length;
    setState(() {
      if (moveCount % 2 == 0) {
        gameStatus = "$HUMAN_PLAYER's Turn";
      } else {
        gameStatus = "$COMPUTER_PLAYER's Turn";
      }
    });
  }
}

  void newGame() {
    setState(() {
      _buttonsEnabled = true;
      mBoard = List.filled(9, "");
      gameOver = false;
      win = 0;
      turn = 0;
      gameStatus = "X's Turn";
    });
  }

  void _resetScores() {
    setState(() {
      humanScore = 0;
      computerScore = 0;
      tieScore = 0;
    });
  }

  // Methods to play sound files
  playLocalA() async {
    await playerA.play(AssetSource('sword.mp3'));
  }

  playLocalB() async {
    await playerB.play(AssetSource('swish.mp3'));
  }

  final playerA = AudioPlayer();
  final playerB = AudioPlayer();
  bool _buttonsEnabled = true;

  void showStatus(int win) {
    ('\n');
    if (win == 1) {
      gameOver = true;
      displayMessage("It's a tie.");
    } else if (win == 2) {
      gameOver = true;
      displayMessage("$HUMAN_PLAYER wins!");
    } else if (win == 3) {
      gameOver = true;
      displayMessage("$COMPUTER_PLAYER wins!");
    } else {
      displayMessage("There is a logic problem!");
    }
  }

void _buttonX(int index) {
  if (!_buttonsEnabled || gameOver || mBoard[index].isNotEmpty) return;

  setState(() {
    mBoard[index] = HUMAN_PLAYER;
    _buttonsEnabled = false;
  });

  playLocalA();
  checkGameStatus();

  if (!gameOver) {
    setState(() {
      // Disable all buttons during the computer's turn
      _buttonsEnabled = false;
    });

    // Use async/await instead of Future.delayed
    Future.delayed(const Duration(milliseconds: 1500), () {
       getComputerMove();
      playLocalB();
      setState(() {
        _buttonsEnabled = true;
      });
      checkGameStatus();
    });
  }
}

  void displayMessage(String text) {
    text = text;
    (text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              const Text("Tic Tac Toe", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.new_releases, color: Colors.white),
              tooltip: 'New Game',
              onPressed: () {
                newGame();
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              tooltip: 'Reset Game Scores',
              onPressed: () {
                _resetScores();
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Quit Game',
              onPressed: () => exit(0),
            ),
            PopupMenuButton<int>(
                onSelected: (result) {
                  if (result == 1) {
                    _aboutDialog(
                        context,
                        "This is a simple tic-tac-toe game for Android and iOS."
                        "The buttons represent the game board and a text widget displays the game status."
                        "Moves are represented by an X for the human player and an O for the computer.");
                  }
                  if (result == 2) {
                    _settings(context, "test2");
                  }
                },
                iconColor: Colors.white,
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Text(
                          "About",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Settings",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
          ]),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blueAccent,
                  content: Text(
                    _gameDif,
                    style: const TextStyle(color: Colors.white),
                  ),
                  action: SnackBarAction(
                    textColor: Colors.white,
                    label: 'OK',
                    onPressed: () {},
                  ),
                ),
              );
            });
      }),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildVerticalLayout()
              : _buildHorizontalLayout();
        },
      ),
    );
  }

  _buildVerticalLayout() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)));

    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
              height: 100.0,
              width: 100.0,
              color: Colors.teal,
              margin: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => _buttonX(0),
                style: style.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text(mBoard[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mBoard[0] == "X"
                          ? Colors.red
                          : mBoard[0] == "O"
                              ? Colors.green
                              : Colors.white,
                      fontSize: 80.0,
                      fontFamily: 'Roboto',
                    )),
              ),
            ),
            Container(
              height: 100.0,
              width: 100.0,
              color: Colors.teal,
              margin: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => _buttonX(1),
                style: style.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text(mBoard[1],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mBoard[1] == "X"
                          ? Colors.red
                          : mBoard[1] == "O"
                              ? Colors.green
                              : Colors.white,
                      fontSize: 80.0,
                      fontFamily: 'Roboto',
                    )),
              ),
            ),
            Container(
              height: 100.0,
              width: 100.0,
              color: Colors.teal,
              margin: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => _buttonX(2),
                style: style.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text(mBoard[2],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mBoard[2] == "X"
                          ? Colors.red
                          : mBoard[2] == "O"
                              ? Colors.green
                              : Colors.white,
                      fontSize: 80.0,
                      fontFamily: 'Roboto',
                    )),
              ),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
              height: 100.0,
              width: 100.0,
              color: Colors.teal,
              margin: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => _buttonX(3),
                style: style.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text(mBoard[3],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mBoard[3] == "X"
                          ? Colors.red
                          : mBoard[3] == "O"
                              ? Colors.green
                              : Colors.white,
                      fontSize: 80.0,
                      fontFamily: 'Roboto',
                    )),
              ),
            ),
            Container(
              height: 100.0,
              width: 100.0,
              color: Colors.teal,
              margin: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => _buttonX(4),
                style: style.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text(mBoard[4],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mBoard[4] == "X"
                          ? Colors.red
                          : mBoard[4] == "O"
                              ? Colors.green
                              : Colors.white,
                      fontSize: 80.0,
                      fontFamily: 'Roboto',
                    )),
              ),
            ),
            Container(
              height: 100.0,
              width: 100.0,
              color: Colors.teal,
              margin: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => _buttonX(5),
                style: style.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text(mBoard[5],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mBoard[5] == "X"
                          ? Colors.red
                          : mBoard[5] == "O"
                              ? Colors.green
                              : Colors.white,
                      fontSize: 80.0,
                      fontFamily: 'Roboto',
                    )),
              ),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
              height: 100.0,
              width: 100.0,
              color: Colors.teal,
              margin: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => _buttonX(6),
                style: style.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text(mBoard[6],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mBoard[6] == "X"
                          ? Colors.red
                          : mBoard[6] == "O"
                              ? Colors.green
                              : Colors.white,
                      fontSize: 80.0,
                      fontFamily: 'Roboto',
                    )),
              ),
            ),
            Container(
              height: 100.0,
              width: 100.0,
              color: Colors.teal,
              margin: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => _buttonX(7),
                style: style.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text(mBoard[7],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mBoard[7] == "X"
                          ? Colors.red
                          : mBoard[7] == "O"
                              ? Colors.green
                              : Colors.white,
                      fontSize: 80.0,
                      fontFamily: 'Roboto',
                    )),
              ),
            ),
            Container(
              height: 100.0,
              width: 100.0,
              color: Colors.teal,
              margin: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => _buttonX(8),
                style: style.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text(mBoard[8],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mBoard[8] == "X"
                          ? Colors.red
                          : mBoard[8] == "O"
                              ? Colors.green
                              : Colors.white,
                      fontSize: 80.0,
                      fontFamily: 'Roboto',
                    )),
              ),
            ),
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50.0,
                width: 300.0,
                margin: const EdgeInsets.all(10.0),
                child: Text(
                  gameStatus,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Text(
                  'Human: $humanScore', // Update this with the actual score
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Text(
                  'Computer: $computerScore', // Update this with the actual score
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Text(
                  'Tie: $tieScore', // Update this with the actual score
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ]));
  }

  _buildHorizontalLayout() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)));

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Tic Tac Toe Board - Left Side
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      color: Colors.teal,
                      margin: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () => _buttonX(0),
                        style: style.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        child: Text(mBoard[0],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mBoard[0] == "X"
                                  ? Colors.red
                                  : mBoard[0] == "O"
                                      ? Colors.green
                                      : Colors.white,
                              fontSize: 80.0,
                              fontFamily: 'Roboto',
                            )),
                      ),
                    ),
                    Container(
                      height: 100.0,
                      width: 100.0,
                      color: Colors.teal,
                      margin: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () => _buttonX(1),
                        style: style.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        child: Text(mBoard[1],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mBoard[1] == "X"
                                  ? Colors.red
                                  : mBoard[1] == "O"
                                      ? Colors.green
                                      : Colors.white,
                              fontSize: 80.0,
                              fontFamily: 'Roboto',
                            )),
                      ),
                    ),
                    Container(
                      height: 100.0,
                      width: 100.0,
                      color: Colors.teal,
                      margin: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () => _buttonX(2),
                        style: style.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        child: Text(mBoard[2],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mBoard[2] == "X"
                                  ? Colors.red
                                  : mBoard[2] == "O"
                                      ? Colors.green
                                      : Colors.white,
                              fontSize: 80.0,
                              fontFamily: 'Roboto',
                            )),
                      ),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      color: Colors.teal,
                      margin: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () => _buttonX(3),
                        style: style.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        child: Text(mBoard[3],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mBoard[3] == "X"
                                  ? Colors.red
                                  : mBoard[3] == "O"
                                      ? Colors.green
                                      : Colors.white,
                              fontSize: 80.0,
                              fontFamily: 'Roboto',
                            )),
                      ),
                    ),
                    Container(
                      height: 100.0,
                      width: 100.0,
                      color: Colors.teal,
                      margin: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () => _buttonX(4),
                        style: style.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        child: Text(mBoard[4],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mBoard[4] == "X"
                                  ? Colors.red
                                  : mBoard[4] == "O"
                                      ? Colors.green
                                      : Colors.white,
                              fontSize: 80.0,
                              fontFamily: 'Roboto',
                            )),
                      ),
                    ),
                    Container(
                      height: 100.0,
                      width: 100.0,
                      color: Colors.teal,
                      margin: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () => _buttonX(5),
                        style: style.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        child: Text(mBoard[5],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mBoard[5] == "X"
                                  ? Colors.red
                                  : mBoard[5] == "O"
                                      ? Colors.green
                                      : Colors.white,
                              fontSize: 80.0,
                              fontFamily: 'Roboto',
                            )),
                      ),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      color: Colors.teal,
                      margin: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () => _buttonX(6),
                        style: style.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        child: Text(mBoard[6],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mBoard[6] == "X"
                                  ? Colors.red
                                  : mBoard[6] == "O"
                                      ? Colors.green
                                      : Colors.white,
                              fontSize: 80.0,
                              fontFamily: 'Roboto',
                            )),
                      ),
                    ),
                    Container(
                      height: 100.0,
                      width: 100.0,
                      color: Colors.teal,
                      margin: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () => _buttonX(7),
                        style: style.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        child: Text(mBoard[7],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mBoard[7] == "X"
                                  ? Colors.red
                                  : mBoard[7] == "O"
                                      ? Colors.green
                                      : Colors.white,
                              fontSize: 80.0,
                              fontFamily: 'Roboto',
                            )),
                      ),
                    ),
                    Container(
                      height: 100.0,
                      width: 100.0,
                      color: Colors.teal,
                      margin: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () => _buttonX(8),
                        style: style.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        child: Text(mBoard[8],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mBoard[8] == "X"
                                  ? Colors.red
                                  : mBoard[8] == "O"
                                      ? Colors.green
                                      : Colors.white,
                              fontSize: 80.0,
                              fontFamily: 'Roboto',
                            )),
                      ),
                    ),
                  ]),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50.0,
                width: 300.0,
                margin: const EdgeInsets.all(10.0),
                child: Text(
                  gameStatus,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Text(
                  'Human: $humanScore', // Update this with the actual score
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Text(
                  'Computer: $computerScore', // Update this with the actual score
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: Text(
                  'Tie: $tieScore', // Update this with the actual score
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
