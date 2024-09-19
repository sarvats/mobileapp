import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  Color petColor = Colors.yellow;
  String petMood = "Neutral";
  Timer? hungerTimer;
  Timer? winTimer;
  bool hasWon = false;

  @override
  void initState() {
    super.initState();
    startHungerTimer();
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    winTimer?.cancel();
    super.dispose();
  }

  // Start automatic hunger increase
  void startHungerTimer() {
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _checkLossCondition();
        _updateHappiness();
      });
    });
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updatePetColorAndMood();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _updatePetColorAndMood();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel > 70) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else if (hungerLevel < 30) {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }

    if (happinessLevel >= 80) {
      startWinTimer();
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    _checkLossCondition();
  }

  // Check loss condition
  void _checkLossCondition() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Your pet is too hungry and unhappy.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetGame();
                },
                child: Text('Restart'),
              ),
            ],
          );
        },
      );
    }
  }

  // Update pet color and mood
  void _updatePetColorAndMood() {
    if (happinessLevel > 70) {
      petColor = Colors.green;
      petMood = "😊";
    } else if (happinessLevel >= 30) {
      petColor = Colors.yellow;
      petMood = "😐";
    } else {
      petColor = Colors.red;
      petMood = "😢";
    }
  }

  // Start win condition timer
  void startWinTimer() {
    if (winTimer == null || !winTimer!.isActive) {
      winTimer = Timer(Duration(minutes: 3), () {
        if (happinessLevel >= 80) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('You Win!'),
                content: Text('Your pet stayed happy for 3 minutes!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetGame();
                    },
                    child: Text('Restart'),
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  // Reset game
  void _resetGame() {
    setState(() {
      petName = "Your Pet";
      happinessLevel = 50;
      hungerLevel = 50;
      petColor = Colors.yellow;
      petMood = "Neutral";
      hasWon = false;
      winTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 100,
              height: 100,
              color: petColor,
              alignment: Alignment.center,
              child: Text(
                petMood,
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
