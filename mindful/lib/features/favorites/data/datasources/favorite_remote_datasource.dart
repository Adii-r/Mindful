import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/favorite_model.dart';

class FavoriteRemoteDataSource {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  Future<List<FavoriteModel>> getFavorites() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await database.ref().child("favorites").child(uid).get();

    if (!snapshot.exists) {
      return [];
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.values.map((item) {
      final fav = Map<String, dynamic>.from(item);

      return FavoriteModel(itemId: fav["itemId"], itemType: fav["itemType"]);
    }).toList();
  }

  Future<Map<String, dynamic>?> getItem({
    required String id,
    required String type,
  }) async {
    String path;

    switch (type) {
      case "book":
        path = "books";

        break;

      case "author":
        path = "authors";

        break;

      case "quote":
        path = "quotes";

        break;

      default:
        return null;
    }

    final snapshot = await database.ref().child(path).child(id).get();

    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }

    return null;
  }

  Future<void> toggleFavorite({
    required String itemId,

    required String itemType,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final ref = database.ref().child("favorites").child(uid);

    final snapshot = await ref.get();

    bool exists = false;

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        if (value["itemId"] == itemId && value["itemType"] == itemType) {
          exists = true;
        }
      });
    }

    if (exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        if (value["itemId"] == itemId && value["itemType"] == itemType) {
          ref.child(key).remove();
        }
      });
    } else {
      final newRef = ref.push();

      await newRef.set({
        "itemId": itemId,

        "itemType": itemType,

        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<bool> isFavorite({
    required String itemId,
    required String itemType,
  }) async {

    final favorites = await getFavorites();


    return favorites.any(
          (fav) =>
      fav.itemId == itemId &&
          fav.itemType == itemType,
    );

  }
}
