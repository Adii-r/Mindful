import '../../domain/repositories/quote_repository.dart';

import '../datasources/quote_remote_datasource.dart';

import '../models/quote_model.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDataSource remote;

  QuoteRepositoryImpl(this.remote);

  @override
  Future<List<QuoteModel>> getQuotes() {
    return remote.getQuotes();
  }

  @override
  Future<void> add(QuoteModel quote) {
    return remote.addQuote(quote);
  }

  @override
  Future<void> update(QuoteModel quote) {
    return remote.updateQuote(quote);
  }

  @override
  Future<void> delete(String id) {
    return remote.deleteQuote(id);
  }
}
