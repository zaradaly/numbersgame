// create stateless widget for home menu
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:flutter/rendering.dart';
import 'package:numbersgame/audio_manager.dart';
import 'package:numbersgame/main.dart';
import 'package:numbersgame/providers/currency_provider.dart';
import 'package:numbersgame/screens/gameshistory.dart';
// import 'package:numbersgame/screens/highscores.dart';
import 'package:numbersgame/screens/my_badges.dart';
// import 'package:numbersgame/screens/homepage.dart';
import 'package:numbersgame/screens/newtheme.dart';
import 'package:numbersgame/widgets/FantasySettingsScreen.dart';
import 'package:numbersgame/widgets/glossy_button.dart';
import 'package:provider/provider.dart';

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
    AudioManager().playBackgroundMusic('assets/audio/bgAudio.mp3');
    // if (await isConnected()){
    //   await syncWithServer();
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AudioManager().playBackgroundMusic('assets/audio/bgAudio.mp3');
    } else if (state == AppLifecycleState.paused) {
      AudioManager().stopBackgroundMusic();
    }
  }

  void resetCoinsGems(currencies) {
    int isCleared = int.tryParse(localStorage.getItem('isCleared') ?? '') ?? 0;
    // int isReset = int.tryParse(localStorage.getItem('isReset') ?? '') ?? 0;

    if (isCleared == 0) {
      // empty hive unsynced games
      final unsyncedGamesBox = Hive.box('unsyncedGames');
      unsyncedGamesBox.clear();
      final playerCurrencies = Hive.box('playerCurrency');
      playerCurrencies.clear();
      localStorage.setItem('isCleared', '1');
    }

    // if (isReset == 0) {  
      final currencyProvider = context.read<CurrencyProvider>();
      // final currencies = context.watch<CurrencyProvider>().currency;

      if (currencies.coins < 200) {
        currencyProvider.updateCurrencies(coins: 200);
      }
      if (currencies.gems < 20) {
        currencyProvider.updateCurrencies(gems: 20);
      }
      // localStorage.setItem('isReset', '1');
    // }
  }

  @override
  Widget build(BuildContext context) {
    final currencies = context.watch<CurrencyProvider>().currency;
    currencies.showData();

    // check if today is July 10th, 2025
    final today = DateTime.now();
    // if (today.year == 2025 && today.month == 7 && (today.day == 10 || today.day == 11)) {
    //   resetCoinsGems();
    // }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      // body with background image
      body: Container(
        decoration: BoxDecoration(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ?(playerName.value == '') ? null : Text(
                  '🐱 ${playerName.value}',
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 10),
                // TextButton(
                //   child: Text(
                //     '🏅 ${currencies.badgesUnlocked.length}/${currencies.badgesTotal} ',
                //     style: TextStyle(
                //       fontSize: 15,
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   onPressed: () {
                //     // navigate to the badges screen
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const MyBadgesScreen(),
                //       ),
                //     );
                //   },
                //   style: TextButton.styleFrom(
                //     backgroundColor: Colors.deepPurple.withOpacity(0.2),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     padding: const EdgeInsets.all(4),
                //   ),
                // ),
              ],
            ),
            // const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    // streak number
                    TextButton(
                      onPressed: () {
                        // show centered modal bottom sheet with streak details
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Streak Details'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Image.asset(
                                      'assets/images/streaks.gif',
                                      width: 150,
                                      height: 150,
                                    ),
                                    Text(
                                      'Current Win Streak: ${currencies.currentWinStreak}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Win consecutive games to increase your streak and earn more rewards!',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        '🔥 ${currencies.currentWinStreak.toString()}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(4),
                      ),
                    ),
                    const SizedBox(width: 5),
                    // total number of wins
                    TextButton(
                      onPressed: () {
                        // show centered modal bottom sheet with total wins details
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Total Wins'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Image.asset(
                                      'assets/images/catdance.gif',
                                      width: 150,
                                      height: 150,
                                    ),
                                    Text(
                                      'Total Wins: ${currencies.totalWins}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Get more wins by playing games and completing challenges!',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(4),
                      ),
                      child: Text(
                        '🏆 ${currencies.totalWins.toString()}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // const SizedBox(width: 5),
                    // TextButton(
                    //   child: Text(
                    //     '🏅 ${currencies.badgesUnlocked.length}/${currencies.badgesTotal}',
                    //     style: TextStyle(
                    //       fontSize: 15,
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     // navigate to the badges screen
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const MyBadgesScreen(),
                    //       ),
                    //     );
                    //   },
                    //   style: TextButton.styleFrom(
                    //     backgroundColor: Colors.deepPurple.withOpacity(0.2),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     padding: const EdgeInsets.all(4),
                    //   ),
                    // ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(4),
                      ),
                      onPressed: () {
                        // show centered modal bottom sheet with currency details
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Currency Details'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Image.asset(
                                      'assets/images/coins.gif',
                                      width: 80,
                                      height: 80,
                                    ),
                                    Text(
                                      'Coins: ${currencies.coins}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Get more coins by playing games, winning streaks, and completing challenges!',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        '🪙 ${currencies.coins.toString()}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(4),
                      ),
                      onPressed: () {
                        // show centered modal bottom sheet with currency details
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Gems Details'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Image.asset(
                                      'assets/images/gems.gif',
                                      width: 80,
                                      height: 80,
                                    ),
                                    Text(
                                      'Coins: ${currencies.gems}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Get more gems by playing games, winning streaks, and completing challenges!',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        '💎 ${currencies.gems.toString()}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        
            const Image(
              image: AssetImage('assets/images/icons/logotransparent.png'),
              width: double.infinity,
              height: 180,
              // fit: BoxFit.cover,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
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
                color: Colors.blueAccent.withOpacity(0.8),
              ),
              child: Column(
                children: [
                  // Text(
                  //   'Start 🎮',
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // const Divider(color: Colors.white54, thickness: 1),
                  // const SizedBox(height: 5),
                  // Start Game button
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(
                                  0.8,
                                ), // Button color
                                foregroundColor:
                                    Colors.deepPurple, // Text color
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 1,
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  // letterSpacing: 1.2,
                                ),
                              ),
                              onPressed: () {
                                // navigate to the game screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PurplePage(
                                      digitsNumber:
                                          4, // default digits number
                                      allowedGuesses:
                                          15, // default allowed guesses
                                      cost: 0, // no cost for free game
                                      reward: 2, // no reward for free game
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Easy'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(
                                  0.8,
                                ), // Button color
                                foregroundColor:
                                    Colors.deepPurple, // Text color
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 1,
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  // letterSpacing: 1.2,
                                ),
                              ),
                              onPressed: null,
                              child: const Text('🗓️ Daily'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(
                                  0.8,
                                ), // Button color
                                foregroundColor:
                                    Colors.deepPurple, // Text color
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 1,
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  // letterSpacing: 1.2,
                                ),
                              ),
                              onPressed: () {
                                var cost = 10; // cost for classic game
                                var allowedGuesses =
                                    10; // allowed guesses for classic game
                                var digitsNumber =
                                    4; // digits number for classic game
                                var reward = 20; // reward for classic game
        
                                // deduct 10 coins from the player
                                if (currencies.coins >= cost) {
                                  context
                                      .read<CurrencyProvider>()
                                      .deductCoins(cost);
                                } else {
                                  // show popup dialog if not enough coins
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Not Enough Coins'),
                                        content: Text(
                                          'You need at least ${cost} coins to start a game.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                                // navigate to the game screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PurplePage(
                                      digitsNumber: digitsNumber,
                                      allowedGuesses: allowedGuesses,
                                      cost: cost,
                                      reward: reward,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('10🪙 Classic'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(
                                  0.8,
                                ), // Button color
                                foregroundColor:
                                    Colors.deepPurple, // Text color
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 1,
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  // letterSpacing: 1.2,
                                ),
                              ),
                              onPressed: () {
                                var cost = 20; // cost for hard game
                                var allowedGuesses =
                                    10; // allowed guesses for hard game
                                var digitsNumber =
                                    5; // digits number for hard game
                                var reward = 40; // reward for hard game
        
                                // deduct 20 coins from the player
                                if (currencies.coins >= cost) {
                                  context
                                      .read<CurrencyProvider>()
                                      .deductCoins(cost);
                                } else {
                                  // show popup dialog if not enough coins
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Not Enough Coins'),
                                        content: Text(
                                          'You need at least ${cost} coins to start a game.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                                // navigate to the game screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PurplePage(
                                      digitsNumber: digitsNumber,
                                      allowedGuesses: allowedGuesses,
                                      cost: cost,
                                      reward: reward,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('20🪙 Hard'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ListTile(
                  //   title: Center(
                  //     child: const Text(
                  //       'Start Game',
                  //       style: TextStyle(
                  //         fontSize: 24,
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  //   iconColor: Colors.white,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(15),
                  //   ),
                  //   tileColor: Colors.white,
                  //   leading: const Icon(
                  //     Icons.play_arrow,
                  //     color: Colors.white,
                  //     size: 30,
                  //   ),
                  //   onTap: () {
                  //     // Add functionality for settings
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const PurplePage(),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      onPressed: () {
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
                                                    '2. Enter a number with no repeating digits (e.g., 1 4 7 3).\n\n',
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
                                                  Icons
                                                      .where_to_vote_outlined,
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
                                            padding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 32,
                                                  vertical: 16,
                                                ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 4,
                                            textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                                                TextSpan(
                                                  text: ' Ready to Play!',
                                                ),
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
                      child: Column(
                        children: [
                          const Text('🤔', style: TextStyle(fontSize: 36)),
                          const Text(
                            'How to play ?',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Help button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      onPressed: () {
                        // navigate to the high scores screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyBadgesScreen(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          const Text('🏅', style: TextStyle(fontSize: 36)),
                          Text('My badges : ${currencies.badgesUnlocked.length}/${currencies.badgesTotal}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GlossyButton(
                      text: "Language",
                      onPressed: () {
                        // navigate to the language selection screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FantasySettingsScreen(),
                          ),
                        );
                      },
                    ),
                    // (today.year == 2025 && today.month == 7 && (today.day == 11 || today.day == 12))?
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white.withOpacity(0.8),
                    //     foregroundColor: Colors.deepPurple,
                    //     padding: const EdgeInsets.all(5),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     elevation: 1,
                    //   ),
                    //   onPressed: () {
                    //     // navigate to the high scores screen
                    //     resetCoinsGems(currencies);
                    //   },
                    //   child: Column(
                    //     children: [
                    //       const Text('🪙', style: TextStyle(fontSize: 36)),
                    //       Text('Reset Coins & Gems',
                    //         style: TextStyle(fontSize: 14),
                    //       ),
                    //     ],
                    //   ),
                    // ) : const SizedBox(width: 10),
                  ),
                  const SizedBox(width: 10),
                  // Help button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      onPressed: () {
                        // navigate to the high scores screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GamesHistoryScreen(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          const Text('🎮', style: TextStyle(fontSize: 36)),
                          Text('My games',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
            //         'High Scores',
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
            //       Icons.emoji_events,
            //       color: Colors.orange,
            //       size: 30,
            //     ),
            //     onTap: () {
            //       // Add high scores functionality
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const HighScores(),
            //         ),
            //       );
            //     },
            //   ),
            // ),
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
            //         'Exit',
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
            //       Icons.exit_to_app,
            //       color: Colors.white,
            //       size: 30,
            //     ),
            //     onTap: () {
            //       // Add exit functionality
            //       // Navigator.of(context).pop();
            //       SystemNavigator.pop();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
