import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  String apiKey = "AIzaSyDVampRmY60GuxQnaU4Oelcm2v2chzV51o";
  final response = await http.get(Uri.parse("https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey"));
  final data = jsonDecode(response.body);
  for (var model in data['models']) {
    print(model['name']);
  }
}
