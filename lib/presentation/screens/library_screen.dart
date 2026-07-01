import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/local_song.dart';
import '../../logic/app/app_cubit.dart';
import '../widgets/song_art.dart';
import 'player_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          bottom: const TabBar(tabs: [
            Tab(text: 'Songs'),
            Tab(text: 'Albums'),
            Tab(text: 'Artists'),
            Tab(text: 'Playlists'),
          ]),
        ),
        body: const TabBarView(children: [_SongsList(), _AlbumsGrid(), _ArtistsList(), _PlaylistsList()]),
      ),
    );
  }
}

class _SongsList extends StatelessWidget {
  const _SongsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => ListView.builder(
        padding: const EdgeInsets.only(bottom: 96),
        itemCount: state.songs.length,
        itemBuilder: (context, index) => SongTile(song: state.songs[index]),
      ),
    );
  }
}

class SongTile extends StatelessWidget {
  const SongTile({super.key, required this.song});
  final LocalSong song;

  @override
  Widget build(BuildContext context) {
    final minutes = song.duration.inMinutes;
    final seconds = (song.duration.inSeconds % 60).toString().padLeft(2, '0');
    return ListTile(
      leading: SongArt(song: song),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text('$minutes:$seconds'),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(song: song))),
    );
  }
}

class _AlbumsGrid extends StatelessWidget {
  const _AlbumsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      final albums = state.albums.entries.toList();
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: .8),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final entry = albums[index];
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(song: entry.value.first))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: SongArt(song: entry.value.first, size: 320, radius: 8)),
              const SizedBox(height: 8),
              Text(entry.key, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text('${entry.value.length} songs', style: Theme.of(context).textTheme.bodySmall),
            ]),
          );
        },
      );
    });
  }
}

class _ArtistsList extends StatelessWidget {
  const _ArtistsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      final artists = state.artists.entries.toList();
      return ListView.builder(
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final entry = artists[index];
          final albums = entry.value.map((song) => song.album).toSet().length;
          return ListTile(
            leading: CircleAvatar(child: Text(entry.key.characters.first.toUpperCase())),
            title: Text(entry.key),
            subtitle: Text('${entry.value.length} songs - $albums albums'),
            trailing: const Icon(Icons.more_vert),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(song: entry.value.first))),
          );
        },
      );
    });
  }
}

class _PlaylistsList extends StatelessWidget {
  const _PlaylistsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      if (!state.isPaid) {
        return const Center(child: Text('Upgrade to Basic or Premium to create playlists.'));
      }
      if (state.playlists.isEmpty) {
        return const Center(child: Text('Your playlists will appear here.'));
      }
      return ListView(
        children: state.playlists
            .map((playlist) => ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: Text(playlist.name),
                  subtitle: Text('${playlist.songIds.length} songs'),
                ))
            .toList(),
      );
    });
  }
}
