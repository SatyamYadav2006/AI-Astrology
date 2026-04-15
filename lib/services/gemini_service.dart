import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';
import '../models/horoscope_model.dart';

class GeminiService {
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  final String _endpoint =
"https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent";

  // Generate Daily Horoscope
  Future<HoroscopeModel> generateDailyHoroscope(UserModel user, DateTime date) async {
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    final prompt = """
Generate a highly detailed, deeply mystical, and expansive daily horoscope for today ($formattedDate).

User Details:
Name: ${user.name}
Zodiac: ${user.zodiacSign}

Critical Instructions:
1. YOU MUST WRITE EXTREMELY LONG PARAGRAPHS. The 'dailySummary', 'career', 'love', 'health', and 'finance' JSON values must EACH be a massive block of text containing at least 80 to 100 words per section. Absolutely no short summaries. If you write less than 4 full sentences for a section, you have failed.
2. For 'luckyTime', you must literally return the exact string: "All Day" so the auspicious moment spans the entire date.
3. Ensure 'luckyNumber' and 'luckyColor' are drastically randomized.
4. 'dos' and 'donts' should be deep psychological and practical directives.

Return ONLY valid JSON in this format:
{
  "dailySummary": "...",
  "career": "...",
  "love": "...",
  "health": "...",
  "finance": "...",
  "mood": "...",
  "luckyNumber": "...",
  "luckyColor": "...",
  "luckyTime": "...",
  "dos": ["...", "..."],
  "donts": ["...", "..."]
}
""";

    try {
      final response = await http.post(
        Uri.parse("$_endpoint?key=$_apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String content = data['candidates'][0]['content']['parts'][0]['text'];

        // Clean JSON (Gemini sometimes adds extra text)
        content = content.replaceAll("```json", "").replaceAll("```", "").trim();

        final Map<String, dynamic> output = jsonDecode(content);

        return HoroscopeModel(
          id: formattedDate,
          date: date,
          zodiacSign: user.zodiacSign,
          dailySummary: output['dailySummary'] ?? '',
          career: output['career'] ?? '',
          love: output['love'] ?? '',
          health: output['health'] ?? '',
          finance: output['finance'] ?? '',
          mood: output['mood'] ?? '',
          luckyNumber: output['luckyNumber'] ?? '',
          luckyColor: output['luckyColor'] ?? '',
          luckyTime: output['luckyTime'] ?? '',
          dos: List<String>.from(output['dos'] ?? []),
          donts: List<String>.from(output['donts'] ?? []),
        );
      } else {
        throw Exception("Gemini error: ${response.body}");
      }
    } catch (e) {
      throw Exception("Gemini API Error: $e");
    }
  }

  // Chatbot
  Future<String> sendChatMessage(
      List<Map<String, String>> messageHistory, UserModel user) async {
    final prompt = """
User: ${user.name}
Zodiac: ${user.zodiacSign}

Conversation:
${messageHistory.map((m) => "${m['role']}: ${m['content']}").join("\n")}

Reply like a friendly astrology chatbot.
""";

    try {
      final response = await http.post(
        Uri.parse("$_endpoint?key=$_apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception("Chatbot error: ${response.body}");
      }
    } catch (e) {
      throw Exception("Gemini API Error: $e");
    }
  }
}