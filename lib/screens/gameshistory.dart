// GamesHistory class to display the history of games played
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GamesHistoryScreen extends StatelessWidget {
  const GamesHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // get unsynced games from Hiv0e
    final unsyncedGamesBox = Hive.box('unsyncedGames');
    final unsyncedGames = unsyncedGamesBox.values.toList();
    print(unsyncedGames);

    return Scaffold(
      appBar: AppBar(title: const Text('Games History')),
      body: ListView.builder(
        reverse: true,
        itemCount: unsyncedGames.length,
        itemBuilder: (context, index) {
          final game = unsyncedGames[index];
          print(game);
          final gameData = game as Map<dynamic, dynamic>;
          final attempts = gameData['numberGuesses'] ?? 0;
          return ListTile(
            // leading: CircleAvatar(child: Text(playerName[0].toUpperCase())),
            // title: Text(playerName),
            subtitle: Text(
              'Attempts: $attempts\nDifficulty: ${gameData['mode'] ?? 'Unknown'}\nReward: ${gameData['reward_coins'] ?? 0} 🪙\nReward: ${gameData['reward_gems']} 💎\nWon: ${gameData['won'] ?? false ? 'Yes 🏆' : 'No'}\nStarted at: ${gameData['started_at'] != null ? gameData['started_at'].substring(0,16) : 'N/A'}',
            ),
          );
        },
      ),
    );
  }
}
