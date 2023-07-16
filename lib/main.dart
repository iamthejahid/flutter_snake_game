import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_snake_games/utility/enum/snake_direction.dart';
import 'package:flutter_snake_games/widgets/blank_pixel.dart';
import 'package:flutter_snake_games/widgets/food_pixel.dart';
import 'package:flutter_snake_games/widgets/snake_pixel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // brightness: Brightness.dark,
          // primarySwatch: Colors.blue,
          ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<int> snakePixels = [0, 1, 2];
  int foodPixel = 5;
  SnakeDirection snakeDirection = SnakeDirection.RIGHT;

  int rowSize = 10;

  int score = 0;

  startGame() => snakePixels.length <= 3
      ? Timer.periodic(
          const Duration(milliseconds: 200),
          (timer) => setState(() {
                moveSnake();
                if (gameOver()) {
                  timer.cancel();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Game Over'),
                      actions: [
                        MaterialButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Back'),
                        ),
                        MaterialButton(
                          onPressed: () => {
                            Navigator.of(context).pop(),
                            reset(),
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                }
              }))
      : () {};

  eatFood() {
    while (snakePixels.contains(foodPixel)) {
      foodPixel = Random().nextInt(100);
    }
  }

  void moveSnake() {
    switch (snakeDirection) {
      case SnakeDirection.RIGHT:
        {
          if (snakePixels.last % rowSize == 9) {
            snakePixels.add(snakePixels.last + 1 - rowSize);
          } else {
            snakePixels.add(snakePixels.last + 1);
          }
        }

        break;
      case SnakeDirection.LEFT:
        {
          if (snakePixels.last % rowSize == 0) {
            snakePixels.add(snakePixels.last - 1 + rowSize);
          } else {
            snakePixels.add(snakePixels.last - 1);
          }
        }

        break;

      case SnakeDirection.UP:
        {
          if (snakePixels.last < rowSize) {
            snakePixels.add(snakePixels.last - rowSize + 100);
          } else {
            snakePixels.add(snakePixels.last - rowSize);
          }
        }

        break;

      case SnakeDirection.DOWN:
        {
          if (snakePixels.last + rowSize > 100) {
            snakePixels.add(snakePixels.last + rowSize - 100);
          } else {
            snakePixels.add(snakePixels.last + rowSize);
          }
        }

        break;
      default:
    }

    if (snakePixels.last == foodPixel) {
      setState(() {
        score++;
      });
      eatFood();
    } else {
      snakePixels.removeAt(0);
    }
  }

  bool gameOver() {
    List<int> bodyPixels = snakePixels.sublist(0, snakePixels.length - 1);

    if (bodyPixels.contains(snakePixels.last)) {
      return true;
    }

    return false;
  }

  reset() {
    snakePixels = [0, 1, 2];
    foodPixel = 5;
    score = 0;
    setState(() {});
    Future.microtask(() => startGame());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Score : $score",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      snakeDirection != SnakeDirection.UP) {
                    snakeDirection = SnakeDirection.DOWN;
                  } else if (details.delta.dy < 0 &&
                      snakeDirection != SnakeDirection.DOWN) {
                    snakeDirection = SnakeDirection.UP;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      snakeDirection != SnakeDirection.LEFT) {
                    snakeDirection = SnakeDirection.RIGHT;
                  } else if (details.delta.dx < 0 &&
                      snakeDirection != SnakeDirection.RIGHT) {
                    snakeDirection = SnakeDirection.LEFT;
                  }
                },
                child: GridView.builder(
                    itemCount: 100,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize,
                    ),
                    itemBuilder: (_, i) {
                      if (snakePixels.contains(i)) {
                        return const SnakePixel();
                      } else if (foodPixel == i) {
                        return const FoodPixel();
                      } else {
                        return const BlankPixel();
                      }
                    }),
              )),
          Expanded(
            child: Center(
              child: MaterialButton(
                color: Colors.pink,
                onPressed: startGame,
                child: const Text(
                  'play',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
