import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/playlist.dart';
import '../models/video.dart';
import '../repositories/playlist_repository.dart';
import '../repositories/video_repository.dart';
import '../presenter/playlist_presenter.dart';
import 'video_page.dart'; // for YoutubePlayerScreen

class PlaylistDetailPage extends StatefulWidget {
  final Playlist playlist;
  const PlaylistDetailPage({Key? key, required this.playlist})
      : super(key: key);

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage>
    implements PlaylistView {
  late final PlaylistPresenter _presenter;
  final _videoRepo = VideoRepository();
  late final List<VideoResource> _allVideos;
  late Playlist _playlist;

  @override
  void initState() {
    super.initState();
    _playlist = widget.playlist;

    _allVideos = _videoRepo.fetchVideos();

    //listening for playlist changes
    _presenter = PlaylistPresenter(view: this, repo: PlaylistRepository());
  }

  @override
  void onPlaylistsUpdated(List<Playlist> playlists) {
    final updated = playlists.firstWhere(
          (pl) => pl.id == _playlist.id,
      orElse: () => _playlist,
    );
    setState(() => _playlist = updated);
  }

  void _remove(String url) => _presenter.removeVideo(_playlist.id, url);

  void _play(String url) {
    final id = YoutubePlayer.convertUrlToId(url);
    if (id != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => YoutubePlayerScreen(videoId: id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_playlist.name),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.builder(
        itemCount: _playlist.videoUrls.length,
        itemBuilder: (ctx, i) {
          final url = _playlist.videoUrls[i];

          //look up the matching VideoResource by URL
          final video = _allVideos.firstWhere(
                (v) => v.videoUrl == url,
            orElse: () => VideoResource(
              title: 'Unknown Title',
              category: '',
              videoUrl: url,
            ),
          );

          return ListTile(
            title: Text(video.title),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _remove(url),
            ),
            onTap: () => _play(url),
          );
        },
      ),
    );
  }
}
