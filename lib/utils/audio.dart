import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class Audio {
  static const move = 'move2.wav';
  static const lose = 'lose.wav';
  static const win = 'win.wav';
  static const click='click.wav';
  static const eat='eat.mp3';
  static const select='select.wav';
  static AudioPlayer audioPlayer = AudioPlayer()
    ..audioCache = AudioCache(prefix: 'assets/audio/');

  static Future<void> play(String name) async {
    await audioPlayer.play(AssetSource(name));
  }
}
