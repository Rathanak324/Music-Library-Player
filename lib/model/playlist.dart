import 'song.dart';

class Playlist {
  String id;
  String name;
  String? description;
  String? imagePath;
  DateTime dateCreated;
  List<Song>? songs= [];

  Playlist({
    required this.id,
    required this.name,
    this.description,
    this.imagePath,
    required this.dateCreated,
    this.songs,
  });
}