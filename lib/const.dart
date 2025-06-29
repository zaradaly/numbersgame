import 'package:flutter/material.dart';

var whiteTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 32,
  fontWeight: FontWeight.bold,
);

// List<String> numberPad = [
//   '7', '8', '9', 'C',
//   '4', '5', '6', 'DEL',
//   '1', '2', '3', '=',
//   '0', '', '', '',
// ];

List<String> numberPad = [
  '7',
  '8',
  '9',
  '4',
  '5',
  '6',
  '1',
  '2',
  '3',
  '0',
  '',
  '⌫',
];

// list of trophy badges according to how many games the player has won
var trophyBadges = [
  {
    'name': 'Beginner',
    'description': 'You have won your first game!',
    'image_asset': 'assets/images/badges/win1.png',
    'winsRequired': 1,
  },
  {
    'name': 'Intermediate',
    'description': 'You have won 5 games!',
    'image_asset': 'assets/images/badges/win5.png',
    'winsRequired': 5,
  },
  {
    'name': 'Advanced',
    'description': 'You have won 10 games!',
    'image_asset': 'assets/images/badges/win20.png',
    'winsRequired': 20,
  },
  {
    'name': 'Expert',
    'description': 'You have won 20 games!',
    'image_asset': 'assets/images/badges/win50.png',
    'winsRequired': 50,
  },
  {
    'name': 'Master',
    'description': 'You have won 50 games!',
    'image_asset': 'assets/images/badges/win100.png',
    'winsRequired': 100,
  },
  {
    'name': 'Legend',
    'description': 'You have won 100 games!',
    'image_asset': 'assets/images/badges/win200.png',
    'winsRequired': 200,
  }
];

// list of trophy badges according to how many games the player has won in a row
var streakBadges = [
  {
    'name': 'Streak Beginner',
    'description': 'You have won 3 games in a row!',
    'image_asset': 'assets/images/badges/streak3.png',
    'streakRequired': 3,
  },
  {
    'name': 'Streak Intermediate',
    'description': 'You have won 5 games in a row!',
    'image_asset': 'assets/images/badges/streak5.png',
    'streakRequired': 5,
  },
  {
    'name': 'Streak Advanced',
    'description': 'You have won 10 games in a row!',
    'image_asset': 'assets/images/badges/streak10.png',
    'streakRequired': 10,
  },
  {
    'name': 'Streak Expert',
    'description': 'You have won 20 games in a row!',
    'image_asset': 'assets/images/badges/streak20.png',
    'streakRequired': 20,
  },
  {'name': 'Streak Master',
    'description': 'You have won 50 games in a row!',
    'image_asset': 'assets/images/badges/streak50.png',
    'streakRequired': 50,
  },
];
