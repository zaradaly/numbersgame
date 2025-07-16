// GamesHistory class to display the history of games played
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GamesHistoryScreen extends StatelessWidget {
  const GamesHistoryScreen({Key? key}) : super(key: key);

  Color _getDifficultyColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'easy':
        return Colors.green.shade600;
      case 'normal':
        return Colors.orange.shade600;
      case 'hard':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    // get unsynced games from Hiv0e
    final unsyncedGamesBox = Hive.box('unsyncedGames');
    final unsyncedGames = unsyncedGamesBox.values.toList();
    print(unsyncedGames);

    final _listViewController = ScrollController();

    // Scroll to bottom after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_listViewController.hasClients) {
        _listViewController.animateTo(
          _listViewController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Games History')),
      body: ListView.builder(
        reverse: true,
        controller: _listViewController,
        itemCount: unsyncedGames.length,
        itemBuilder: (context, index) {
          final game = unsyncedGames[index];
          print(game);
          final gameData = game as Map<dynamic, dynamic>;
          final attempts = gameData['numberGuesses'] ?? 0;
          final won = gameData['won'] ?? false;
          final mode = gameData['mode'] ?? 'Unknown';
          final coins = gameData['reward_coins'] ?? 0;
          final gems = gameData['reward_gems'] ?? 0;
          final startedAt = gameData['started_at'] != null 
              ? gameData['started_at'].substring(0, 16) 
              : 'N/A';
          
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: won 
                      ? [Colors.green.shade50, Colors.green.shade100]
                      : [Colors.red.shade50, Colors.red.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with result and difficulty
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12, 
                            vertical: 6
                          ),
                          decoration: BoxDecoration(
                            color: won ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                won ? Icons.emoji_events : Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                won ? 'Won' : 'Lost',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, 
                            vertical: 4
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(mode),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            mode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Attempts row
                    Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          color: Colors.deepPurple.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Attempts: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$attempts',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.deepPurple.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Rewards row (only show if there are rewards)
                    if (coins > 0 || gems > 0) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            color: Colors.amber.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rewards: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (coins > 0) ...[
                            Text(
                              '$coins 🪙',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (gems > 0) const SizedBox(width: 8),
                          ],
                          if (gems > 0)
                            Text(
                              '$gems 💎',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    
                    // Date row
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          startedAt,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
