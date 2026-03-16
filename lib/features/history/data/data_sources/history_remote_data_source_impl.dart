import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../../wishlist/data/models/wishlist_model.dart';
import 'history_data_sources.dart';

@LazySingleton(as: HistoryRemoteDataSource)
class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  HistoryRemoteDataSourceImpl(this.firestore, this.auth);

  CollectionReference get _historyCollection {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    return firestore.collection('users').doc(user.uid).collection('history');
  }

  @override
  Future<void> addToHistory(MovieEntity movie) async {
    final model = MovieWishlistModel.fromEntity(movie);
    await _historyCollection.doc(movie.id.toString()).set(model.toFirestore());
  }

  @override
  Future<List<MovieEntity>> getHistory() async {
    final querySnapshot = await _historyCollection.get();
    return querySnapshot.docs
        .map(
          (doc) => MovieWishlistModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
