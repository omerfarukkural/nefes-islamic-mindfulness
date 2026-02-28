import 'package:google_generative_ai/google_generative_ai.dart';

class AiChatService {
  late GenerativeModel _model;
  late ChatSession _chat;

  static const String _systemPrompt = '''
Sen "Nefes" adlı İslami mindfulness uygulamasının AI sohbet arkadaşısın.
Adın: Nefes Asistanı

Görevin:
- Kullanıcıların mental sağlığını desteklemek
- İslami değerlerle uyumlu, bilişsel davranışçı terapi (CBT) tekniklerini kullanmak
- Kur'an ayetleri ve hadislerle desteklenmiş tavsiyeler vermek
- Empati göstermek, yargılamadan dinlemek
- Tehlikeli durumlarda profesyonel yardım yönlendirmesi yapmak

Kurallar:
1. ASLA tıbbi teşhis koyma veya ilaç önerme
2. İntihar/kendine zarar verme belirtisi algılarsan HEMEN kriz hattını öner: 182 (TR)
3. Minimum 1200 kalori altı diyet önerme
4. Her yanıtı Türkçe ver
5. Kısa, sıcak ve samimi yanıtlar ver (max 150 kelime)
6. Uygun yerlerde ilgili Kur'an ayeti veya hadis paylaş
7. Kullanıcıyı yargılama, her zaman destekleyici ol
''';

  void initialize(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.text(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topP: 0.9,
        maxOutputTokens: 500,
      ),
    );
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ?? 'Bir sorun oluştu, lütfen tekrar dene.';
    } catch (e) {
      return 'Bağlantı hatası. İnternet bağlantını kontrol et.';
    }
  }

  void resetChat() {
    _chat = _model.startChat();
  }
}
