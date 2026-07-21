import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/game_remote_datasource.dart';
import '../../data/models/game_model.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/usecases/load_games_usecase.dart';

final gameProvider = Provider<GameProvider>((ref) {
  return GameProvider();
});

class GameProvider {
  final LoadGamesUseCase _loadGamesUseCase =
  LoadGamesUseCase(
    GameRepositoryImpl(
      GameRemoteDataSource(),
    ),
  );

  Future<List<GameModel>> loadQuestions() {
    return _loadGamesUseCase();
  }
}