import '../model/song.dart';
import '../model/playlist.dart';
import '../model/playback_history.dart';

class MusicLibrary {
  final List<Song> songs = [];
  final List<Playlist> playlists = [];
  final List<PlaybackHistory> playbackHistory = [];

  DateTime _currentHistoryMonth = DateTime.now(); // used in function resetPlaybackHistoryEveryMonth()

  // Adding songs
  void addSong({required String songId, required String songTitle, required Duration duration, String? filePath}) {
    Song? song = _findSongOrNull(songId);
    if (song != null) {
      throw Exception('Song $song already exists');
    }

    songs.add(Song(
      id: songId,
      title: songTitle,
      filePath: filePath, // Assuming filePath is not provided here
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
    playlist.songs ??= [];

    if (playlist.songs!.contains(song)) {
      throw Exception('Song $songId already exists in playlist $playlistId');
    }
    // Initialize the songs list if it's null

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

  // Find a song by its ID, returning null if not found
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


  // Resets PlaybackHistory if month changes
  void resetPlaybackHistoryEveryMonth() {
    final now = DateTime.now();

    if (now.year != _currentHistoryMonth.year || now.month != _currentHistoryMonth.month) {
      playbackHistory.clear();
      _currentHistoryMonth = now;
    }
  }

  // Calculate total played time of a song
  Duration calculateTotalTimePlayed(String songId) {
    Duration total = Duration.zero; 

    for (final history in playbackHistory) {
      if (history.song.id == songId) {
        total = total + history.listenedDuration; 
      }
    }

    return total;
  }

  // Sort songs by title (asc/desc) 
  List<Song> sortSongsByTitle({required List<Song> songList, bool ascending = true}) {
    final sorted = [...(songList)];

    sorted.sort((a, b) => ascending
        ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
        : b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    return sorted;
  }

  // Sort song by duration (asc/desc)
  List<Song> sortSongsByDuration({required List<Song> songList, bool ascending = true}) {
    final sorted = [...(songList)];

    sorted.sort((a, b) => ascending
        ? a.duration.compareTo(b.duration)
        : b.duration.compareTo(a.duration));
    return sorted;
  }

  // Sort song by date added (asc/desc)
  List<Song> sortSongsByDateAdded({required List<Song> songList, bool ascending = true}) {
    final sorted = [...(songList)];

    sorted.sort((a, b) => ascending
        ? b.dateAdded.compareTo(a.dateAdded)
        : a.dateAdded.compareTo(b.dateAdded));
    return sorted;
  }

  // Sort playlists by title (asc/desc) 
  List<Playlist> sortPlaylistsByTitle({required List<Playlist> songList, bool ascending = true}) {
    final sorted = [...(songList)];

    sorted.sort((a, b) => ascending
        ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
        : b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    return sorted;
  }


  // Sort playlists by date added (asc/desc)
  List<Playlist> sortPlaylistByDateAdded({required List<Playlist> songList, bool ascending = true}) {
    final sorted = [...(songList)];

    sorted.sort((a, b) => ascending
        ? b.dateCreated.compareTo(a.dateCreated)
        : a.dateCreated.compareTo(b.dateCreated));
    return sorted;
  }
}