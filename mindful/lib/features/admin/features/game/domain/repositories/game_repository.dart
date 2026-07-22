import '../../data/models/question_model.dart';

abstract class GameRepository {
  Future<List<QuestionModel>> getQuestions();

  Future<void> addQuestion(QuestionModel question);

  Future<void> updateQuestion(QuestionModel question);

  Future<void> deleteQuestion(String id);
}
