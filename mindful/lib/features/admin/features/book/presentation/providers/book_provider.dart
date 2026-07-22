import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/book_remote_datasource.dart';
import '../../data/models/book_model.dart';
import '../../data/repositories/book_repository_impl.dart';

final bookProvider = StateNotifierProvider<BookNotifier, List<BookModel>>((
  ref,
) {
  return BookNotifier(BookRepositoryImpl(BookRemoteDataSource()));
});

class BookNotifier extends StateNotifier<List<BookModel>> {
  final BookRepositoryImpl repository;

  BookNotifier(this.repository) : super([]) {
    load();
  }

  Future<void> load() async {
    state = await repository.getBooks();
  }

  Future<void> add(BookModel book) async {
    await repository.add(book);

    load();
  }

  Future<void> update(BookModel book) async {
    await repository.update(book);

    load();
  }

  Future<void> delete(String id) async {
    await repository.delete(id);

    load();
  }
}
