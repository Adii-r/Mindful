import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<String> call(String prompt) async {
    return await repository.sendMessage(prompt);
  }
}