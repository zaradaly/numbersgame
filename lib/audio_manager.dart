// import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final AudioPlayer backgroundPlayer = AudioPlayer();
  final AudioPlayer audioPlayer = AudioPlayer();

  AudioManager._internal();

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  Future<void> playBackgroundMusic(String assetPath) async {
    try {
      await backgroundPlayer.setAsset(assetPath);
      await backgroundPlayer.setLoopMode(LoopMode.one);
      // Optionally, you can set the volume for background music
      await backgroundPlayer.setVolume(0.1);
      await backgroundPlayer.play();
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  Future<void> playAudio(String assetPath) async {
    try {
      await audioPlayer.setAsset(assetPath);
      await audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> stopBackgroundMusic() async {
    await backgroundPlayer.stop();
  }

  void dispose() {
    backgroundPlayer.dispose();
    audioPlayer.dispose();
  }
}