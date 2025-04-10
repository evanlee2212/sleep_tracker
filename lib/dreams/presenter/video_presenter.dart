import '../models/video_resource.dart';
import '../repositories/video_repository.dart';

abstract class VideoView {
  void onVideosLoaded(List<VideoResource> videos);
}

class VideoPresenter {
  final VideoView view;
  final VideoRepository repository;

  VideoPresenter({required this.view, required this.repository});

  void loadVideos() {
    final videos = repository.fetchVideos();
    view.onVideosLoaded(videos);
  }
}
