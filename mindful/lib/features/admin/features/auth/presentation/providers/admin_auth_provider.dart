import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/admin_auth_remote_datasource.dart';
import '../../data/repositories/admin_auth_repository_impl.dart';
import '../../domain/repositories/admin_auth_repository.dart';

final adminRepositoryProvider =
Provider<AdminAuthRepository>((ref) {
  return AdminAuthRepositoryImpl(
    AdminAuthRemoteDataSource(),
  );
});