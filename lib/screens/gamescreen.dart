import 'package:flutter/material.dart';
import 'package:hangman_game/models/hangmangame.dart';

import 'losescreen.dart';
import 'winscreen.dart';

class GameScreen extends StatefulWidget {
  final HangmanGame game;
  // The constructor has been modified to receive a HangmanGame object.
  const GameScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // This will be the controller we use to take in the user guess.
  final guessTextController = TextEditingController();

  // List images 
  static const List<String> IMGs = [
    'assets/progress_0.png',
    'assets/progress_1.png',
    'assets/progress_2.png',
    'assets/progress_3.png',
    'assets/progress_4.png',
    'assets/progress_5.png',
    'assets/progress_6.png'
  ];

  // These two variables will be used if guessed letter is invalid.
  bool showError = false;
  String guessTextFieldErrorMessage = '';
  int index = 0; // Variable to control images

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Center(
            child: ListView(
              children: <Widget>[
                const Padding(
                    padding: EdgeInsets.fromLTRB(0, 13, 0, 13),
                    child: Center(
                        child:
                            Text("Hangman", style: TextStyle(fontSize: 50)))),

                SizedBox(
                  height: 100,
                  child: Image(
                    key: Key('progress_$index'),
                    image: AssetImage(IMGs[index]),)
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    // Our correct guesses with dashes will be shown here.
                    child: Text(widget.game.blanksWithCorrectGuesses(),
                        style: const TextStyle(
                          fontSize: 40,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                  // Our wrong guesses will be shown here.
                  child: Text('Wrong Guesses: ${widget.game.wrongGuesses()}',
                      style: const TextStyle(fontSize: 17)),
                ),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                        // Here we are giving the guessing button a key for use in our integration tests in test/ingegration_tests.dart
                        key: const Key('guess-letter-btn'),
                        child:
                            const Text('Guess Letter',
                                style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          setState(() {
                            // Get the string that the user typed in the box.
                            String letter = guessTextController.text;

                            try {
                              //
                              // TODO: Call the guess() method from game and pass it the guessed letter.
                              bool accepted = widget.game.guess(letter); // use widget to call the passed object from mainscreen

                              //
                              // TODO: If the letter is accepted set showError = false, 
                              //       otherwise set showError = true and guessTextFieldMessage = 'already used that letter'
                              if (accepted) {
                                showError = false; 
                                guessTextFieldErrorMessage = ''; // Reset error message
                              }
                              else {
                                showError = true;
                                guessTextFieldErrorMessage  = 'already used that letter'; 
                              }

                              index = widget.game.wrongGuesses().length.clamp(0, 6);;  // Index to define current image

                              //
                              // TODO: Reset the text in the textbox after a guess.
                              guessTextController.clear();

                              //
                              // TODO: Check if the user has won the game, if they did navigate them to the WinScreen.

                              //
                              // TODO: Check if the user has lost the game, if they did navigate them to the LoseScreen. You will need to pass the game to the LoseScreen.

                              
                              // Check if the user has won the game, if they did navigate them to the WinScreen.
                              if (widget.game.status() == 'win') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const WinScreen()),
                                );
                                return;
                              }

                              // Check if the user has lost the game, if they did navigate them to the LoseScreen. You will need to pass the game to the LoseScreen.
                              if (widget.game.status() == 'lose') {
              
                                  Navigator.push(
                                    context,
                                      MaterialPageRoute(
                                      builder: (context) =>
                                      LoseScreen(game: widget.game)),
                                );
                    
                                return;
                              }

                            } catch (e) {
                              // If the user is guessing an invalid character return this message.
                              guessTextFieldErrorMessage = 'invalid';
                              showError = true;
                            }
                          });
                        }),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: TextField(
                          // Here we are giving the guessing text field a key for use in our integration tests in test/integration_tests.dart.
                          key: const Key('guess-textfield'),
                          controller: guessTextController,
                          decoration: InputDecoration(
                            labelText: 'Enter New Letter',
                            errorText:
                                showError ? guessTextFieldErrorMessage : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
