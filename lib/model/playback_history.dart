import 'song.dart';


class PlaybackHistory {
  String id;
  Song song;
  DateTime playedAt;
  Duration listenedDuration;

  PlaybackHistory({
    required this.id,
    required this.song,
    required this.playedAt,
    required this.listenedDuration,
  });

}