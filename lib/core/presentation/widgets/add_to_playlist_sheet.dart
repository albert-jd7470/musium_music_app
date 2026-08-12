import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/playlist_provider.dart';
import '../../../../core/models/playlist_model.dart';
import '../../../../features/search_screen/data/models/song_model.dart';

/// Shows a bottom-sheet for selecting / creating a playlist and adding a song.
Future<void> showAddToPlaylistSheet(BuildContext context, SongModel song) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF1E1E24),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _AddToPlaylistSheet(song: song),
  );
}

class _AddToPlaylistSheet extends StatefulWidget {
  final SongModel song;
  const _AddToPlaylistSheet({required this.song});

  @override
  State<_AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<_AddToPlaylistSheet> {
  bool _isCreating = false;
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlaylistProvider>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add to Playlist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isCreating = !_isCreating),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1ED760).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isCreating ? Icons.close : Icons.add,
                          color: const Color(0xFF1ED760),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isCreating ? 'Cancel' : 'New',
                          style: const TextStyle(
                            color: Color(0xFF1ED760),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Create new playlist inline
          if (_isCreating)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Playlist name…',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1ED760)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      if (_ctrl.text.trim().isEmpty) return;
                      final newPl = await provider.createPlaylist(_ctrl.text);
                      await _addSongTo(context, provider, newPl);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1ED760),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child: const Text('Create & Add',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

          // Existing playlists list
          if (provider.playlists.isEmpty && !_isCreating)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Text(
                'No playlists yet. Tap "New" to create one.',
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: provider.playlists.length,
                itemBuilder: (context, index) {
                  final pl = provider.playlists[index];
                  final alreadyAdded = pl.containsSong(widget.song.id);
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: pl.songs.isNotEmpty
                          ? Image.network(
                              pl.songs.first.bestImageUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            )
                          : _placeholder(),
                    ),
                    title: Text(
                      pl.title,
                      style: TextStyle(
                        color: alreadyAdded ? Colors.white38 : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      alreadyAdded
                          ? 'Already added'
                          : '${pl.songs.length} song${pl.songs.length == 1 ? '' : 's'}',
                      style: TextStyle(
                        color: alreadyAdded
                            ? const Color(0xFF1ED760).withOpacity(0.6)
                            : Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                    trailing: alreadyAdded
                        ? const Icon(Icons.check_circle,
                            color: Color(0xFF1ED760), size: 22)
                        : const Icon(Icons.add_circle_outline,
                            color: Colors.white54, size: 22),
                    onTap: alreadyAdded
                        ? null
                        : () => _addSongTo(context, provider, pl),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 48,
        height: 48,
        color: const Color(0xFF2A2A35),
        child: const Icon(Icons.queue_music, color: Colors.white24, size: 24),
      );

  Future<void> _addSongTo(
      BuildContext context, PlaylistProvider provider, PlaylistModel pl) async {
    final added = await provider.addSongToPlaylist(pl.id, widget.song);
    if (!context.mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added
              ? '"${widget.song.name}" added to "${pl.title}"!'
              : '"${widget.song.name}" is already in "${pl.title}".',
        ),
        backgroundColor: const Color(0xFF1ED760),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
