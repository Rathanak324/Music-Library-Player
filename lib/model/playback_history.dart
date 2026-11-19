import 'song.dart';


class PlaybackHistory {
  String id;
  Song song;
  Duration listenedDuration;

  PlaybackHistory({
    required this.id,
    required this.song,
    required this.listenedDuration,
  });

}