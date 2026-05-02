import 'package:google_generative_ai/google_generative_ai.dart';
import '../../shared/models/user_profile.dart';

class AiChatService {
  late GenerativeModel _model;
  late ChatSession _chat;
  String _apiKey = '';

  static String _buildSystemPrompt(UserProfile? profile) {
    final name = profile?.name.isNotEmpty == true ? profile!.name : 'kullanıcı';
    final concerns =
        profile?.concerns.isNotEmpty == true ? profile!.concerns.join(', ') : 'genel refah';
    final spirituality = profile?.spirituality ?? 'Dini biri değilim';

    String spiritualGuidance;
    switch (spirituality) {
      case 'Müslüman':
        spiritualGuidance =
            'Kullanıcı Müslüman. Uygun yerlerde Kur\'an ayeti veya hadis paylaşabilirsin.';
      case 'Hristiyan':
        spiritualGuidance =
            'Kullanıcı Hristiyan. Uygun yerlerde İncil\'den alıntı yapabilirsin.';
      case 'Yahudi':
        spiritualGuidance =
            'Kullanıcı Yahudi. Uygun yerlerde Tevrat veya Talmud\'dan alıntı yapabilirsin.';
      case 'Budist':
        spiritualGuidance =
            'Kullanıcı Budist. Uygun yerlerde Buda öğretilerinden ve mindfulness pratiklerinden bahsedebilirsin.';
      case 'Hindu':
        spiritualGuidance =
            'Kullanıcı Hindu. Uygun yerlerde Bhagavad Gita veya Vedik öğretilerden bahsedebilirsin.';
      case 'Genel spiritüel':
        spiritualGuidance =
            'Kullanıcı genel spiritüel yaklaşımı tercih ediyor. Evrensel bilgelik ve mindfulness odaklı ol.';
      default:
        spiritualGuidance =
            'Kullanıcı dini içerik istemez. Tamamen bilimsel ve laik (CBT, mindfulness, pozitif psikoloji) yaklaşım kullan.';
    }

    return '''
Sen "Nefes" adlı kişisel gelişim ve zihinsel refah uygulamasının AI asistanısın.
Adın: Nefes

Kullanıcı hakkında bilgiler:
- İsim: $name
- Endişeleri / sorunları: $concerns
- Manevi yönelim: $spirituality

Manevi rehberlik notu: $spiritualGuidance

Görevin:
- Kullanıcının zihinsel ve duygusal refahını desteklemek
- Kanıta dayalı teknikler kullanmak: CBT, mindfulness, ACT, pozitif psikoloji
- Empati göstermek, yargılamadan dinlemek ve somut araçlar önermek
- Nefes egzersizleri, meditasyon teknikleri ve pratik başa çıkma stratejileri sunmak
- Herhangi bir dinden, kültürden veya yaştan insana hitap etmek

Kesin kurallar:
1. ASLA tıbbi teşhis koyma veya ilaç önerme
2. İntihar veya kendine zarar verme belirtisi fark edersen HEMEN yönlendir:
   TR Kriz Hattı: 182 | Uluslararası: befrienders.org
3. Her yanıtı Türkçe ver
4. Kısa, sıcak ve samimi yanıtlar ver (max 150 kelime)
5. Kullanıcıyı asla yargılama, her zaman destekleyici ol
6. Gerekli olmadıkça din referansı verme; sadece kullanıcının manevi yönelimi gerektiriyorsa kullan
''';
  }

  void initialize(String apiKey, {UserProfile? profile}) {
    _apiKey = apiKey;
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.text(_buildSystemPrompt(profile)),
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

  void resetChat({UserProfile? profile}) {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.text(_buildSystemPrompt(profile)),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topP: 0.9,
        maxOutputTokens: 500,
      ),
    );
    _chat = _model.startChat();
  }
}
