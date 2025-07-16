import 'package:flutter/material.dart';
import 'package:numbersgame/widgets/FantasyGoldButton.dart';
import 'package:numbersgame/widgets/FantasyIconToggle.dart';

class FantasySettingsScreen extends StatefulWidget {
  const FantasySettingsScreen({Key? key}) : super(key: key);

  @override
  _FantasySettingsScreenState createState() => _FantasySettingsScreenState();
}

class _FantasySettingsScreenState extends State<FantasySettingsScreen> {
  bool soundOn = true;
  bool musicOn = false;

  @override
  Widget build(BuildContext context) {
    final gold = Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: Color(0xFF121212), // dark background
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24),
            Text(
              "Settings",
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 28,
                color: gold,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    color: Colors.black87,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Top toggles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FantasyIconToggle(
                  icon: Icons.volume_up,
                  isActive: soundOn,
                  onPressed: () {
                    setState(() {
                      soundOn = !soundOn;
                    });
                  },
                ),
                SizedBox(width: 20),
                FantasyIconToggle(
                  icon: Icons.music_note,
                  isActive: musicOn,
                  onPressed: () {
                    setState(() {
                      musicOn = !musicOn;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 32),

            // Buttons
            FantasyGoldButton(
              text: "Language",
              onPressed: () {},
            ),
            FantasyGoldButton(
              text: "Game Progress",
              onPressed: () {},
            ),
            FantasyGoldButton(
              text: "About Product",
              onPressed: () {},
            ),

            Spacer(),

            // Bottom row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FantasyIconToggle(
                  icon: Icons.emoji_events, // crown icon
                  isActive: false,
                  onPressed: () {},
                ),
                FantasyIconToggle(
                  icon: Icons.settings, // gear icon
                  isActive: false,
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 24),

            // Back button
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: gold, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black45,
                    ),
                    child: Icon(Icons.arrow_back, color: gold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
