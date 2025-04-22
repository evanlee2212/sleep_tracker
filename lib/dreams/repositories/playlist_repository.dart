//stuff
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/playlist.dart';

class PlaylistRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Stream<List<Playlist>> watchPlaylists() {
    return _firestore
        .collection('users/$_uid/playlists')
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => Playlist.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> createPlaylist(String name) {
    return _firestore
        .collection('users/$_uid/playlists')
        .add({'name': name, 'videoUrls': []});
  }

  Future<void> addVideoToPlaylist(String playlistId, String videoUrl) {
    final ref = _firestore.doc('users/$_uid/playlists/$playlistId');
    return ref.update({
      'videoUrls': FieldValue.arrayUnion([videoUrl])
    });
  }

  Future<void> removeVideoFromPlaylist(String playlistId, String videoUrl) {
    final ref = _firestore.doc('users/$_uid/playlists/$playlistId');
    return ref.update({
      'videoUrls': FieldValue.arrayRemove([videoUrl])
    });
  }
}
