import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:numbersgame/models/player_currency.dart';

class CurrencyProvider extends ChangeNotifier {
  PlayerCurrencies _currency = PlayerCurrencies(
    coins: 200,
    gems: 20,
    badgesUnlocked: <Map<String, String>>[],
    totalWins: 0,
    totalGames: 0,
    currentWinStreak: 0,
    badgesPending: List.empty(growable: true),
    badgesTotal: 24, // Assuming total badges are constant
  );

  PlayerCurrencies get currency => _currency;

  // loadCurrency method to fetch values from Hive or initialize them
  Future<void> loadCurrency() async {
    final box = await Hive.openBox('playerCurrency');
    if (box.isNotEmpty) {
      _currency = PlayerCurrencies(
        coins: box.get('coins', defaultValue: 0),
        gems: box.get('gems', defaultValue: 0),
        badgesUnlocked: List<Map<String, String>>.from(
          (box.get('badgesUnlocked', defaultValue: <Map<String, String>>[]) as List)
              .map((item) => Map<String, String>.from(item ?? {}))
        ),
        currentWinStreak: box.get('currentWinStreak', defaultValue: 0),
        totalWins: box.get('totalWins', defaultValue: 0),
        totalGames: box.get('totalGames', defaultValue: 0),
        badgesPending: List<String>.from(box.get('badgesPending', defaultValue: <String>[])),
        badgesTotal: 24, // Assuming total badges are constant
      );
    } else {
      // Initialize with default values if box is empty
      _currency = PlayerCurrencies(
        coins: 200,
        gems: 10,
        badgesUnlocked: <Map<String, String>>[],
        currentWinStreak: 0,
        totalWins: 0,
        totalGames: 0,
        badgesPending: <String>[],
        badgesTotal: 24, // Assuming total badges are constant
      );
      // Save initial values to Hive
      await box.put('coins', _currency.coins);
      await box.put('gems', _currency.gems);
      await box.put('badgesUnlocked', _currency.badgesUnlocked);
      await box.put('currentWinStreak', _currency.currentWinStreak);
      await box.put('totalWins', _currency.totalWins);
      await box.put('totalGames', _currency.totalGames);
      await box.put('badgesPending', _currency.badgesPending);
    }
    // display the PlayerCurrencies object
    print('Loaded PlayerCurrencies: $_currency');
    // Notify listeners to update the UI
    notifyListeners();
  }

  void updateCurrencies({int? coins, int? gems, List<Map<String, String>>? badgesUnlocked, int? currentWinStreak, List<String>? badgesPending}) {
    if (coins != null) _currency.coins = coins;
    if (gems != null) _currency.gems = gems;
    if (badgesUnlocked != null) _currency.badgesUnlocked = badgesUnlocked;
    if (currentWinStreak != null) _currency.currentWinStreak = currentWinStreak;
    if (badgesPending != null) _currency.badgesPending = badgesPending;
    notifyListeners();
  }

  void deductCoins(int i) {
    if (_currency.coins >= i) {
      _currency.coins -= i;
      print('Deducted $i coins. Remaining coins: ${_currency.coins}');
      notifyListeners();
      // Save to Hive
      Hive.box('playerCurrency').put('coins', _currency.coins);
    } else {
      print('Not enough coins to deduct $i coins');
    }
  }

  void addCoins(int i) {
    _currency.coins += i;
    print('Added $i coins. Total coins: ${_currency.coins}');
    notifyListeners();
    // Save to Hive
    Hive.box('playerCurrency').put('coins', _currency.coins);
  }

  void addGems(int i) {
    _currency.gems += i;
    notifyListeners();
    // Save to Hive
    Hive.box('playerCurrency').put('gems', _currency.gems);
  }
  void deductGems(int i) {
    if (_currency.gems >= i) {
      _currency.gems -= i;
      notifyListeners();
      // Save to Hive
      Hive.box('playerCurrency').put('gems', _currency.gems);
    } else {
      print('Not enough gems to deduct $i gems');
    }
  }

  void addWinStreak() {
    _currency.currentWinStreak += 1;
    notifyListeners();
    // Save to Hive
    Hive.box('playerCurrency').put('currentWinStreak', _currency.currentWinStreak);
  }
  void resetWinStreak() {
    _currency.currentWinStreak = 0;
    notifyListeners();
    // Save to Hive
    Hive.box('playerCurrency').put('currentWinStreak', _currency.currentWinStreak);
  }

  void addWin() {
    _currency.totalWins += 1;
    _currency.totalGames += 1;
    notifyListeners();
    // Save to Hive
    Hive.box('playerCurrency').put('totalWins', _currency.totalWins);
    Hive.box('playerCurrency').put('totalGames', _currency.totalGames);
  }

  void addGame() {
    _currency.totalGames += 1;
    notifyListeners();
    // Save to Hive
    Hive.box('playerCurrency').put('totalGames', _currency.totalGames);
  }
  
  void unlockBadge(String badgeName, String badgeImage) {
    // Check if badge is already unlocked by looking for the badgeName in the list
    bool isAlreadyUnlocked = _currency.badgesUnlocked.any((badge) => badge['badgeName'] == badgeName);
    
    if (!isAlreadyUnlocked) {
      _currency.badgesUnlocked.add({'badgeName': badgeName, 'image': badgeImage});
      _currency.badgesPending.add(badgeName);
      print('Badge $badgeName unlocked. Total badges unlocked: ${_currency.badgesUnlocked.length}');
      notifyListeners();
      // Save to Hive
      Hive.box('playerCurrency').put('badgesUnlocked', _currency.badgesUnlocked);
      Hive.box('playerCurrency').put('badgesPending', _currency.badgesPending);
    } else {
      print('Badge $badgeName is already unlocked.');
    }
  }

  bool isBadgeUnlocked(String badgeName) {
    return _currency.badgesUnlocked.any((badge) => badge['badgeName'] == badgeName);
  }

  List<String> getUnlockedBadgeNames() {
    return _currency.badgesUnlocked
        .map((badge) => badge['badgeName'] ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

}
