class HoroscopeModel {
  final String id;
  final DateTime date;
  final String zodiacSign;
  final String dailySummary;
  final String career;
  final String love;
  final String health;
  final String finance;
  final String mood;
  final String luckyNumber;
  final String luckyColor;
  final String luckyTime;
  final List<String> dos;
  final List<String> donts;

  HoroscopeModel({
    required this.id,
    required this.date,
    required this.zodiacSign,
    required this.dailySummary,
    required this.career,
    required this.love,
    required this.health,
    required this.finance,
    required this.mood,
    required this.luckyNumber,
    required this.luckyColor,
    required this.luckyTime,
    required this.dos,
    required this.donts,
  });

  factory HoroscopeModel.fromMap(Map<String, dynamic> data, String documentId) {
    return HoroscopeModel(
      id: documentId,
      date: data['date'] != null ? DateTime.parse(data['date']) : DateTime.now(),
      zodiacSign: data['zodiacSign'] ?? '',
      dailySummary: data['dailySummary'] ?? '',
      career: data['career'] ?? '',
      love: data['love'] ?? '',
      health: data['health'] ?? '',
      finance: data['finance'] ?? '',
      mood: data['mood'] ?? '',
      luckyNumber: data['luckyNumber'] ?? '',
      luckyColor: data['luckyColor'] ?? '',
      luckyTime: data['luckyTime'] ?? '',
      dos: List<String>.from(data['dos'] ?? []),
      donts: List<String>.from(data['donts'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'zodiacSign': zodiacSign,
      'dailySummary': dailySummary,
      'career': career,
      'love': love,
      'health': health,
      'finance': finance,
      'mood': mood,
      'luckyNumber': luckyNumber,
      'luckyColor': luckyColor,
      'luckyTime': luckyTime,
      'dos': dos,
      'donts': donts,
    };
  }
}
