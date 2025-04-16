import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../dreams/models/video_resource.dart';
import '../../dreams/presenter/video_presenter.dart';
import '../../dreams/repositories/video_repository.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> implements VideoView {
  late final VideoPresenter _presenter;
  List<VideoResource> _videos = [];

  @override
  void initState() {
    super.initState();
    _presenter = VideoPresenter(view: this, repository: VideoRepository());
    _presenter.loadVideos();
  }

  @override
  void onVideosLoaded(List<VideoResource> videos) {
    setState(() {
      _videos = videos;
    });
  }

  String? _getYouTubeId(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }

  void _openVideoPlayer(String url) {
    final videoId = _getYouTubeId(url);
    if (videoId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => YoutubePlayerScreen(videoId: videoId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relaxation Videos'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return ListTile(
            title: Text(video.title),
            subtitle: Text(video.category),
            trailing: const Icon(Icons.play_arrow),
            onTap: () => _openVideoPlayer(video.videoUrl),
          );
        },
      ),
    );
  }
}

class YoutubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YoutubePlayerScreen({super.key, required this.videoId});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
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
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Now Playing'),
            backgroundColor: Colors.deepPurpleAccent,
          ),
          body: Center(child: player),
        );
      },
    );
  }
}
