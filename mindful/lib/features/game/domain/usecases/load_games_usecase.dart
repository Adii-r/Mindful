import '../../data/models/game_model.dart';
import '../repositories/game_repository.dart';

class LoadGamesUseCase {
  final GameRepository repository;

  LoadGamesUseCase(this.repository);

  Future<List<GameModel>> call() {
    return repository.loadQuestions();
  }
}