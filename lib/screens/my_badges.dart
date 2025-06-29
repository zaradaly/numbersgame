import 'package:flutter/material.dart';
import 'package:numbersgame/const.dart';
import 'package:numbersgame/providers/currency_provider.dart';
import 'package:numbersgame/screens/badge.dart';
import 'package:provider/provider.dart';

class MyBadgesScreen extends StatelessWidget {
  const MyBadgesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = context.watch<CurrencyProvider>().currency;
    final badges = currencies.badgesUnlocked;
    print(badges);

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(title: const Text('My Badges')),
        body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/trophy.gif',
                  height: 120,
                  // width: 200,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Unlock more badges by playing the game and achieving milestones!',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TabBar(
                labelColor: Colors.deepPurple,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.deepPurple,
                tabs: [
                  Tab(text: '🏆 Trophy'),
                  Tab(text: '🔥 Streak'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                      itemCount: trophyBadges.length,
                      itemBuilder: (context, index) {
                        return BadgeWidget(
                          badgeName: trophyBadges[index]['name'].toString(),
                          badgeIcon: trophyBadges[index]['image_asset']
                              .toString(),
                          unlocked: badges.any(
                            (badge) =>
                                badge['badgeName'] ==
                                trophyBadges[index]['name'].toString(),
                          ),
                          description: trophyBadges[index]['description'].toString(),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                      itemCount: streakBadges.length,
                      itemBuilder: (context, index) {
                        return BadgeWidget(
                          badgeName: streakBadges[index]['name'].toString(),
                          badgeIcon: streakBadges[index]['image_asset']
                              .toString(),
                          unlocked: badges.any(
                            (badge) =>
                                badge['badgeName'] ==
                                streakBadges[index]['name'].toString(),
                          ),
                          description: streakBadges[index]['description'].toString(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
