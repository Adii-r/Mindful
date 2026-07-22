import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/category_remote_datasource.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/repositories/category_repository.dart';

final categoryRepositoryProvider =
Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    CategoryRemoteDataSource(),
  );
});

final categoryProvider =
StateNotifierProvider<CategoryNotifier, List<CategoryModel>>(
      (ref) {
    return CategoryNotifier(
      ref.read(categoryRepositoryProvider),
    );
  },
);

class CategoryNotifier
    extends StateNotifier<List<CategoryModel>> {
  final CategoryRepository repository;

  CategoryNotifier(this.repository) : super([]) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    state = await repository.getCategories();
  }

  Future<void> add(CategoryModel category) async {
    await repository.addCategory(category);
    await loadCategories();
  }

  Future<void> update(CategoryModel category) async {
    await repository.updateCategory(category);
    await loadCategories();
  }

  Future<void> delete(String id) async {
    await repository.deleteCategory(id);
    await loadCategories();
  }
}