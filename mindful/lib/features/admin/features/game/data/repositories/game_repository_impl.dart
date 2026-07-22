import '../../domain/repositories/game_repository.dart';

import '../datasources/game_remote_datasource.dart';

import '../models/question_model.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource remote;

  GameRepositoryImpl(this.remote);

  @override
  Future<List<QuestionModel>> getQuestions() {
    return remote.getQuestions();
  }

  @override
  Future<void> addQuestion(QuestionModel question) {
    return remote.addQuestion(question);
  }

  @override
  Future<void> updateQuestion(QuestionModel question) {
    return remote.updateQuestion(question);
  }

  @override
  Future<void> deleteQuestion(String id) {
    return remote.deleteQuestion(id);
  }
}
