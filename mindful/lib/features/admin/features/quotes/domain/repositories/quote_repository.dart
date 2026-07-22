import '../../data/models/quote_model.dart';

abstract class QuoteRepository {
  Future<List<QuoteModel>> getQuotes();

  Future<void> add(QuoteModel quote);

  Future<void> update(QuoteModel quote);

  Future<void> delete(String id);
}
