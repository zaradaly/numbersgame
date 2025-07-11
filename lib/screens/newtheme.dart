// import 'dart:convert';
import 'dart:math';

// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:numbersgame/audio_manager.dart';
import 'package:numbersgame/const.dart';
import 'package:numbersgame/main.dart';
import 'package:numbersgame/providers/currency_provider.dart';
import 'package:numbersgame/widgets/number_pad.dart';
// import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PurplePage extends StatefulWidget {
  final int digitsNumber;
  final int cost;
  final int reward;
  late final int allowedGuesses;

  // final String child;
  PurplePage({
    super.key,
    required this.digitsNumber,
    required this.cost,
    required this.reward,
    required this.allowedGuesses,
    // required this.child,
  });

  @override
  State<PurplePage> createState() => PurpleePageState();
}

class PurpleePageState extends State<PurplePage> {
  int numberToGuess = 0;
  int guessNumber = 0;
  List<String> numberButtons = numberPad;
  List guesses = [];
  final _listViewController = ScrollController();
  final TextEditingController _playerNameController = TextEditingController(
    text: playerName.value,
  );
  String hintNumber = "";
  int numbersRemoved = 0;
  bool extraGuessesAvailable = true;
  DateTime started_at = DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      numberToGuess = generateRandomNumber();
      // userAnswer = numberToGuess.toString();
      numberButtons = List.from(numberPad); // Create a new copy of numberPad
      hintNumber = ""; // Initialize hintNumber with underscores
      numbersRemoved = 0; // Reset numbersRemoved state
      extraGuessesAvailable = true; // Reset extraGuessesAvailable state
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // playerName.value = '';
      if (playerName.value.isEmpty) {
        // If playerName is empty, show the dialog to ask for the name
        askName();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset numberButtons every time the screen loads
    numberButtons = List.from(numberPad);
  }

  // show modal on page load
  void askName() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Welcome to the\nNumbers Game ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[700],
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // <-- Add this line
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // form to ask the user to enter his name
              TextField(
                controller: _playerNameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
              // submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    // get value from the text field
                    String name = _playerNameController.text.trim();
                    // save name in local storage or state management
                    playerName.value = name;
                    // close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int generateRandomNumber() {
    bool validNumber = false;
    int digit = 0;
    guessNumber = 0;

    while (!validNumber) {
      if (widget.digitsNumber == 4) {
        digit = Random().nextInt(8999) + 1000; // 1000 to 9999
      } else if (widget.digitsNumber == 5) {
        digit = Random().nextInt(89999) + 10000; // 10000 to 99999
      } else {
        // Default to 4 digits if no valid number is specified
        digit = Random().nextInt(8999) + 1000; // 1000 to 9999
      }
      if (!duplicateFound(digit)) validNumber = true;
    }
    return digit;
  }

  bool duplicateFound(int number) {
    bool duplicateFound = false;
    for (int i = 0; i < number.toString().length; i++) {
      for (int j = i + 1; j < number.toString().length; j++) {
        if (number.toString()[i] == number.toString()[j]) {
          duplicateFound = true;
          break;
        }
      }
    }
    return duplicateFound;
  }

  String userAnswer = '';

  void buttonTapped(String value) async {
    if (value == '⌫') {
      AudioManager().playAudio('assets/audio/delete.mp3');
      // remove last character from userAnswer
      setState(() {
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      });
      return;
    } else if (value == '') {
      // Do nothing for empty value
      return;
    } else if (value == 'Submit') {
      AudioManager().playAudio('assets/audio/enter.mp3');
      // Check if userAnswer is empty
      // hide previous snackbar if any
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (userAnswer.isEmpty) {
        // Show a snackbar to ask the user to enter a number
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a number before submitting.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent.shade200,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.38,
              left: 20,
              right: 20,
            ),
          ),
        );
        return;
      } else if (userAnswer.length < numberToGuess.toString().length) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You must enter ${numberToGuess.toString().length} digits.',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent.shade200,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.38,
              left: 20,
              right: 20,
            ),
          ),
        );
        return;
      }

      // check if the userAnswer contain duplicate digits
      if (duplicateFound(int.tryParse(userAnswer) ?? 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your answer cannot contain duplicate digits.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent.shade200,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.38,
              left: 20,
              right: 20,
            ),
          ),
        );
        return;
      }

      // check how many digits from the userAnswer are present in the numberToGuess
      // and how many are in the correct position
      int correctPosition = 0;
      int correctDigits = 0;
      String numberToGuessStr = numberToGuess.toString();
      List<Map<String, dynamic>> answerWithColors = [];

      for (int i = 0; i < userAnswer.length; i++) {
        if (i < numberToGuessStr.length) {
          if (userAnswer[i] == numberToGuessStr[i]) {
            correctPosition++;
            answerWithColors.add({
              'digit': userAnswer[i],
              'color': 'green', // Correct position
            });
          } else if (numberToGuessStr.contains(userAnswer[i])) {
            correctDigits++;
            answerWithColors.add({
              'digit': userAnswer[i],
              'color': 'orange', // Wrong position but digit exists
            });
          } else {
            answerWithColors.add({
              'digit': userAnswer[i],
              'color': 'white', // Digit does not exist
            });
          }
        }
      }

      // add userAnswer and the correctPosition and correctDigits to the guesses list
      guesses.add({
        'answer': answerWithColors,
        'correctPosition': correctPosition,
        'correctDigits': correctDigits,
      });

      // if number of guesses is more than 10, lose the game
      if (guesses.length >= widget.allowedGuesses) {
        saveLostGameData(playerName.value, widget.digitsNumber);
        AudioManager().playAudio('assets/audio/lose.mp3');
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[700],
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage('assets/images/catcry.gif'),
                    // width: 100,
                    height: 200,
                    // fit: BoxFit.cover,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'You have used all your guesses.\n\nThe number was ',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.deepPurple[700],
                      ),
                      children: [
                        TextSpan(
                          text: '$numberToGuess',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Go back to the previous screen
                    Navigator.pop(context);
                  },
                  child: Text('Back'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();

                    // Check if the user has enough coins depending on the game mode
                    if (context.read<CurrencyProvider>().currency.coins <
                        widget.cost) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You need at least ${widget.cost} coins to play again.',
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent.shade200,
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.38,
                            left: 20,
                            right: 20,
                          ),
                        ),
                      );
                      return;
                    }
                    // Deduct 10 coins from the player
                    context.read<CurrencyProvider>().deductCoins(widget.cost);
                    // Play sound without stopping the background music
                    AudioManager().playAudio('assets/audio/playagain.mp3');

                    // Reset the game
                    setState(() {
                      guesses.clear();
                      numberToGuess = generateRandomNumber();
                      userAnswer = '';
                      hintNumber = ''; // Reset hint when game resets
                      numberButtons = List.from(
                        numberPad,
                      ); // Reset number buttons
                    });
                  },
                  child: Text(
                    'Play Again ↺',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.spaceEvenly,
            );
          },
        );
        return;
      }

      // Only clear the answer in setState
      setState(() {
        userAnswer = '';
      });

      // if the answer is correct, show a dialog
      if (correctPosition == numberToGuess.toString().length) {
        // send player name and number of guesses to an api
        saveWonGameData(playerName.value, guesses.length);
        AudioManager().playAudio('assets/audio/applauseWhistle.wav');
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[700],
                ),
                textAlign: TextAlign.center,
              ),
              content: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/fireworks.gif'),
                    // width: 100,
                    // height: 100,
                    fit: BoxFit.cover,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        image: AssetImage('assets/images/catdance.gif'),
                        // width: 100,
                        height: 200,
                        // fit: BoxFit.cover,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'You guessed the number ',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.deepPurple[700],
                          ),
                          children: [
                            TextSpan(
                              text: '$numberToGuess',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[900],
                              ),
                            ),
                            TextSpan(text: ' correctly!\n\n'),
                            TextSpan(
                              text: 'Total Guesses: ',
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[900],
                              ),
                            ),
                            TextSpan(
                              text: '${guesses.length}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Go back to the previous screen
                    Navigator.pop(context);
                  },
                  child: Text('Back'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Reset the game
                    setState(() {
                      guesses.clear();
                      numberToGuess = generateRandomNumber();
                      userAnswer = '';
                      hintNumber = ''; // Reset hint when game resets
                      numberButtons = List.from(
                        numberPad,
                      ); // Reset number buttons
                    });
                  },
                  child: Text(
                    'Play Again ↺',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.spaceEvenly,
            );
          },
        );
      }
    } else {
      AudioManager().playAudio('assets/audio/tap.mp3');
      // verify max 2 digits
      if (userAnswer.length >= numberToGuess.toString().length) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You can only enter a maximum of ${numberToGuess.toString().length} digits.',
            ),
          ),
        );
        return;
      }
      // Append the number to the userAnswer
      setState(() {
        userAnswer += value;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listViewController.animateTo(
        _listViewController.position.maxScrollExtent,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  bool hintUnlockWithGems() {
    final currencies = context.read<CurrencyProvider>();
    if (currencies.currency.gems >= 5) {
      currencies.deductGems(5);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hint unlocked! 5 gems deducted.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.greenAccent.shade200,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.38,
            left: 20,
            right: 20,
          ),
        ),
      );
      return true; // Indicate that the hint was successfully unlocked
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You need at least 5 gems to unlock a hint.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent.shade200,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.38,
            left: 20,
            right: 20,
          ),
        ),
      );
      return false; // Indicate that the hint was not unlocked
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencies = context.watch<CurrencyProvider>().currency;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        // Show confirmation dialog before abandoning the game
        final shouldAbandon = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Abandon Game?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[700],
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/catmad.gif',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Are you sure?\n\nYour progress will be lost and you will lose your current Win Streak.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Don't abandon
                  },
                  child: Text('No', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    context.read<CurrencyProvider>().resetWinStreak();
                    final currencyProvider = context.read<CurrencyProvider>();
                    currencyProvider.addGame();
                    Navigator.of(context).pop(true); // Confirm abandon
                  },
                  child: Text('Yes', style: TextStyle(color: Colors.white)),
                ),
              ],
              actionsAlignment: MainAxisAlignment.spaceEvenly,
            );
          },
        );

        if (shouldAbandon == true) {
          // Reset streak and add game
          context.read<CurrencyProvider>().resetWinStreak();
          context.read<CurrencyProvider>().addGame();

          // Actually pop the screen
          Navigator.of(context).pop();
        }
      },

      child: Scaffold(
        backgroundColor: Colors.deepPurple[300],
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Column(
            children: [
              // container top part
              Container(
                height: 50,
                // color: Colors.deepPurple,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[400],
                  // color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        // icon button to go back
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            abandonGame();
                          },
                        ),

                        Text(
                          '${widget.digitsNumber} digits',
                          style: whiteTextStyle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '🪙 ${currencies.coins.toString()}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '💎 ${currencies.gems.toString()}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const SizedBox(width: 20),
                        // Text(
                        //   '🏅 ${currencies.badgesUnlocked}/${currencies.badgesTotal}',
                        //   style: TextStyle(
                        //     // fontSize: 20,
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        const SizedBox(width: 10),
                      ],
                    ),

                    // icon button to restart the game
                    // IconButton(
                    //   icon: Icon(Icons.refresh, color: Colors.white),
                    //   onPressed: () {
                    //     // Reset the game
                    //     setState(() {
                    //       guesses.clear();
                    //       numberToGuess = generateRandomNumber();
                    //       userAnswer = '';
                    //     });
                    //     // Play sound without stopping the background music
                    //     AudioManager().playAudio('assets/audio/playagain.mp3');
                    //   },
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You have ${widget.allowedGuesses} attempts. Good luck!',
                style: whiteTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // question part
              Expanded(
                // flex: 3,
                child: Container(
                  // child with a listtile contatining list of answers
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  // child with listtile builder
                  child: ListView.builder(
                    controller: _listViewController,
                    itemCount: guesses.toString().length,
                    itemBuilder: (context, index) {
                      // verify if guesses[index] is not empty
                      if (guesses.isEmpty || index >= guesses.length) {
                        return const SizedBox.shrink();
                      }
                      // verify if guesses[index] is not null
                      if (guesses[index] == null) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          // First element: the answer in a styled box
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              // color: Colors.deepPurple[500],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: 'Guess #${widget.allowedGuesses - index}',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 20,
                                  // fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' | ',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.deepPurple.shade400,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Display each digit with its color
                                  ...((guesses[index]['answer']
                                              as List<Map<String, dynamic>>?)
                                          ?.map((digitInfo) {
                                            Color digitColor;
                                            switch (digitInfo['color']) {
                                              case 'green':
                                                digitColor =
                                                    (widget.allowedGuesses ==
                                                        15)
                                                    ? Colors.greenAccent
                                                    : Colors.white;
                                                break;
                                              case 'orange':
                                                digitColor =
                                                    (widget.allowedGuesses ==
                                                        15)
                                                    ? Colors.orangeAccent
                                                    : Colors.white;
                                                break;
                                              default:
                                                digitColor = Colors.white;
                                            }
                                            return TextSpan(
                                              text: digitInfo['digit'],
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: digitColor,
                                              ),
                                            );
                                          })
                                          .toList() ??
                                      [
                                        TextSpan(
                                          text: 'No Answer',
                                          style: whiteTextStyle.copyWith(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                            // Text(
                            //   'Guess #${index + 1}: ${guesses[index]['answer']?.toString() ?? 'No Answer'}',
                            //   style: whiteTextStyle.copyWith(
                            //     fontSize: 22,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ),
                          const SizedBox(width: 16),
                          // Second element: result details
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min, // <-- Add this line
                            children: [
                              Text(
                                '${guesses[index]['correctPosition']}',
                                style: whiteTextStyle.copyWith(fontSize: 16),
                              ),
                              Icon(
                                Icons.where_to_vote_outlined,
                                color: Colors.greenAccent,
                                // size: 20,
                              ),
                              // const SizedBox(width: 10),
                              Text(
                                ' - ${guesses[index]['correctDigits']}',
                                style: whiteTextStyle.copyWith(fontSize: 16),
                              ),
                              Icon(
                                Icons.mode_of_travel,
                                color: Colors.orangeAccent,
                                // size: 34,
                                weight:
                                    900, // Make the icon bolder (Flutter 3.10+)
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // userAnswer part
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple[300],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // <-- Add this line

                    children: [
                      // section contatining 3 icons that represent jockers that can be used to make the game easier
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            (hintNumber == "")
                                ? IconButton(
                                    icon: Icon(
                                      Icons.password,
                                      color: Colors.purple[900],
                                    ),
                                    onPressed: () {
                                      if (hintUnlockWithGems()) {
                                        // give 1 random digit from the numberToGuess with its position
                                        String numberStr = numberToGuess
                                            .toString();
                                        int randomIndex = Random().nextInt(
                                          numberStr.length,
                                        );
                                        String randomDigit =
                                            numberStr[randomIndex];

                                        // Create hint string with underscores and the revealed digit
                                        String hint = '';
                                        for (
                                          int i = 0;
                                          i < numberStr.length;
                                          i++
                                        ) {
                                          if (i == randomIndex) {
                                            hint += randomDigit;
                                          } else {
                                            hint += '_';
                                          }
                                        }

                                        setState(() {
                                          hintNumber = hint;
                                        });

                                        // Show a snackbar with the hint
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Hint: Digit ${randomDigit} is at position ${randomIndex + 1}!',
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Colors.deepPurple.shade400,
                                            margin: EdgeInsets.only(
                                              bottom:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.38,
                                              left: 20,
                                              right: 20,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : Text(
                                    hintNumber,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                      letterSpacing: 4,
                                    ),
                                  ),
                            (numbersRemoved == 0)
                                ? IconButton(
                                    icon: Icon(
                                      Icons.format_paint_outlined,
                                      color: Colors.purple[900],
                                    ),
                                    onPressed: () {
                                      if (hintUnlockWithGems()) {
                                        // remove 2 random digits that are not in the numberToGuess from the numberButtons
                                        if (numberButtons.length > 2) {
                                          setState(() {
                                            // Remove 2 random digits
                                            for (int i = 0; i < 2; i++) {
                                              int randomIndex = Random()
                                                  .nextInt(
                                                    numberButtons.length,
                                                  );
                                              while ((double.tryParse(
                                                        numberButtons[randomIndex],
                                                      ) ==
                                                      null) ||
                                                  (numberToGuess
                                                      .toString()
                                                      .contains(
                                                        numberButtons[randomIndex],
                                                      ))) {
                                                randomIndex = Random().nextInt(
                                                  numberButtons.length,
                                                );
                                              }
                                              numberButtons[randomIndex] =
                                                  ''; // Remove the digit
                                            }
                                            numbersRemoved +=
                                                2; // Increment the count of removed numbers
                                          });
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Not enough digits to remove.',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  Colors.redAccent.shade200,
                                              margin: EdgeInsets.only(
                                                bottom:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.38,
                                                left: 20,
                                                right: 20,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.format_paint_outlined,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {},
                                  ),
                            (extraGuessesAvailable)
                                ? IconButton(
                                    icon: Icon(
                                      Icons.battery_saver_outlined,
                                      color: Colors.purple[900],
                                    ),
                                    onPressed: () {
                                      if (hintUnlockWithGems()) {
                                        setState(() {
                                          widget.allowedGuesses += 5;
                                          print(widget.allowedGuesses);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'You have ${widget.allowedGuesses} allowed guesses now.',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  Colors.deepPurple.shade400,
                                              margin: EdgeInsets.only(
                                                bottom:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.38,
                                                left: 20,
                                                right: 20,
                                              ),
                                            ),
                                          );
                                          extraGuessesAvailable =
                                              false; // Disable the button after use
                                        });
                                      }
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.battery_saver_outlined,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {},
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // full width container with text centered
                      Row(
                        children: [
                          Expanded(
                            // <-- Make the container expand to fill available width
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  userAnswer.isEmpty
                                      ? 'Enter your guess ...'
                                      : userAnswer,
                                  style: whiteTextStyle.copyWith(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              // Play sound without stopping the background music
                              AudioManager().playAudio(
                                'assets/audio/enter.mp3',
                              );
                              // Submit the userAnswer
                              buttonTapped('Submit');
                            },
                            child: Center(
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.greenAccent[100],
                                size: 45,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: numberButtons.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 6,
                          mainAxisExtent: 40,
                        ),
                        itemBuilder: (context, index) {
                          return MyButton(
                            child: numberButtons[index],
                            onTap: () => buttonTapped(numberButtons[index]),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listViewController.dispose();
    _playerNameController.dispose();
    super.dispose();
  }

  Future<void> saveWonGameData(String value, int numberGuesses) async {
    // save player name and guesses to Hive
    final box = await Hive.openBox('unsyncedGames');
    await box.add({
      'username': value,
      'numberGuesses': numberGuesses,
      'mode': (widget.allowedGuesses == 15)
          ? 'Easy'
          : (widget.digitsNumber == 4)
          ? 'Normal'
          : 'Hard',
      'reward_coins': widget.reward,
      'reward_gems': 5,
      'won': true,
      'started_at': started_at.toString(),
    });
    print('Player name and guesses saved locally for later syncing.');
    print('Player name: $value, Guesses: $numberGuesses');

    // add coins and gems to the player currency Hive box
    final currencyProvider = context.read<CurrencyProvider>();
    currencyProvider.addWinStreak();
    currencyProvider.updateCurrencies(
      coins: currencyProvider.currency.coins + widget.reward,
      gems: currencyProvider.currency.gems + 5,
    );
    // add total wins and total games
    currencyProvider.addWin();
    currencyProvider.addGame();
    print('Currency updated and saved to Hive.');
    print('Added ${widget.reward} coins and 5 gems to the player currency.');
    // display the PlayerCurrencies object
    print('Player Currencies: ${currencyProvider.currency}');
    print(
      'Coins: ${currencyProvider.currency.coins}, Gems: ${currencyProvider.currency.gems}',
    );

    // check if the player got to a win streakBadge
    for (var badge in streakBadges) {
      if (currencyProvider.currency.currentWinStreak ==
          badge['streakRequired']) {
        // Unlock the badge
        currencyProvider.unlockBadge(
          badge['name'].toString(),
          badge['image_asset']?.toString() ??
              'assets/images/badges/default.png',
        );
        print('Badge "${badge['name']}" unlocked for the player.');
        // Show a dialog to congratulate the player for the win streak
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[700],
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min, // <-- Add this line
                children: [
                  Image.asset(
                    'assets/images/badges/streak${currencyProvider.currency.currentWinStreak}.png',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'You have achieved a win streak of ${currencyProvider.currency.currentWinStreak}!\n',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple[900],
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      }
    }
    // Check if the player has unlocked a new total wins badge
    for (var badge in trophyBadges) {
      if (currencyProvider.currency.totalWins == badge['winsRequired']) {
        // Unlock the badge
        currencyProvider.unlockBadge(
          badge['name'].toString(),
          badge['image_asset']?.toString() ??
              'assets/images/badges/default.png',
        );
        print('Badge "${badge['name']}" unlocked for the player.');
        // Show a dialog to congratulate the player for the total wins
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[700],
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min, // <-- Add this line
                children: [
                  Image.asset(
                    'assets/images/badges/win${currencyProvider.currency.totalWins}.png',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'You have achieved a total of ${currencyProvider.currency.totalWins} wins!\n',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple[900],
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> saveLostGameData(String value, int numberGuesses) async {
    // save player name and guesses to Hive
    final box = await Hive.openBox('unsyncedGames');
    await box.add({
      'username': value,
      'numberGuesses': widget.allowedGuesses,
      'mode': (widget.allowedGuesses == 15)
          ? 'Easy'
          : (widget.digitsNumber == 4)
          ? 'Normal'
          : 'Hard',
      'reward_coins': 0,
      'reward_gems': 0,
      'won': false,
      'started_at': started_at.toString(),
    });

    final currencyProvider = context.read<CurrencyProvider>();
    currencyProvider.resetWinStreak();
    currencyProvider.addGame();
  }

  void abandonGame() {
    // Show a confirmation dialog before abandoning the game
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Abandon Game?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[700],
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // <-- Add this line
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/catmad.gif',
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure?\n\nYour progress will be lost and you will lose your current Win Streak.',
                style: TextStyle(fontSize: 16, color: Colors.deepPurple[900]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                // reset streak
                context.read<CurrencyProvider>().resetWinStreak();
                final currencyProvider = context.read<CurrencyProvider>();
                currencyProvider.addGame();
                // save lost game data

                final box = await Hive.openBox('unsyncedGames');
                await box.add({
                  'username': playerName.value,
                  'numberGuesses': widget.allowedGuesses,
                  'mode': (widget.allowedGuesses == 15)
                      ? 'Easy'
                      : (widget.digitsNumber == 4)
                      ? 'Normal'
                      : 'Hard',
                  'reward_coins': 0,
                  'reward_gems': 0,
                  'won': false,
                  'started_at': started_at.toString(),
                });

                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Yes', style: TextStyle(color: Colors.white)),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }
}
