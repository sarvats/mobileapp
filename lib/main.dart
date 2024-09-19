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
  Timer? hungerTimer;
  Timer? winTimer;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startHappinessTimer();
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    winTimer?.cancel();
    super.dispose();
  }

  // Automatically increase hunger every 30 seconds
  void _startHungerTimer() {
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 10).clamp(0, 100).toInt();
        _checkGameOver();
      });
    });
  }
  void _startHappinessTimer() {
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        happinessLevel = (happinessLevel - 10).clamp(0, 100).toInt();
        _checkGameOver();
      });
    });
  }

  // Function to play with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100).toInt();
      hungerLevel = (hungerLevel + 5).clamp(0, 100).toInt(); // Slight hunger increase
      _checkGameOver();
      _checkWinCondition();
    });
  }

  // Function to feed the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100).toInt();
      happinessLevel = (happinessLevel + 5).clamp(0, 100).toInt(); // Increase happiness slightly when fed
      _checkGameOver();
      _checkWinCondition();
    });
  }

  // Check if the player won or lost the game
  void _checkGameOver() {
    if (hungerLevel >= 80 && happinessLevel <= 10) {
      _showGameOverDialog('Game Over', 'Your pet is too unhappy and hungry!');
      hungerTimer?.cancel();
      winTimer?.cancel();
    }
  }

  // Check win condition: if happiness stays above 80 for 3 minutes
  void _checkWinCondition() {
    if (happinessLevel >= 80) {
      if (winTimer == null || !winTimer!.isActive) {
        winTimer = Timer(Duration(minutes: 1), () {
          if (happinessLevel >= 80) {
            _showGameOverDialog('You Win!', 'Your pet stayed happy for 3 minutes!');
            hungerTimer?.cancel();
          }
        });
      }
    } else {
      winTimer?.cancel();
    }
  }

  // Show a dialog when the game is over or won
  void _showGameOverDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Restart"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  // Reset the game to initial state
  void _resetGame() {
    setState(() {
      petName = "Your Pet";
      happinessLevel = 50;
      hungerLevel = 50;
      _startHungerTimer();
      _startHappinessTimer();
      winTimer?.cancel();
    });
  }

  Color _getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green; // Happy
    } else if (happinessLevel >= 30) {
      return Colors.yellow; // Neutral
    } else {
      return Colors.red; // Unhappy
    }
  }

  String _getPetMood() {
    if (happinessLevel > 70) {
      return "😊"; // Happy face emoji
    } else if (happinessLevel >= 30) {
      return "😐"; // Neutral face emoji
    } else {
      return "😢"; // Sad face emoji
    }
  }

  void _setPetName(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = petName;
        return AlertDialog(
          title: Text('Set Pet Name'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: InputDecoration(hintText: "Enter your pet's name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  petName = newName;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _setPetName(context),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _getPetColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  _getPetMood(),
                  style: TextStyle(fontSize: 48),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
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