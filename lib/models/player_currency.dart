class PlayerCurrencies {
  int coins;
  int gems;
  List<Map<String, String>> badgesUnlocked;
  int currentWinStreak;
  int totalWins;
  int totalGames;
  List<String> badgesPending;
  int badgesTotal;

  PlayerCurrencies({
    required this.coins,
    required this.gems,
    required this.badgesUnlocked,
    required this.currentWinStreak,
    required this.totalWins,
    required this.totalGames,
    required this.badgesPending,
    required this.badgesTotal,
  });

   void showData() {
    print('PlayerCurrencies:');
    print('Coins: ${coins}');
    print('Gems: ${gems}');
    print('Badges Unlocked: ${badgesUnlocked}');
    print('Current Win Streak: ${currentWinStreak}');
    print('Total Wins: ${totalWins}');
    print('Total Games: ${totalGames}');
    print('Badges Pending: ${badgesPending}');
    print('Total Badges: ${badgesTotal}');
  }
}