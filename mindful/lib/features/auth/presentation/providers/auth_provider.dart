import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(
    AuthRemoteDataSource(),
  );
});