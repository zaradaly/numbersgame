// import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numberToGuess = 0;
  final myController = TextEditingController();
  final myFocusNode = FocusNode(); // <-- Add this line
  final _listViewController = ScrollController();
  int guessNumber = 0;

  List guesses = [
    // {'key': 'You', 'value': '12345'},
    // {'key': 'CPU', 'value': '2 valids, 1 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
    // {'key': 'You', 'value': '54321'},
    // {'key': 'CPU', 'value': '1 valid, 2 Misplaced'},
  ];

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

  submitGuess() async {
    // ignore: avoid_print
    print('Text field : ${myController.text}');
    if ((myController.text).toString().length != 4) {
      // ignore: avoid_print
      print('Invalid Guess');
      // return;
    } else if (duplicateFound(int.parse(myController.text))) {
      // ignore: avoid_print
      print('Guess contains duplicate digits');
      // return;
    } else {
      String newGuess = myController.text;
      // ignore: avoid_print
      List<Object> verifiedGuess = verifyGuess(newGuess);
      // print('New Guess : $newGuess');
      setState(() {
        guesses.add({
          'key': 'You',
          'guessNumber': ++guessNumber,
          'value': newGuess,
        });
        for (var element in verifiedGuess) {
          guesses.add(element);
        }
      });
      myController.clear();
      myFocusNode.requestFocus();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _listViewController.animateTo(
          _listViewController.position.maxScrollExtent,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 300),
        );
      });

      if ((verifiedGuess as List)[1]['value'] == 'You won!') {
        bool dialogResult = await showDialog(
          barrierDismissible: false,
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('You Won!'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //position
              mainAxisSize: MainAxisSize.min,
              // wrap content in flutter
              children: <Widget>[
                Text('It took you ${guessNumber.toString()} guesses to win!'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Play Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'No, Thanks',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            elevation: 24,
          ),
        );

        if (dialogResult == false) {
          // SystemNavigator.pop();
          return ({'key': 'CPU', 'value': 'You won!'});
        } else {
          regenerateRandomNumber();
        }
      };
      // _listViewController.animateTo(
      //   // Scroll to the bottom of the list view
      //   _listViewController.position.maxScrollExtent,
      //   curve: Curves.easeIn,
      //   duration: const Duration(milliseconds: 300),
      // );
    }
  }

  verifyGuess(String newGuess) {
    int valids = 0;
    int misplaced = 0;
    for (int i = 0; i < newGuess.length; i++) {
      if (newGuess[i] == numberToGuess.toString()[i]) {
        valids++;
      } else if (numberToGuess.toString().contains(newGuess[i])) {
        misplaced++;
      }
    }
    if (valids == 4) {
      // ignore: avoid_print
      // return ('You Won!');
      return ([
        {
          'key': 'CPU',
          'value': 'Valid Digits : $valids, Misplaced Digits : $misplaced',
        },
        {'key': 'CPU', 'value': 'You won!'},
      ]);
    } else {
      // ignore: avoid_print
      // return ('Valid Digits : $valids, Misplaced Digits : $Misplaced');
      return ([
        {
          'key': 'CPU',
          'value': 'Valid Digits : $valids - Misplaced Digits : $misplaced',
        },
      ]);
    }
  }

  regenerateRandomNumber() {
    setState(() {
      guesses = [];
      numberToGuess = generateRandomNumber();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      numberToGuess = generateRandomNumber();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the bottom of the list view after the first frame is rendered
      _listViewController.animateTo(
        _listViewController.position.maxScrollExtent,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myFocusNode.dispose(); // <-- Add this line
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
        title: const Text('Number is generated, guess it!', style: TextStyle(color: Colors.black)),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          IconButton(
            onPressed: () {
              regenerateRandomNumber();
            },
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/BlueWhale.gif'),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Card(
            //   margin: const EdgeInsets.only(top: 20,bottom: 10),
            //   color: Colors.white.withOpacity(0.6),
            //   child: const Padding(
            //     padding: EdgeInsets.fromLTRB(20,10,20,10),
            //     child: Text(
            //       'Number Generated, guess it!',
            //       style: TextStyle(color: Colors.black, height: 2.0, fontSize: 20),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     // 'Number Generated, guess it!',
            //     'Generated Number: $numberToGuess',
            //     style: const TextStyle(
            //         color: Colors.black, height: 2.0, fontSize: 20),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // MaterialButton(
            //     onPressed: regenerateRandomNumber,
            //     child: const Text('Regenerate Number')),
            // const Divider(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                // reverse: true,
                shrinkWrap: true,
                controller: _listViewController,
                scrollDirection: Axis.vertical,
                itemCount: guesses.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: SizedBox(
                          width: double.infinity,
                          // height: 10,
                          child: Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            guesses[index]['key'] +
                                ((guesses[index]['key'] == 'You')
                                    ? "[${guesses[index]['guessNumber']}]"
                                    : "") +
                                " - " +
                                DateFormat('kk:mm').format(DateTime.now()),
                            // guesses[index]['key'] + " : ",
                            // + (index + 1).toString(),
                            style: const TextStyle(color: Colors.white),
                            textAlign: (guesses[index]['key'] == 'You')
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ),
                      ),
                      ListTile(
                        // contentPadding: const EdgeInsets.all(10),
                        title: Card(
                          // margin: const EdgeInsets.all(10),
                          color: Colors.white.withOpacity(0.6),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              guesses[index]['value'],
                              style: const TextStyle(
                                // color: Colors.red,
                                height: 1.0,
                              ),
                              textAlign: (guesses[index]['key'] == 'You')
                                  ? TextAlign.right
                                  : TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              // child: ListView.builder(
              //   itemCount: 15,
              //   itemBuilder: (context, index) {
              //     if (index % 2 == 0) {
              //       return Column(
              //         children: [
              //           const Padding(
              //             padding: EdgeInsets.symmetric(horizontal: 35),
              //             child: SizedBox(
              //               width: double.infinity,
              //               // height: 10,
              //               child: Text('Youes',
              //                 style: TextStyle(color: Colors.white),
              //                 textAlign: TextAlign.right),
              //             ),
              //           ),
              //           ListTile(
              //             // contentPadding: const EdgeInsets.all(10),
              //             title: Card(
              //               // margin: const EdgeInsets.all(10),
              //               color: Colors.white.withOpacity(0.6),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Text(
              //                   'Item ${index + 1}',
              //                   style: const TextStyle(
              //                       color: Colors.red, height: 2.0),
              //                   textAlign: TextAlign.right,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       );
              //     } else {
              //       return Column(
              //         children: [
              //           const Padding(
              //             padding: EdgeInsets.symmetric(horizontal: 35),
              //             child: SizedBox(
              //               width: double.infinity,
              //               // height: 10,
              //               child: Text('CPU',
              //                 style: TextStyle(color: Colors.white),
              //                 textAlign: TextAlign.left),
              //             ),
              //           ),
              //           ListTile(
              //             title: Card(
              //               color: Colors.white.withOpacity(0.2),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Text('Item ${index + 1}',
              //                     style: const TextStyle(
              //                         color: Colors.blue, height: 2.0)),
              //               ),
              //             ),
              //           ),
              //         ],
              //       );
              //     }
              //   },
              // ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: myFocusNode, // <-- Add this line
                      textAlign: TextAlign.center,
                      autofocus: true,
                      controller: myController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      onSubmitted: (value) => submitGuess(),
                      // onSubmitted: submitGuess(),
                      // onChanged: (String value) {},
                      // onEditingComplete: () {},
                      // onSubmitted: (String value) { submitGuess(); },
                      // onTapOutside: (PointerDownEvent event) {},
                      // onTap: () {},
                      // onAppPrivateCommand: (String action, Map<String, dynamic> data) {},
                      decoration: const InputDecoration(
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                        //   borderSide: BorderSide(color: Colors.black),
                        // ),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                        //   borderSide: BorderSide(color: Colors.black, width: 2.0),
                        // ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                        //   borderSide: BorderSide(color: Colors.black, width: 2.0),
                        // ),
                        labelText: 'Your guess :',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 30),
                      ),
                      style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // SizedBox(
                  //   child: TextButton(
                  //     onPressed: submitGuess,
                  //     // style: TextButton.styleFrom(
                  //     //   backgroundColor: Colors.blue,
                  //     // ),
                  //     child: const Icon(
                  //       Icons.send,
                  //       color: Colors.black,
                  //       size: 40,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // const Text(
            //   'Welcome to the Numbers Game!',
            //   style: TextStyle(fontSize: 24),
            // ),
          ],
        ),
      ),
    );
  }
}
