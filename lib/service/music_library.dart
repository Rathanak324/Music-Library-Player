import '../model/song.dart';
import '../model/playlist.dart';
import '../model/playback_history.dart';

class MusicLibrary {
  final List<Song> songs = [];
  final List<Playlist> playlists = [];
  final List<PlaybackHistory> playbackHistory = [];

  // Adding and removing songs
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

  void removeSong({required String songId}) {
    Song? song = _findSongOrNull(songId);
    if (song == null) {
      throw Exception('Song $songId not found');
    }
    songs.removeWhere((s) => s.id == songId);
  }

  // Adding and removing playlists
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

  void removePlaylist({required String playlistId}) {
    Playlist? playlist = _findPlaylistOrNull(playlistId);
    if (playlist == null) {
      throw Exception('Playlist $playlistId not found');
    }
    playlists.removeWhere((p) => p.id == playlistId);
  }

  // Adding and removing songs from playlists (Still working on this)
  void addSongToPlaylist({required String songId, required String playlistId}) {
    Song? song = _findSongOrNull(songId);
    Playlist? playlist = _findPlaylistOrNull(playlistId);

    if (song == null) {
      throw Exception('Song $songId not found');
    }
    if (playlist == null) {
      throw Exception('Playlist $playlistId not found');
    }

    playlist.songs ??= [];
    playlist.songs!.add(song);
  }

  // Adding playback history (Not finished)
  void addPlaybackHistory(PlaybackHistory history) {
    playbackHistory.add(history);

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