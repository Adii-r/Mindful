import '../../data/models/book_model.dart';

abstract class BookRepository {
  Future<List<BookModel>> getBooks();

  Future<void> add(BookModel book);

  Future<void> update(BookModel book);

  Future<void> delete(String id);
}
