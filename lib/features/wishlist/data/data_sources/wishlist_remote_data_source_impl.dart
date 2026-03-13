import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../models/wishlist_model.dart';
import 'wishlist_remote_data_source.dart';

@LazySingleton(as: WishlistRemoteDataSource)
class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  WishlistRemoteDataSourceImpl(this.firestore, this.auth);

  CollectionReference get _wishlistCollection {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    return firestore.collection('users').doc(user.uid).collection('wishlist');
  }

  @override
  Future<void> addToWishlist(MovieEntity movie) async {
    final model = MovieWishlistModel.fromEntity(movie);
    await _wishlistCollection.doc(movie.id.toString()).set(model.toFirestore());
  }

  @override
  Future<void> removeFromWishlist(int movieId) async {
    await _wishlistCollection.doc(movieId.toString()).delete();
  }

  @override
  Future<List<MovieEntity>> getWishlist() async {
    final querySnapshot = await _wishlistCollection.get();
    return querySnapshot.docs
        .map(
          (doc) => MovieWishlistModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
