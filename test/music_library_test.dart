import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_project/service/music_library.dart';

void main() {
test('addSong and removeSong work properly and throw on invalid IDs', () {
    final library = MusicLibrary();

    library.addSong(
      songId: 's1',
      songTitle: 'Song A',
      duration: const Duration(minutes: 3, seconds: 15),
      filePath: null,
    );
    expect(library.songs.length, 1);
    expect(library.songs.first.title, 'Song A');

    // Duplicate song ID should throw
    expect(
      () => library.addSong(
        songId: 's1',
        songTitle: 'Duplicate',
        duration: const Duration(minutes: 2),
        filePath: null,
      ),
      throwsException,
    );

    // Remove existing song
    library.removeSong(songId: 's1');
    expect(library.songs, isEmpty);

    // Removing non-existent song should throw
    expect(() => library.removeSong(songId: 's99'), throwsException);
  });

  test('addPlaylist and removePlaylist work properly and throw on invalid IDs', () {
    final library = MusicLibrary();

    library.addPlaylist(playlistId: 'p1', playlistName: 'Workout Mix');
    expect(library.playlists.length, 1);
    expect(library.playlists.first.name, 'Workout Mix');

    // Duplicate playlist ID should throw
    expect(
      () => library.addPlaylist(playlistId: 'p1', playlistName: 'Another Mix'),
      throwsException,
    );

    // Remove existing playlist
    library.removePlaylist(playlistId: 'p1');
    expect(library.playlists, isEmpty);

    // Removing non-existent playlist should throw
    expect(() => library.removePlaylist(playlistId: 'p99'), throwsException);
  });

test('addSongToPlaylist and removeSongFromPlaylist manage playlist songs', () {
    final library = MusicLibrary();

    library.addSong(
      songId: 's1',
      songTitle: 'Shape of You',
      duration: const Duration(minutes: 2, seconds: 30),
      filePath: null,
    );
    library.addPlaylist(playlistId: 'p1', playlistName: 'Favorites');

    // Add song to playlist
    library.addSongToPlaylist(songId: 's1', playlistId: 'p1');
    expect(library.playlists.first.songs!.length, 1);
    expect(library.playlists.first.songs!.first.id, 's1');

    // Adding the same song again should throw
    expect(
      () => library.addSongToPlaylist(songId: 's1', playlistId: 'p1'),
      throwsException,
    );

    // Missing song or playlist should throw
    expect(
      () => library.addSongToPlaylist(songId: 's2', playlistId: 'p1'),
      throwsException,
    );
    expect(
      () => library.addSongToPlaylist(songId: 's1', playlistId: 'p2'),
      throwsException,
    );

    // Remove song from playlist (song remains in main library)
    library.removeSongFromPlaylist(songId: 's1', playlistId: 'p1');
    expect(library.playlists.first.songs, isEmpty);
    expect(library.songs.length, 1);

    // Removing a song not in the playlist should throw
    expect(
      () => library.removeSongFromPlaylist(songId: 's1', playlistId: 'p1'),
      throwsException,
    );
  });

  test('renameSong and renamePlaylist update names and throw when not found', () {
    final library = MusicLibrary();

    library.addSong(
      songId: 's1',
      songTitle: 'Old Song Name',
      duration: const Duration(minutes: 3),
      filePath: null,
    );
    library.addPlaylist(playlistId: 'p1', playlistName: 'Old Playlist Name');

    library.renameSong(songId: 's1', newTitle: 'New Song Name');
    expect(library.songs.first.title, 'New Song Name');

    library.renamePlaylist(playlistId: 'p1', newName: 'New Playlist Name');
    expect(library.playlists.first.name, 'New Playlist Name');

    expect(() => library.renameSong(songId: 's2', newTitle: 'X'), throwsException);
    expect(() => library.renamePlaylist(playlistId: 'p2', newName: 'Y'), throwsException);
  });

  test('searchSongsByTitle matches by single letter, partial word, and multi-word', () {
    final library = MusicLibrary();

library.addSong(
      songId: 's1',
      songTitle: 'Midnight City',
      duration: const Duration(minutes: 4, seconds: 3),
      filePath: null,
    );
    library.addSong(
      songId: 's2',
      songTitle: 'Midnight Rain',
      duration: const Duration(minutes: 2, seconds: 54),
      filePath: null,
    );
    library.addSong(
      songId: 's3',
      songTitle: 'Hotel California',
      duration: const Duration(minutes: 6, seconds: 30),
      filePath: null,
    );

    // Empty or whitespace-only query returns empty list
expect(library.searchSongsByTitle(''), isEmpty);
    expect(library.searchSongsByTitle('   '), isEmpty);

    // Single letter search ('m' matches Midnight City & Midnight Rain)
    final letterResults = library.searchSongsByTitle('m');
    expect(letterResults.map((s) => s.id), ['s1', 's2']);

    // Multi-word out-of-order search with extra spaces
    final multiWordResults = library.searchSongsByTitle('  city   midnight  ');
    expect(multiWordResults.map((s) => s.id), ['s1']);

    // No match
    expect(library.searchSongsByTitle('midnight california'), isEmpty);
  });

  test('calculateTotalTimePlayed sums listenedDuration for a specific song', () {
    final library = MusicLibrary();

    library.addSong(
      songId: 's1',
      songTitle: 'Cruel Summer',
      duration: const Duration(minutes: 2, seconds: 58),
      filePath: null,
    );
    library.addSong(
      songId: 's2',
      songTitle: 'Levitating',
      duration: const Duration(minutes: 3, seconds: 23),
      filePath: null,
    );


    library.addPlaybackHistory(playbackHistoryId: 'h1', songId: 's1', listenedDuration: const Duration(minutes: 1, seconds: 30));
    library.addPlaybackHistory(playbackHistoryId: 'h2', songId: 's1', listenedDuration: const Duration(minutes: 1, seconds: 30));
    library.addPlaybackHistory(playbackHistoryId: 'h3', songId: 's2', listenedDuration: const Duration(minutes: 1, seconds: 30));
      

    expect(
      library.calculateTotalTimePlayed('s1'),
      const Duration(minutes: 3, seconds: 00),
    );
    expect(
      () => library.calculateTotalTimePlayed('unknown'),throwsException );
  });

  test('sort songs ascending and descending', () {
    final library = MusicLibrary();

    library.addSong(
      songId: 's1',
      songTitle: 'Yellow',
      duration: const Duration(minutes: 2, seconds: 58),
      filePath: null,
      dateAdded: DateTime(2026, 1, 1),
    );
    library.addSong(
      songId: 's2',
      songTitle: 'Attention',
      duration: const Duration(minutes: 1, seconds: 20),
      filePath: null,
      dateAdded: DateTime(2026, 1, 3),
    );
    library.addSong(
      songId: 's3',
      songTitle: 'Perfect',
      duration: const Duration(minutes: 2, seconds: 23),
      filePath: null,
      dateAdded: DateTime(2026, 1, 2),
    );

   
    expect(
      library.sortSongsByTitle(songList: library.songs, ascending: true).map((s) => s.title),
      ['Attention', 'Perfect', 'Yellow'],
    );
    expect(
      library.sortSongsByTitle(songList: library.songs, ascending: false).map((s) => s.title),
      ['Yellow', 'Perfect', 'Attention'],
    );

    expect(
      library.sortSongsByDuration(songList: library.songs, ascending: true).map((s) => s.id),
      ['s2', 's3', 's1'],
    );
    expect(
      library.sortSongsByDuration(songList: library.songs, ascending: false).map((s) => s.id),
      ['s1', 's3', 's2'],
    );

    expect(
      library.sortSongsByDateAdded(songList: library.songs, ascending: true).map((s) => s.id),
      ['s1', 's3', 's2'],
    );
    expect(
      library.sortSongsByDateAdded(songList: library.songs, ascending: false).map((s) => s.id),
      ['s2', 's3', 's1'],
    );
  });

  test('sortPlaylistsByTitle sorts ascending and descending', () {
    final library = MusicLibrary();

    library.addPlaylist(
      playlistId: 'p1',
      playlistName: 'Workout',
      dateAdded: DateTime(2026, 1, 1),
    );
    library.addPlaylist(
      playlistId: 'p2',
      playlistName: 'chill',
      dateAdded: DateTime(2026, 1, 3),
    );
    library.addPlaylist(
      playlistId: 'p3',
      playlistName: 'Party Mix',
      dateAdded: DateTime(2026, 1, 2),
    );

    expect(
      library.sortPlaylistsByTitle(songList: library.playlists, ascending: true).map((p) => p.name),
      ['chill', 'Party Mix', 'Workout'],
    );
    expect(
      library.sortPlaylistsByTitle(songList: library.playlists, ascending: false).map((p) => p.name),
      ['Workout', 'Party Mix', 'chill'],
    );

    expect(library.playlists.map((p) => p.id), ['p1', 'p2', 'p3']);
  });

  test('sortPlaylistByDateAdded sorts ascending (oldest first) and descending (newest first)', () {
    final library = MusicLibrary();

    library.addPlaylist(
      playlistId: 'p1',
      playlistName: 'Workout',
      dateAdded: DateTime(2026, 1, 1),
    );
    library.addPlaylist(
      playlistId: 'p2',
      playlistName: 'Chill',
      dateAdded: DateTime(2026, 1, 3),
    );
    library.addPlaylist(
      playlistId: 'p3',
      playlistName: 'Party',
      dateAdded: DateTime(2026, 1, 2),
    );

    expect(
      library.sortPlaylistByDateAdded(songList: library.playlists, ascending: true).map((p) => p.id),
      ['p1', 'p3', 'p2'],
    );
    expect(
      library.sortPlaylistByDateAdded(songList: library.playlists, ascending: false).map((p) => p.id),
      ['p2', 'p3', 'p1'],
    );

    expect(library.playlists.map((p) => p.id), ['p1', 'p2', 'p3']);
  });

}

