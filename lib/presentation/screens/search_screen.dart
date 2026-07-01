import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/app/app_cubit.dart';
import 'library_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: context.read<AppCubit>().setQuery,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic_none),
                hintText: 'Search songs, artists, albums...',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                final songs = state.filteredSongs;
                if (songs.isEmpty) return const Center(child: Text('No songs found.'));
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) => SongTile(song: songs[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
