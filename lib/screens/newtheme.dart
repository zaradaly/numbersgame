import 'dart:math';

import 'package:flutter/material.dart';
import 'package:numbersgame/const.dart';
import 'package:numbersgame/widgets/number_pad.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
      numberToGuess = generateRandomNumber();
    });
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

  void buttonTapped(String value) {
    if (value == 'DEL') {
      // Clear the userAnswer
      setState(() {
        userAnswer = '';
      });
    } else if (value == '=') {
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
    } else {
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                offset: const Offset(0,2),
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
                              'Valid : ${guesses[index]['correctPosition']}',
                              style: whiteTextStyle.copyWith(fontSize: 16),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            // const SizedBox(width: 10),
                            Text(
                              ' - MissPlaced : ${guesses[index]['correctDigits']}',
                              style: whiteTextStyle.copyWith(fontSize: 16),
                            ),
                            Icon(
                              Icons.shuffle,
                              color: Colors.red,
                              // size: 34,
                              weight: 900, // Make the icon bolder (Flutter 3.10+)
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.backspace, color: Colors.white),
                            onPressed: () {
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
                          ),
                        ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
