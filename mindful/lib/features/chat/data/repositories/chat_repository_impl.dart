import '../../domain/repositories/chat_repository.dart';
import '../datasources/gemini_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final GeminiRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> sendMessage(String prompt) async {
    return await remoteDataSource.sendMessage(prompt);
  }
}