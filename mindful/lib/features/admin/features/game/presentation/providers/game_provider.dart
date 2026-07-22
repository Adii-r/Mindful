import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/game_remote_datasource.dart';

import '../../data/repositories/game_repository_impl.dart';

import '../../data/models/question_model.dart';

final gameRepositoryProvider = Provider((ref) {
  return GameRepositoryImpl(GameRemoteDataSource());
});

final gameProvider = StateNotifierProvider<GameNotifier, List<QuestionModel>>((
  ref,
) {
  return GameNotifier(ref.read(gameRepositoryProvider));
});

class GameNotifier extends StateNotifier<List<QuestionModel>> {
  final GameRepositoryImpl repository;

  GameNotifier(this.repository) : super([]) {
    load();
  }

  Future<void> load() async {
    state = await repository.getQuestions();
  }

  Future<void> add(QuestionModel question) async {
    await repository.addQuestion(question);

    load();
  }

  Future<void> update(QuestionModel question) async {
    await repository.updateQuestion(question);

    load();
  }

  Future<void> delete(String id) async {
    await repository.deleteQuestion(id);

    load();
  }
}
