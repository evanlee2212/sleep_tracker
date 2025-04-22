import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/video.dart';
import '../repositories/video_repository.dart';
import '../presenter/video_presenter.dart';
import '../models/playlist.dart';
import '../repositories/playlist_repository.dart';
import '../presenter/playlist_presenter.dart';
import 'playlist_detail_page.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    implements VideoView, PlaylistView {
  // video MVP
  late final VideoPresenter _videoPresenter;
  List<VideoResource> _videos = [];

  // playlist MVP
  late final PlaylistPresenter _playlistPresenter;
  List<Playlist> _playlists = [];

  @override
  void initState() {
    super.initState();
    _videoPresenter =
        VideoPresenter(view: this, repository: VideoRepository());
    _videoPresenter.loadVideos();

    _playlistPresenter =
        PlaylistPresenter(view: this, repo: PlaylistRepository());
  }

  // VideoView
  @override
  void onVideosLoaded(List<VideoResource> videos) {
    setState(() => _videos = videos);
  }

  // PlaylistView
  @override
  void onPlaylistsUpdated(List<Playlist> playlists) {
    setState(() => _playlists = playlists);
  }

  void _showCreatePlaylistDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Playlist'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Playlist name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                _playlistPresenter.createPlaylist(name);
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddToPlaylistSheet(String videoUrl) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: _playlists.length,
        itemBuilder: (ctx, i) {
          final pl = _playlists[i];
          return ListTile(
            title: Text(pl.name),
            onTap: () {
              _playlistPresenter.addVideo(pl.id, videoUrl);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added to "${pl.name}"')),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relaxation Videos'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          // ── Playlist carousel ──
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: _playlists.length + 1,
              itemBuilder: (ctx, i) {
                if (i == _playlists.length) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: const Icon(Icons.add),
                      onPressed: _showCreatePlaylistDialog,
                    ),
                  );
                }
                final pl = _playlists[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(pl.name),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaylistDetailPage(playlist: pl),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),

          // ── Video list ──
          Expanded(
            child: ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (ctx, idx) {
                final video = _videos[idx];
                return ListTile(
                  title: Text(video.title),
                  subtitle: Text(video.category),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'play', child: Text('Play')),
                      PopupMenuItem(value: 'add', child: Text('Add to playlist')),
                    ],
                    onSelected: (choice) {
                      if (choice == 'play') {
                        final id = YoutubePlayer.convertUrlToId(video.videoUrl);
                        if (id != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => YoutubePlayerScreen(videoId: id),
                            ),
                          );
                        }
                      } else {
                        _showAddToPlaylistSheet(video.videoUrl);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class YoutubePlayerScreen extends StatefulWidget {
  final String videoId;
  const YoutubePlayerScreen({Key? key, required this.videoId})
      : super(key: key);
  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (ctx, player) => Scaffold(
        appBar: AppBar(
          title: const Text('Now Playing'),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(child: player),
      ),
    );
  }
}

