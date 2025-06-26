import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:numbersgame/audio_manager.dart';
import 'package:numbersgame/providers/currency_provider.dart';
// import 'package:numbersgame/screens/homemenu.dart';
import 'package:numbersgame/screens/homemenu2.dart';
import 'package:provider/provider.dart';
// import 'package:numbersgame/screens/homepage.dart';
// import 'package:numbersgame/screens/newtheme.dart';

late final ValueNotifier<String> playerName;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioManager().init();
  await initLocalStorage();

  await Hive.initFlutter();
  await Hive.openBox('unsyncedGames');

  if (await isConnected()){
    await syncWithServer();
  }

  playerName = ValueNotifier(localStorage.getItem('playerName') ?? '');
  // playerName = ValueNotifier('');
  playerName.addListener(() {
    localStorage.setItem('playerName', playerName.value);
  });
  runApp(
    ChangeNotifierProvider(
      create: (_) => CurrencyProvider()..loadCurrency(),
      child: const MyApp(),
    )
  );
}

Future<void> syncWithServer() async {
  // send the Hive unsynced games to the server
  final unsyncedGamesBox = Hive.box('unsyncedGames');
  final unsyncedGames = unsyncedGamesBox.values.toList();
  if (unsyncedGames.isNotEmpty) {
    try {
      // Here you would typically send the unsynced games to your server
      // For example, using an HTTP POST request
      final response = await http.post(
        Uri.parse('https://projects.zaradaly.com/numbersgame/sync.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(unsyncedGames),
      );
      print('Syncing with server...');
      print(response.body);
      if (response.statusCode != 200) {
        // Handle error
        print('Failed to sync with server: ${response.statusCode}');
        return;
      }
      
      // After successful sync, clear the unsynced games box
      await unsyncedGamesBox.clear();
    } catch (e) {
      print('Error syncing with server: $e');
      // Handle the error, e.g., log it or show a message to the user
    }
  }
}

Future<bool> isConnected() async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const HomeMenu(),
      home: const HomeMenu(),
    );
  }
}
