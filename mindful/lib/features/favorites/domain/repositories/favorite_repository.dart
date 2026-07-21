import '../entities/favorite.dart';

abstract class FavoriteRepository {
  Future<List<Favorite>> getFavorites();

  Future<void> toggleFavorite({
    required String itemId,

    required String itemType,
  });

  Future<Map<String, dynamic>?> getItem({
    required String id,

    required String type,
  });

  Future<bool> isFavorite({
    required String itemId,
    required String itemType,
  });
}
