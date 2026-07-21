import '../../domain/entities/favorite.dart';

import '../../domain/repositories/favorite_repository.dart';

import '../datasources/favorite_remote_datasource.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Favorite>> getFavorites() async {
    return await remoteDataSource.getFavorites();
  }

  @override
  Future<void> toggleFavorite({
    required String itemId,

    required String itemType,
  }) async {
    await remoteDataSource.toggleFavorite(itemId: itemId, itemType: itemType);
  }

  @override
  Future<Map<String, dynamic>?> getItem({
    required String id,

    required String type,
  }) async {
    return await remoteDataSource.getItem(id: id, type: type);
  }

  @override
  Future<bool> isFavorite({
    required String itemId,
    required String itemType,
  }) async {

    return remoteDataSource.isFavorite(
      itemId: itemId,
      itemType: itemType,
    );

  }
}
