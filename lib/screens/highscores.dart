// create widget that gets data from api and displays it in a list view

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:numbersgame/models/score.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HighScores extends StatefulWidget {
  const HighScores({Key? key}) : super(key: key);

  @override
  _HighScoresState createState() => _HighScoresState();
}

class _HighScoresState extends State<HighScores> {
  List<Score> scores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Future<void> fetchScores() async {
    final response = await http.get(
      Uri.parse('https://projects.zaradaly.com/numbersgame/highscores.php'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        scores = jsonData.map((json) => Score.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load scores');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
        backgroundColor: Colors.deepPurple[300],
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: Colors.deepPurple[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // add image at the top
                Image.asset(
                  'assets/images/trophy.gif',
                  // height: 100,
                  width: 200,
                ),
                const SizedBox(height: 10),
                Text(
                  'Below are the top scores achieved by players. Try to beat them by playing the Numbers Game!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      final score = scores[index];
                      // add trophy leading icon for top 3 scores
                      Icon? leadingIcon;
                      Color bgColor = Colors.white.withOpacity(0.8);
                      if (index == 0) {
                        leadingIcon = const Icon(
                          Icons.emoji_events,
                          color: Colors.orange,
                          size: 45,
                        );
                      } else if (index == 1) {
                        leadingIcon = const Icon(
                          Icons.workspace_premium,
                          color: Colors.grey,
                          size: 45,
                        );
                      } else if (index == 2) {
                        leadingIcon = const Icon(
                          Icons.workspace_premium,
                          color: Colors.brown,
                          size: 45,
                        );
                      } else {
                        leadingIcon = null;
                      }
                      // return list tile with leading icon if available
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical:10),
                        child: Column(
                          children: [
                            Material(
                              elevation: (index < 3 )? (9 - ((index).toDouble()*3) ) : 0,
                              // shadowColor: Colors.yellow,
                              borderRadius: BorderRadius.circular(10),
                              color: bgColor,
                              // color: Colors.white,
                              child: ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
                                leading: leadingIcon,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                title: Row(
                                  children: [
                                    Text(score.username),
                                    // if country code is not null, show flag icon
                                    if (score.country_code != null &&
                                        score.country_code!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: SvgPicture.asset(
                                          'assets/svgs/flags/${score.country_code!.toLowerCase()}.svg',
                                          width: 14,
                                          height: 14,
                                          placeholderBuilder: (context) => const CircularProgressIndicator(),
                                          errorBuilder: (context, error, stackTrace) => const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    // if country code is null, show a placeholder icon
                                    if (score.country_code == null ||
                                        score.country_code!.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: const Icon(
                                          Icons.flag,
                                          color: Colors.grey,
                                          size: 24,
                                        ),
                                      ),
                                    
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Score: ${score.score}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(
                                      'Guesses: ${score.num_guesses}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                // tileColor: bgColor,
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(10),
                                //   side: BorderSide(
                                //     color: Colors.grey.shade300,
                                //     width: 1.0,
                                //   ),
                                // ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
