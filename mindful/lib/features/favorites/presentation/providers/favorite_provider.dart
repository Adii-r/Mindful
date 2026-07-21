import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/favorite_remote_datasource.dart';

import '../../data/repositories/favorite_repository_impl.dart';

import '../../domain/repositories/favorite_repository.dart';

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl(FavoriteRemoteDataSource());
});

final favoriteProvider = Provider((ref) {
  return ref.read(favoriteRepositoryProvider);
});
