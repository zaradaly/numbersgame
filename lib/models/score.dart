class Score {
  final String username;
  final int score;
  final int num_guesses;
  final String? country_code;

  Score({required this.username, required this.score, required this.num_guesses, required this.country_code});

  // Factory method to create a Score object from a JSON map
  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      username: json['username'] as String,
      score: json['score'] as int,
      num_guesses: json['num_guesses'] as String == 'null'
          ? 0
          : int.parse(json['num_guesses'] as String),
      country_code: json['country_code'] as String?,
    );
  }

  // Method to convert a Score object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'score': score,
      'num_guesses': num_guesses,
      'country_code': country_code ?? '',
    };
  }
}