class UserModel {
  final String uid;
  final String name;
  final DateTime dob;
  final String timeOfBirth;
  final String placeOfBirth;
  final String zodiacSign;

  UserModel({
    required this.uid,
    required this.name,
    required this.dob,
    required this.timeOfBirth,
    required this.placeOfBirth,
    required this.zodiacSign,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      name: data['name'] ?? '',
      dob: data['dob'] != null ? DateTime.parse(data['dob']) : DateTime.now(),
      timeOfBirth: data['timeOfBirth'] ?? '',
      placeOfBirth: data['placeOfBirth'] ?? '',
      zodiacSign: data['zodiacSign'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dob': dob.toIso8601String(),
      'timeOfBirth': timeOfBirth,
      'placeOfBirth': placeOfBirth,
      'zodiacSign': zodiacSign,
    };
  }
}
