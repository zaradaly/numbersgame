// create stateless widget for home menu
import 'package:flutter/material.dart';
import 'package:numbersgame/screens/homepage.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // transparent app bar
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Numbers Game'),
        centerTitle: true,
      ),
      // body with background image 
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/BlueWhale.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/maths.gif'),
                width: 150,
                height: 150,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                label: const Text('Start Game', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),  
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Add functionality for settings
                },
                icon: const Icon(Icons.settings, color: Colors.white, size: 20),
                label: const Text('Settings', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // open modal bottom sheet with instructions
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'How to Play',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '1. Start the game by pressing the "Start Game" button.\n'
                              '2. Follow the on-screen instructions to play.\n'
                              '3. Use the settings to customize your game experience.\n'
                              '4. Have fun and try to beat your high score!',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.info, color: Colors.white, size: 20),
                label: const Text('How to ?', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Add functionality for exit
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.white, size: 20),
                label: const Text('Exit', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),



      // body: Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       colors: [Colors.blue, Colors.purple],
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //     ),
      //   ),
      //   child:
      //       // list of buttons
      //       Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             ElevatedButton(
      //               onPressed: () {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => const MyHomePage(),
      //                   ),
      //                 );
      //               },
      //               child: const Text('Start Game'),
      //             ),
      //             const SizedBox(height: 20),
      //             ElevatedButton(
      //               onPressed: () {
      //                 // Add functionality for settings
      //               },
      //               child: const Text('Settings'),
      //             ),
      //             const SizedBox(height: 20),
      //             ElevatedButton(
      //               onPressed: () {
      //                 // Add functionality for about
      //               },
      //               child: const Text('About'),
      //             ),
      //             const SizedBox(height: 20),
      //             ElevatedButton(
      //               onPressed: () {
      //                 // Add functionality for exit
      //                 Navigator.of(context).pop();
      //               },
      //               child: const Text('Exit'),
      //             ),
      //           ],
      //         ),
      //       ),
      // ),
    );
  }
}
