import 'package:http/http.dart' as http;

class HangmanGame {
  String _word = "";
  String _correctGuesses = "";
  String _wrongGuesses = "";

  // Constructor starts off with blank strings that we will concatenate during the course of play.
  HangmanGame(String word) {
    _word = word;
    _correctGuesses = "";
    _wrongGuesses = "";
  }

  //
  // TODO: Complete the functions below to pass the Unit Tests.

  String correctGuesses() {
    return _correctGuesses;
  }

  String wrongGuesses() {
    return _wrongGuesses;
  }

  String word() {
    return _word;
  }

  bool guess(var letter) {

    if (letter == null ) throw ArgumentError('Guess cannot be null');

    if (letter is! String) throw ArgumentError('Guess must be a string');

    if (letter.isEmpty) throw ArgumentError('Guess cannot be empty');

    if (!RegExp(r'^[a-zA-Z]$').hasMatch(letter)) {
      throw ArgumentError('Guess must be a letter');
    }

    if (letter.length > 1) throw ArgumentError('Guess has to be a single letter');


    // Case sensitive 
    letter = letter.toLowerCase(); 

    // already guessed
    if (_correctGuesses.contains(letter) || _wrongGuesses.contains(letter)) {
      return false; 
    }
    
    // new guess
    if (_word.contains(letter)) {
      _correctGuesses += letter; 
    } else {
      _wrongGuesses += letter; 
    }

    return true; 
  }

  String blanksWithCorrectGuesses() {
    String result = '';
    for (int i = 0; i < _word.length; i++) {
      String c = _word[i];
      if (_correctGuesses.contains(c)) {
        result += c;
      } else {
        result += '-';
      }
    }
    return result;
  }

  String status() {
    // win: all unique letters guessed
    Set<String> uniqueLetters = _word.split('').map((c) => c.toLowerCase()).toSet(); // Split "word" into "w", "o", "r", "d", then lower case all letters, and then eliminate duplicates
    bool allGuessed = uniqueLetters.every((c) => _correctGuesses.contains(c)); // have we already guessed all the unique letters in the word?
    if (allGuessed) return 'win'; 

    // lose: 7 wrong guesses
    if (_wrongGuesses.length >= 7) return 'lose';

    // otherwise: still playing
    return 'play';
  }

  // When running integration tests always return "banana".
  static Future<String> getStartingWord(bool areWeInIntegrationTest) async {
    String word;
    final Uri endpoint = Uri.parse("http://randomword.saasbook.info/RandomWord");
    if (areWeInIntegrationTest) {
      word = "banana";
    } else {
      try {
        final response = await http.post(endpoint);
        word = response.body;
      } catch (e) {
        word = "error";
      }
    }

    return word;
  }
}
