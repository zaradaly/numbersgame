// create stateless widget for home menu
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:numbersgame/audio_manager.dart';
// import 'package:numbersgame/screens/homepage.dart';
import 'package:numbersgame/screens/newtheme.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> with WidgetsBindingObserver {
  // late final AudioPlayer _bgmPlayer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AudioManager().playBackgroundMusic('assets/audio/background.mp3');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AudioManager().playBackgroundMusic('assets/audio/background.mp3');
    } else if (state == AppLifecycleState.paused) {
      AudioManager().stopBackgroundMusic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // transparent app bar
        backgroundColor: Colors.transparent,
        // backgroundColor: Colors.deepPurple[300],
        // elevation: 1,
        // title: const Text(
        //   'Numbers Game',
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white,
        //   ),
        // ),
        // centerTitle: true,
      ),
      // body with background image
      body: Container(
        decoration: BoxDecoration(
          // color: Colors.deepPurple[300],
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // image: DecorationImage(
          //   image: AssetImage('assets/images/BlueWhale.gif'),
          //   fit: BoxFit.cover, V2
          // ),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            children: [
              // const Image(
              //   image: AssetImage('assets/images/maths.gif'),
              //   // full width image
              //   width: double.infinity,
              //   height: 200,
              // ),
              // const SizedBox(height: 20),
              const Image(
                image: AssetImage('assets/images/icons/logotransparent.png'),
                // width: double.infinity,
                height: 300,
                // fit: BoxFit.cover,
              ),
              // const SizedBox(height: 20),
              // Container(
              //   margin: const EdgeInsets.symmetric(
              //     vertical: 10,
              //     horizontal: 25,
              //   ),
              //   padding: const EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(15),
              //     border: Border.all(
              //       color: Colors.white.withOpacity(0.5),
              //       width: 2,
              //     ),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.1),
              //         spreadRadius: 2,
              //         blurRadius: 3,
              //         offset: const Offset(0, 1), // changes position of shadow
              //       ),
              //     ],
              //     color: Colors.blue.withOpacity(0.8),
              //   ),
              //   child: ListTile(
              //     title: Center(
              //       child: const Text(
              //         'Start Game',
              //         style: TextStyle(
              //           fontSize: 24,
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //     iconColor: Colors.white,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //     tileColor: Colors.white,
              //     leading: const Icon(
              //       Icons.play_arrow,
              //       color: Colors.white,
              //       size: 30,
              //     ),
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const MyHomePage(),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 25,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: Colors.deepPurple.withOpacity(0.9),
                ),
                child: ListTile(
                  title: Center(
                    child: const Text(
                      'Start Game',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  iconColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: Colors.white,
                  leading: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                  onTap: () {
                    // Add functionality for settings
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PurplePage(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 25,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: Colors.blue.withOpacity(0.8),
                ),
                child: ListTile(
                  title: Center(
                    child: const Text(
                      'How to Play',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  iconColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: Colors.white,
                  leading: const Icon(
                    Icons.help,
                    color: Colors.white,
                    size: 30,
                  ),
                  onTap: () {
                    // show draggable bottom sheet with how to play instructions
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.5,
                          minChildSize: 0.3,
                          maxChildSize: 0.9,
                          builder: (context, scrollController) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  children: [
                                    const Text(
                                      'How to Play 🤔',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text.rich(
                                      TextSpan(
                                        text:
                                            'Welcome to the Numbers Game! Here’s how to play:\n\n',
                                        style: TextStyle(fontSize: 18),
                                        children: [
                                          TextSpan(
                                            text: '1. Start Game.\n\n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '2. Enter a 4-digit combination with no repeating digits (e.g., 1 4 7 3).\n\n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '3. Follow the feedback indicating:\n\n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // generate a text with leading icon
                                    const Text.rich(
                                      TextSpan(
                                        style: TextStyle(fontSize: 18),
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.where_to_vote_outlined,
                                              color: Colors.green,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' – the number of digits that are both correct and in the correct position.\n\n',
                                          ),
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.mode_of_travel,
                                              color: Colors.orangeAccent,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' – the number of digits that exist in the hidden number but are in the wrong position.\n\n',
                                          ),
                                        ],
                                      ),
                                    ),

                                    // const Text.rich(
                                    //   TextSpan(
                                    //     text: '',
                                    //     style: TextStyle(fontSize: 18),
                                    //     children: [
                                    //       TextSpan(
                                    //         text:
                                    //             '4. Use the feedback provided to refine your next guesses and deduce the correct number.\n\n',
                                    //         style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //       TextSpan(
                                    //         text:
                                    //             '5. Continue guessing until you find the correct combination or run out of attempts.\n\n',
                                    //         style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //       TextSpan(
                                    //         text:
                                    //             '6. Enjoy the game and try to beat your high score!',
                                    //         style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.green, // Button color
                                        foregroundColor:
                                            Colors.white, // Text color
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 4,
                                        textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      child: Text.rich(
                                        TextSpan(
                                          // style: TextStyle(fontSize: 18),
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.thumb_up,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(text: ' Ready to Play!'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 25,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: Colors.blue.withOpacity(0.8),
                ),
                child: ListTile(
                  title: Center(
                    child: const Text(
                      'Exit',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  iconColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: Colors.white,
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 30,
                  ),
                  onTap: () {
                    // Add exit functionality
                    // Navigator.of(context).pop();
                    SystemNavigator.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
