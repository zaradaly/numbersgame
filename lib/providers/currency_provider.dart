import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:numbersgame/main.dart';
import 'dart:convert';

import 'package:numbersgame/models/player_currency.dart';

class CurrencyProvider extends ChangeNotifier {
  PlayerCurrencies _currency = PlayerCurrencies(
    coins: 0,
    gems: 0,
    badgesUnlocked: 0,
    badgesTotal: 24,
  );

  PlayerCurrencies get currency => _currency;

  Future<void> loadCurrency() async {
    final box = await Hive.openBox('playerCurrency');
    print('Loading player currency from Hive box');
    // Check if internet connection is available
    if (await isConnected()) {
      try {
        // get data from API
        final response = await http.post(
          Uri.parse('https://projects.zaradaly.com/numbersgame/playerstats.php'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'playerName': playerName.value}),
        );
        var data = null;
        if (response.statusCode == 200) {
          data = json.decode(response.body);
          // _currency = PlayerCurrencies(
          //   coins: data['coins'] ?? 0,
          //   gems: data['gems'] ?? 0,
          //   badgesUnlocked: data['badgesUnlocked'] ?? 0,
          //   badgesTotal: data['badgesTotal'] ?? 24,
          // );
        }

        // check if API data is different from Hive
        if (data != null && box.isNotEmpty) {
          final coins = box.get('coins', defaultValue: 0);
          final gems = box.get('gems', defaultValue: 0);
          final badgesUnlocked = box.get('badgesUnlocked', defaultValue: 0);
          final badgesTotal = box.get('badgesTotal', defaultValue: 24);

          if (data.isNotEmpty &&
              data['coins'] != null &&
              data['gems'] != null &&
              data['badgesUnlocked'] != null &&
              data['badgesTotal'] != null) {
            if (data['coins'] != coins ||
                data['gems'] != gems ||
                data['badgesUnlocked'] != badgesUnlocked ||
                data['badgesTotal'] != badgesTotal) {
              // Update Hive with API data
              await box.put('coins', data['coins']);
              await box.put('gems', data['gems']);
              await box.put('badgesUnlocked', data['badgesUnlocked']);
              await box.put('badgesTotal', data['badgesTotal']);
            }
          }
        }
      } catch (e) {
        print('Error fetching player currency from API: $e');
      }
    } 
    else {
      if (box.isEmpty) {
        // If Hive is empty, initialize with default values
        await box.put('coins', 10);
        await box.put('gems', 15);
        await box.put('badgesUnlocked', 2);
        await box.put('badgesTotal', 24);
      }
    }
    // Open the Hive box for player currency
    // final box = await Hive.openBox('playerCurrency');

    // if (box.isEmpty) {
    //   // Save API data to Hive
    //   await box.put('coins', (data.isNotEmpty && data['coins'] != null) ? data['coins'] : 0);
    //   await box.put('gems', (data.isNotEmpty && data['gems'] != null) ? data['gems'] : 0);
    //   await box.put('badgesUnlocked', (data.isNotEmpty && data['badgesUnlocked'] != null) ? data['badgesUnlocked'] : 0);
    //   await box.put('badgesTotal', (data.isNotEmpty && data['badgesTotal'] != null) ? data['badgesTotal'] : 24);
    // }

    _currency = PlayerCurrencies(
      coins: box.get('coins', defaultValue: 0),
      gems: box.get('gems', defaultValue: 0),
      badgesUnlocked: box.get('badgesUnlocked', defaultValue: 0),
      badgesTotal: box.get('badgesTotal', defaultValue: 24),
    );

    // For now, we just use the initial values
    notifyListeners();
  }

  void updateCurrencies({int? coins, int? gems, int? badgesUnlocked}) {
    if (coins != null) _currency.coins = coins;
    if (gems != null) _currency.gems = gems;
    if (badgesUnlocked != null) _currency.badgesUnlocked = badgesUnlocked;
    notifyListeners();
  }

  void deductCoins(int i) {
    if (_currency.coins >= i) {
      _currency.coins -= i;
      notifyListeners();
      // Save to Hive
      Hive.box('playerCurrency').put('coins', _currency.coins);
    } else {
      print('Not enough coins to deduct $i coins');
    }
  }
}
