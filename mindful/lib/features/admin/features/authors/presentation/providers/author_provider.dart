import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/author_remote_datasource.dart';
import '../../data/models/author_model.dart';
import '../../data/repositories/author_repository_impl.dart';

final authorRepositoryProvider = Provider((ref) {
  return AuthorRepositoryImpl(AuthorRemoteDataSource());
});

final authorProvider = StateNotifierProvider<AuthorNotifier, List<AuthorModel>>(
  (ref) {
    return AuthorNotifier(ref.read(authorRepositoryProvider));
  },
);

class AuthorNotifier extends StateNotifier<List<AuthorModel>> {
  final AuthorRepositoryImpl repository;

  AuthorNotifier(this.repository) : super([]) {
    load();
  }

  Future<void> load() async {
    state = await repository.getAuthors();
  }

  Future<void> add(AuthorModel author) async {
    await repository.add(author);

    await load();
  }

  Future<void> update(AuthorModel author) async {
    await repository.update(author);

    await load();
  }

  Future<void> delete(String id) async {
    await repository.delete(id);

    await load();
  }
}
