import '../../data/models/author_model.dart';

abstract class AuthorRepository {
  Future<List<AuthorModel>> getAuthors();

  Future<void> add(AuthorModel author);

  Future<void> update(AuthorModel author);

  Future<void> delete(String id);
}
