import '../../domain/repositories/game_repository.dart';
import '../datasources/game_remote_datasource.dart';
import '../models/game_model.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource remoteDataSource;

  GameRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<GameModel>> loadQuestions() {
    return remoteDataSource.loadQuestions();
  }
}