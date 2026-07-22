import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_datasource.dart';
import '../models/book_model.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remote;

  BookRepositoryImpl(this.remote);

  @override
  Future<List<BookModel>> getBooks() {
    return remote.getBooks();
  }

  @override
  Future<void> add(BookModel book) {
    return remote.addBook(book);
  }

  @override
  Future<void> update(BookModel book) {
    return remote.updateBook(book);
  }

  @override
  Future<void> delete(String id) {
    return remote.deleteBook(id);
  }
}
