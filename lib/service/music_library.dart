import '../model/song.dart';
import '../model/playlist.dart';
import '../model/playback_history.dart';

class MusicLibrary {
  final List<Song> songs = [];
  final List<Playlist> playlists = [];
  final List<PlaybackHistory> playbackHistory = [];

  // Adding songs
  void addSong({required String songId, required String songTitle, required String artist, required Duration duration}) {
    Song? song = _findSongOrNull(songId);
    if (song != null) {
      throw Exception('Song $song already exists');
    }

    songs.add(Song(
      id: songId,
      title: songTitle,
      filePath: '', // Assuming filePath is not provided here
      duration: duration,
      dateAdded: DateTime.now(),
    ));
  }
  // Removing songs
  void removeSong({required String songId}) {
    Song? song = _findSongOrNull(songId);
    if (song == null) {
      throw Exception('Song $songId not found');
    }
    songs.removeWhere((s) => s.id == songId);
  }

  // Adding playlists
  void addPlaylist({required String playlistId, required String playlistName}) {
    Playlist? playlist = _findPlaylistOrNull(playlistId);
    if (playlist != null) {
      throw Exception('Playlist $playlistId already exists');
    }

    playlists.add(Playlist(
      id: playlistId,
      name: playlistName,
      dateCreated: DateTime.now()
    ));
  }

  // Removing playlists
  void removePlaylist({required String playlistId}) {
    Playlist? playlist = _findPlaylistOrNull(playlistId);
    if (playlist == null) {
      throw Exception('Playlist $playlistId not found');
    }
    playlists.removeWhere((p) => p.id == playlistId);
  }

  // Adding songs to playlists
  void addSongToPlaylist({required String songId, required String playlistId}) {
    Song? song = _findSongOrNull(songId);
    Playlist? playlist = _findPlaylistOrNull(playlistId);

    if (song == null) {
      throw Exception('Song $songId not found');
    }
    if (playlist == null) {
      throw Exception('Playlist $playlistId not found');
    }
    if (playlist.songs!.contains(song)) {
      throw Exception('Song $songId already exists in playlist $playlistId');
    }

    playlist.songs!.add(song);
  }

  // Removing song from playlist
  void removeSongFromPlaylist({required String songId, required String playlistId}){
    Song? song = _findSongOrNull(songId);
    Playlist? playlist = _findPlaylistOrNull(playlistId);

    if(song == null){
      throw Exception('Song $songId not found');
    }
    if(playlist == null){
      throw Exception('Playlist $playlistId not found');
    }
    if(!playlist.songs!.contains(song)){
      throw Exception('Song $songId does not exist in playlist $playlistId');
    }

    playlist.songs!.remove(song);
  }

  // Rename Song
  void renameSong({required String songId, required String newTitle}) {
    Song? song = _findSongOrNull(songId);
    if (song == null) {
      throw Exception('Song $songId not found');
    }
    song.title = newTitle;
  }

  // Rename Playlist
  void renamePlaylist({required String playlistId, required String newName}) {
    Playlist? playlist = _findPlaylistOrNull(playlistId);
    if (playlist == null) {
      throw Exception('Playlist $playlistId not found');
    }
    playlist.name = newName;
  }

  // Search for a song by title by each word in the title
  List<Song> searchSongsByTitle(String title) {
    if (title.trim().isEmpty) {
      return [];
    }

    List<String> words = title.toLowerCase().split(RegExp(r'\s+'));
    return songs.where((song) => words.every((word) => song.title.toLowerCase().contains(word))).toList();
  }

  Song? _findSongOrNull(String songId) {
    for (final song in songs) {
      if (song.id == songId) {
        return song;
      }
    }
    return null;
  }

  Playlist? _findPlaylistOrNull(String playlistId) {
    for (final playlist in playlists) {
      if (playlist.id == playlistId) {
        return playlist;
      }
    }
    return null;
  }
}