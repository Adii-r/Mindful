import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/quote_remote_datasource.dart';

import '../../data/models/quote_model.dart';

import '../../data/repositories/quote_repository_impl.dart';

final quoteProvider = StateNotifierProvider<QuoteNotifier, List<QuoteModel>>((
  ref,
) {
  return QuoteNotifier(QuoteRepositoryImpl(QuoteRemoteDataSource()));
});

class QuoteNotifier extends StateNotifier<List<QuoteModel>> {
  final QuoteRepositoryImpl repository;

  QuoteNotifier(this.repository) : super([]) {
    load();
  }

  Future<void> load() async {
    state = await repository.getQuotes();
  }

  Future<void> add(QuoteModel quote) async {
    await repository.add(quote);

    load();
  }

  Future<void> update(QuoteModel quote) async {
    await repository.update(quote);

    load();
  }

  Future<void> delete(String id) async {
    await repository.delete(id);

    load();
  }
}
