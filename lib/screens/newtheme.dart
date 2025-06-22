import 'dart:convert';
import 'dart:math';

// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:numbersgame/audio_manager.dart';
import 'package:numbersgame/const.dart';
import 'package:numbersgame/main.dart';
import 'package:numbersgame/widgets/number_pad.dart';
import 'package:http/http.dart' as http;

class PurplePage extends StatefulWidget {
  // final String child;
  const PurplePage({
    super.key,
    // required this.child,
  });

  @override
  State<PurplePage> createState() => PurpleePageState();
}

class PurpleePageState extends State<PurplePage> {
  int numberToGuess = 0;
  int guessNumber = 0;
  List guesses = [];
  final _listViewController = ScrollController();
  final TextEditingController _playerNameController = TextEditingController(
    text: playerName.value,
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      numberToGuess = generateRandomNumber();
      // userAnswer = numberToGuess.toString();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // playerName.value = '';
      if (playerName.value.isEmpty) {
        // If playerName is empty, show the dialog to ask for the name
        askName();
      }
    });
  }

  // show modal on page load
  void askName() {
    showDialog(
      context: context,
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
      digit = Random().nextInt(8999) + 1000;
      // digit = Random().nextInt(89999) + 10000;
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
    if (value == 'Submit') {
      // await player.play(AssetSource('audio/enter.mp3'));
      AudioManager().playAudio('assets/audio/enter.mp3');
      // Check if userAnswer is empty
      if (userAnswer.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a number before submitting.')),
        );
        return;
      } else if (userAnswer.length < numberToGuess.toString().length) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You must enter ${numberToGuess.toString().length} digits.',
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
          ),
        );
        return;
      }

      // check how many digits from the userAnswer are present in the numberToGuess
      // and how many are in the correct position
      int correctPosition = 0;
      int correctDigits = 0;
      String numberToGuessStr = numberToGuess.toString();
      for (int i = 0; i < userAnswer.length; i++) {
        if (i < numberToGuessStr.length) {
          if (userAnswer[i] == numberToGuessStr[i]) {
            correctPosition++;
          } else if (numberToGuessStr.contains(userAnswer[i])) {
            correctDigits++;
          }
        }
      }

      // add userAnswer and the correctPosition and correctDigits to the guesses list
      guesses.add({
        'answer': int.tryParse(userAnswer),
        'correctPosition': correctPosition,
        'correctDigits': correctDigits,
      });

      // Only clear the answer in setState
      setState(() {
        userAnswer = '';
      });

      // Check the userAnswer
      if (userAnswer == numberToGuess.toString()) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Correct!')));
      }
      // else {
      //   ScaffoldMessenger.of(
      //     context,
      //   ).showSnackBar(SnackBar(content: Text('Incorrect! Try again.')));
      // }
      // if the answer is correct, show a dialog
      if (correctPosition == numberToGuess.toString().length) {
        AudioManager().playAudio('assets/audio/applauseWhistle.wav');
        showDialog(
          context: context,
          builder: (context) {
            // send player name and number of guesses to an api
            sendPlayerNameAndGuesses(playerName.value, guesses.length);
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
      // await player.play(AssetSource('audio/tap.mp3'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            // container top part
            Container(
              height: 60,
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
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // icon button to go back
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  Text(
                    'Guess the Number',
                    style: whiteTextStyle.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                          child: Text(
                            'Guess #${index + 1}: ${guesses[index]['answer']?.toString() ?? 'No Answer'}',
                            style: whiteTextStyle.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                            AudioManager().playAudio('assets/audio/delete.mp3');
                            setState(() {
                              // remove last character from userAnswer
                              if (userAnswer.isNotEmpty) {
                                userAnswer = userAnswer.substring(
                                  0,
                                  userAnswer.length - 1,
                                );
                              }
                            });
                          },
                          child: Center(
                            child: Icon(
                              Icons.backspace,
                              color: Colors.yellow,
                              size: 32,
                            ),
                          ),
                        ),

                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.orangeAccent,
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: IconButton(
                        //     icon: Icon(Icons.backspace, color: Colors.white),
                        //     onPressed: () {
                        //       setState(() {
                        //         // remove last character from userAnswer
                        //         if (userAnswer.isNotEmpty) {
                        //           userAnswer = userAnswer.substring(
                        //             0,
                        //             userAnswer.length - 1,
                        //           );
                        //         }
                        //       });
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: numberPad.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 6,
                        mainAxisExtent: 60,
                      ),
                      itemBuilder: (context, index) {
                        return MyButton(
                          child: numberPad[index],
                          onTap: () => buttonTapped(numberPad[index]),
                        );
                      },
                    ),
                    // Row widget containing button with value 0 and the submit button taking 2 columns
                    const SizedBox(height: 10),
                    Row(
                      // mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MyButton(
                            child: '0',
                            onTap: () => buttonTapped('0'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: MyButton(
                            child: "Submit",
                            onTap: () => buttonTapped('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  Future<void> sendPlayerNameAndGuesses(
    String value,
    int length,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('https://projects.zaradaly.com/numbersgame/submitscore.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': value,
          'score': length,
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON.
        print(jsonDecode(response.body));
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          print('Player name and guesses submitted successfully');
        } else {
          print('Failed to submit player name and guesses: ${data['message']}');
        }
      } else {
        // If the server did not return an OK response, throw an exception.
        throw Exception('Failed to submit player name and guesses');
      }
    } catch (e) {
      print('Error sending data: $e');
      rethrow;
    }
  }
}
