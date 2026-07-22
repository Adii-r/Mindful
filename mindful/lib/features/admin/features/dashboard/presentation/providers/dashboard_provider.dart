import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider =
Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    DashboardRemoteDataSource(),
  );
});

final dashboardProvider = FutureProvider((ref) async {
  return await ref
      .read(dashboardRepositoryProvider)
      .getDashboard();
});