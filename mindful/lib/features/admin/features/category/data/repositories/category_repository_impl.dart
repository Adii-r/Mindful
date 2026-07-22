import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remote;

  CategoryRepositoryImpl(this.remote);

  @override
  Future<List<CategoryModel>> getCategories() {
    return remote.getCategories();
  }

  @override
  Future<void> addCategory(CategoryModel category) {
    return remote.addCategory(category);
  }

  @override
  Future<void> updateCategory(CategoryModel category) {
    return remote.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(String id) {
    return remote.deleteCategory(id);
  }
}