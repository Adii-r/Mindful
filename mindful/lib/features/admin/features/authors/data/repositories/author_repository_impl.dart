import '../../domain/repositories/author_repository.dart';
import '../datasources/author_remote_datasource.dart';
import '../models/author_model.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final AuthorRemoteDataSource remote;

  AuthorRepositoryImpl(this.remote);

  @override
  Future<List<AuthorModel>> getAuthors() {
    return remote.getAuthors();
  }

  @override
  Future<void> add(AuthorModel author) {
    return remote.addAuthor(author);
  }

  @override
  Future<void> update(AuthorModel author) {
    return remote.updateAuthor(author);
  }

  @override
  Future<void> delete(String id) {
    return remote.deleteAuthor(id);
  }
}
