// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stateless App Template',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // Define Audio Players
  final playerA = AudioPlayer();
  final playerB = AudioPlayer();

  // Methods to play sound files
  playLocalA() async {
    await playerA.play(AssetSource('sword.mp3'));
  }

  playLocalB() async {
    await playerB.play(AssetSource('swish.mp3'));
  }

  static const String HUMAN_PLAYER = "X";
  static const String COMPUTER_PLAYER = "O";
  static const BOARD_SIZE = 9;
  bool gameOver = false;
  var win = 0;
  var turn = 0;
  List<String> mBoard = ["", "", "", "", "", "", "", "", ""];
  var rnd = Random();
  String gameStatus = "X's Turn";
  int humanScore = 0;
  int computerScore = 0;
  int tieScore = 0;
  bool _buttonsEnabled =true;

  @override
  void initState() {
    super.initState();
  }

  void _resetScores() {
    setState(() {
      humanScore = 0;
      computerScore = 0;
      tieScore = 0;
    });
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
      setState(() {
        gameStatus = turn % 2 == 0 ? "X's Turn" : "O's Turn";
      });
    }
  }

  

  void getComputerMove() {
    if (gameOver) return;

    for (int i = 0; i < BOARD_SIZE; i++) {
      if (mBoard[i].isEmpty) {
        mBoard[i] = COMPUTER_PLAYER;
        if (checkForWinner() == 3) {
          setState(() {
            gameOver = true;
            gameStatus = "$COMPUTER_PLAYER wins!";
            computerScore++;
          });
          return;
        } else {
          mBoard[i] = "";
        }
      }
    }

    for (int i = 0; i < BOARD_SIZE; i++) {
      if (mBoard[i].isEmpty) {
        mBoard[i] = HUMAN_PLAYER;
        if (checkForWinner() == 2) {
          setState(() {
            mBoard[i] = COMPUTER_PLAYER;
            gameStatus = "X's Turn";
          });
          return;
        } else {
          mBoard[i] = "";
        }
      }
    }

    List<int> emptySpots = [];
    for (int i = 0; i < BOARD_SIZE; i++) {
      if (mBoard[i].isEmpty) {
        emptySpots.add(i);
      }
    }
    
    if (emptySpots.isNotEmpty) {
      int move = emptySpots[Random().nextInt(emptySpots.length)];
      
      setState(() {
        
        mBoard[move] = COMPUTER_PLAYER;

        if (checkForWinner() != 3) {
          gameStatus = "X's Turn";
        }
      });
    }
  }

  int checkForWinner() {
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
      if (!(mBoard[i] == HUMAN_PLAYER) && !(mBoard[i] == COMPUTER_PLAYER)) {
        return 0;
      }
    }

    return 1;
  }

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

  void _button0() {
    if (!_buttonsEnabled || gameOver || mBoard[0] != "") return;

    setState(() {
      mBoard[0] = HUMAN_PLAYER;
      
      _buttonsEnabled = false;
    });

    playLocalA();

    checkGameStatus();

  if (!gameOver) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      getComputerMove();
      playLocalB();
      setState(() {
        _buttonsEnabled = true; // Enable the buttons after the computer's move
      });
    });
  }
}

  void _button1() {
    if (!_buttonsEnabled || gameOver || mBoard[1] != "") return;

    setState(() {
      mBoard[1] = HUMAN_PLAYER;
      
      _buttonsEnabled = false;
    });

    playLocalA();

    checkGameStatus();

  if (!gameOver) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      getComputerMove();
      playLocalB();
      setState(() {
        _buttonsEnabled = true; // Enable the buttons after the computer's move
      });
    });
  }
}

  void _button2() {
    if (!_buttonsEnabled || gameOver || mBoard[2] != "") return;

    setState(() {
      mBoard[2] = HUMAN_PLAYER;
    
      _buttonsEnabled = false;
    });

    playLocalA();

    checkGameStatus();

  if (!gameOver) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      getComputerMove();
      playLocalB();
      setState(() {
        _buttonsEnabled = true; // Enable the buttons after the computer's move
      });
    });
  }
}

  void _button3() {
    if (!_buttonsEnabled || gameOver || mBoard[3] != "") return;

    setState(() {
      mBoard[3] = HUMAN_PLAYER;
      
      _buttonsEnabled = false;
    });

    playLocalA();

    checkGameStatus();

  if (!gameOver) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      getComputerMove();
      playLocalB();
      setState(() {
        _buttonsEnabled = true; // Enable the buttons after the computer's move
      });
    });
  }
}

  void _button4() {
    if (!_buttonsEnabled || gameOver || mBoard[4] != "") return;

    setState(() {
      mBoard[4] = HUMAN_PLAYER;
      
      _buttonsEnabled = false;
    });

    playLocalA();

    checkGameStatus();

  if (!gameOver) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      getComputerMove();
      playLocalB();
      setState(() {
        _buttonsEnabled = true; // Enable the buttons after the computer's move
      });
    });
  }
}

  void _button5() {
    if (!_buttonsEnabled || gameOver || mBoard[5] != "") return;

    setState(() {
      mBoard[5] = HUMAN_PLAYER;
      
      _buttonsEnabled = false;
    });

    playLocalA();

    checkGameStatus();

  if (!gameOver) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      getComputerMove();
      playLocalB();
      setState(() {
        _buttonsEnabled = true; // Enable the buttons after the computer's move
      });
    });
  }
}

  void _button6() {
    if (!_buttonsEnabled || gameOver || mBoard[6] != "") return;

    setState(() {
      mBoard[6] = HUMAN_PLAYER;
      
      _buttonsEnabled = false;
    });

    playLocalA();

    checkGameStatus();

  if (!gameOver) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      getComputerMove();
      playLocalB();
      setState(() {
        _buttonsEnabled = true; // Enable the buttons after the computer's move
      });
    });
  }
}

  void _button7() {
    if (!_buttonsEnabled || gameOver || mBoard[7] != "") return;

    setState(() {
      mBoard[7] = HUMAN_PLAYER;
      
      _buttonsEnabled = false;
    });
    playLocalA();

    checkGameStatus();

  if (!gameOver) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      getComputerMove();
      playLocalB();
      setState(() {
        _buttonsEnabled = true; // Enable the buttons after the computer's move
      });
    });
  }
}

  void _button8() {
    if (!_buttonsEnabled || gameOver || mBoard[8] != "") return;

    setState(() {
      mBoard[8] = HUMAN_PLAYER;
      
      _buttonsEnabled = false;
    });

    playLocalA();

    checkGameStatus();

  if (!gameOver) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      getComputerMove();
      playLocalB();
      setState(() {
        _buttonsEnabled = true; // Enable the buttons after the computer's move
      });
    });
  }
}

  void displayMessage(String text) {
    text = text;
    (text);
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
                onPressed: !_buttonsEnabled || gameOver || mBoard[0].isNotEmpty ? null : _button0,
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
                onPressed: !_buttonsEnabled || gameOver || mBoard[1].isNotEmpty ? null : _button1,
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
                onPressed: !_buttonsEnabled || gameOver || mBoard[2].isNotEmpty ? null : _button2,
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
                onPressed: !_buttonsEnabled || gameOver || mBoard[3].isNotEmpty ? null : _button3,
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
                onPressed: !_buttonsEnabled || gameOver || mBoard[4].isNotEmpty ? null : _button4,
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
                onPressed: !_buttonsEnabled || gameOver || mBoard[5].isNotEmpty ? null : _button5,
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
                onPressed: !_buttonsEnabled || gameOver || mBoard[6].isNotEmpty ? null : _button6,
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
                onPressed: !_buttonsEnabled || gameOver || mBoard[7].isNotEmpty ? null : _button7,
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
                onPressed: !_buttonsEnabled || gameOver || mBoard[8].isNotEmpty ? null : _button8,
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
                        onPressed:
                            !_buttonsEnabled || gameOver || mBoard[0].isNotEmpty ? null : _button0,
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
                        onPressed:
                            !_buttonsEnabled || gameOver || mBoard[1].isNotEmpty ? null : _button1,
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
                        onPressed:
                            !_buttonsEnabled || gameOver || mBoard[2].isNotEmpty ? null : _button2,
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
                        onPressed:
                            !_buttonsEnabled || gameOver || mBoard[3].isNotEmpty ? null : _button3,
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
                        onPressed:
                            !_buttonsEnabled || gameOver || mBoard[4].isNotEmpty ? null : _button4,
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
                        onPressed:
                            !_buttonsEnabled || gameOver || mBoard[5].isNotEmpty ? null : _button5,
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
                        onPressed:
                            !_buttonsEnabled || gameOver || mBoard[6].isNotEmpty ? null : _button6,
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
                        onPressed:
                            !_buttonsEnabled || gameOver || mBoard[7].isNotEmpty ? null : _button7,
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
                        onPressed:
                            !_buttonsEnabled || gameOver || mBoard[8].isNotEmpty ? null : _button8,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe", style: TextStyle(color: Colors.white)),
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
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: TextButton(
                  onPressed: null,
                  child: Text(
                    'About',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: TextButton(
                  onPressed: null,
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildVerticalLayout()
              : _buildHorizontalLayout();
        },
      ),
    );
  }
}
