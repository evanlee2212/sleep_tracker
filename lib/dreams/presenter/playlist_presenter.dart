import '../models/playlist.dart';
import '../repositories/playlist_repository.dart';

abstract class PlaylistView {
  void onPlaylistsUpdated(List<Playlist> playlists);
}

///presenter that binds Firestore repo to the view.
class PlaylistPresenter {
  final PlaylistView view;
  final PlaylistRepository repo;
  late final Stream<List<Playlist>> _streamSub;

  PlaylistPresenter({required this.view, required this.repo}) {
    _streamSub = repo.watchPlaylists();
    _streamSub.listen(view.onPlaylistsUpdated);
  }

  void createPlaylist(String name) => repo.createPlaylist(name);
  void addVideo(String playlistId, String videoUrl) =>
      repo.addVideoToPlaylist(playlistId, videoUrl);
  void removeVideo(String playlistId, String videoUrl) =>
      repo.removeVideoFromPlaylist(playlistId, videoUrl);
}
