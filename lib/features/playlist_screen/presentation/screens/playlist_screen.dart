import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/providers/playlist_provider.dart';
import '../../../../core/models/playlist_model.dart';
import '../../../../features/search_screen/data/models/song_model.dart';
import '../../../../core/presentation/widgets/custom_network_image.dart';
import '../../../../core/providers/audio_provider.dart';
import '../../../../core/presentation/widgets/mini_player.dart';

class PlaylistScreen extends StatefulWidget {
  final PlaylistModel playlist;
  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  // 0 = Play (first song), 1 = Play All, 2 = Loop All
  int _playModeIndex = 0;

  String get _playModeText {
    switch (_playModeIndex) {
      case 0:
        return 'Play';
      case 1:
        return 'Play All';
      case 2:
        return 'Loop All';
      default:
        return 'Play';
    }
  }

  IconData get _playModeIcon {
    switch (_playModeIndex) {
      case 0:
        return Icons.play_arrow;
      case 1:
        return Icons.playlist_play;
      case 2:
        return Icons.loop;
      default:
        return Icons.play_arrow;
    }
  }

  void _handlePlay(BuildContext context, List<SongModel> songs) {
    if (songs.isEmpty) return;
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    if (_playModeIndex == 0) {
      audioProvider.setLoopMode(LoopMode.off);
      audioProvider.playSong(songs.first);
    } else if (_playModeIndex == 1) {
      audioProvider.setLoopMode(LoopMode.off);
      audioProvider.playQueue(songs);
    } else if (_playModeIndex == 2) {
      audioProvider.setLoopMode(LoopMode.all);
      audioProvider.playQueue(songs);
    }

    setState(() => _playModeIndex = (_playModeIndex + 1) % 3);
    context.push('/playing');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, provider, _) {
        final livePlaylist = provider.playlists.firstWhere(
          (p) => p.id == widget.playlist.id,
          orElse: () => widget.playlist,
        );

        final coverUrl = livePlaylist.songs.isNotEmpty
            ? livePlaylist.songs.first.bestImageUrl
            : '';

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
            child: SafeArea(child: MiniPlayer()),
          ),
          body: CustomScrollView(
            slivers: [
              // ─── Collapsing header ───────────────────────────────
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: const Color(0xFF121212),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  onPressed: () => context.pop(),
                ),
                title: const Text(
                  'Playlist',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                centerTitle: true,
                actions: [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'rename') {
                        _showRenameDialog(context, provider, livePlaylist);
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, provider, livePlaylist);
                      }
                    },
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    color: const Color(0xFF2C2C2C),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: Row(children: [
                          Icon(Icons.edit, color: Colors.white, size: 18),
                          SizedBox(width: 10),
                          Text('Rename', style: TextStyle(color: Colors.white)),
                        ]),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [
                          Icon(Icons.delete_outline,
                              color: Colors.redAccent, size: 18),
                          SizedBox(width: 10),
                          Text('Delete Playlist',
                              style: TextStyle(color: Colors.redAccent)),
                        ]),
                      ),
                    ],
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Cover art
                      coverUrl.isNotEmpty
                          ? CustomNetworkImage(
                              coverUrl,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: const Color(0xFF1E1E24),
                              child: const Icon(Icons.queue_music,
                                  color: Colors.white12, size: 80),
                            ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xFF121212).withOpacity(0.7),
                              const Color(0xFF121212),
                            ],
                            stops: const [0.4, 0.75, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Playlist title + song count ─────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        livePlaylist.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${livePlaylist.songs.length} song${livePlaylist.songs.length == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ─── Play mode button ─────────────────────────
                      if (livePlaylist.songs.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _handlePlay(context, livePlaylist.songs),
                            icon: Icon(_playModeIcon, color: Colors.black),
                            label: Text(
                              _playModeText,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD3C8C4),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // ─── Songs header ─────────────────────────────
                      if (livePlaylist.songs.isNotEmpty)
                        const Text(
                          'Songs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // ─── Song list ───────────────────────────────────────
              livePlaylist.songs.isEmpty
                  ? SliverFillRemaining(child: _buildEmptyState())
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final song = livePlaylist.songs[index];
                          return _SongTile(
                            song: song,
                            index: index + 1,
                            playlistId: livePlaylist.id,
                            onPlay: () {
                              final audioProvider = Provider.of<AudioProvider>(context, listen: false);
                              // If this song is already the active one, just open the player
                              if (audioProvider.currentSong?.id == song.id) {
                                context.push('/playing');
                                return;
                              }
                              audioProvider.playQueue(livePlaylist.songs, initialIndex: index);
                              context.push('/playing');
                            },
                          );
                        },
                        childCount: livePlaylist.songs.length,
                        addAutomaticKeepAlives: false,
                      ),
                    ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.queue_music, size: 80, color: Colors.white.withOpacity(0.15)),
          const SizedBox(height: 16),
          Text(
            'No songs yet',
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Add songs via the ⋮ menu on any song',
            style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(
      BuildContext context, PlaylistProvider provider, PlaylistModel pl) {
    final ctrl = TextEditingController(text: pl.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:
            const Text('Rename Playlist', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Playlist name',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.3))),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1ED760))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                provider.renamePlaylist(pl.id, ctrl.text);
              }
              Navigator.pop(ctx);
            },
            child:
                const Text('Save', style: TextStyle(color: Color(0xFF1ED760))),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, PlaylistProvider provider, PlaylistModel pl) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Playlist?',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${pl.title}"? This cannot be undone.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              provider.deletePlaylist(pl.id);
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Song Tile ──────────────────────────

class _SongTile extends StatelessWidget {
  final SongModel song;
  final int index;
  final String playlistId;
  final VoidCallback onPlay;

  const _SongTile({
    required this.song,
    required this.index,
    required this.playlistId,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: GestureDetector(
        onTap: onPlay,
        child: Row(
          children: [
            // Index number
            SizedBox(
              width: 24,
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            // Album art
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CustomNetworkImage(
                song.bestImageUrl.isNotEmpty
                    ? song.bestImageUrl
                    : 'https://via.placeholder.com/50',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Title + artist
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.primaryArtists,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 3-dot menu
            Consumer<PlaylistProvider>(
              builder: (context, provider, _) => PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'remove') {
                    provider.removeSongFromPlaylist(playlistId, song.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"${song.name}" removed from playlist.'),
                        backgroundColor: const Color(0xFF2C2C2C),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white.withOpacity(0.6),
                  size: 20,
                ),
                color: const Color(0xFF2C2C2C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.playlist_remove,
                            color: Colors.redAccent, size: 20),
                        SizedBox(width: 12),
                        Text('Remove from Playlist',
                            style: TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
