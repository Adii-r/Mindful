import 'package:firebase_database/firebase_database.dart';

import '../models/quote_model.dart';

class QuoteRemoteDataSource {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<QuoteModel>> getQuotes() async {
    final snapshot = await _db.child("quotes").get();

    if (!snapshot.exists) {
      return [];
    }

    final data = snapshot.value as Map<dynamic, dynamic>;

    return data.entries.map((entry) {
      return QuoteModel.fromJson(entry.key, entry.value);
    }).toList();
  }

  Future<void> addQuote(QuoteModel quote) async {
    await _db.child("quotes").child(quote.id).set(quote.toJson());
  }

  Future<void> updateQuote(QuoteModel quote) async {
    await _db.child("quotes").child(quote.id).update(quote.toJson());
  }

  Future<void> deleteQuote(String id) async {
    await _db.child("quotes").child(id).remove();
  }
}
