import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

Future<String> tryLogin(String email, String password) async {
  var client = http.Client();
  try {
    var response = await client.post(
      Uri.parse('https://id.fw.uc.pt/v1/login'),
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'longLivedToken': 'false',
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return jsonDecode(response.body)['token'] ?? 'a';
  } finally {
    client.close();
  }
}

Future<bool> getPresence(String token, String aula) async {
  try {
    final response = await http.get(
      Uri.parse('https://academic.fw.uc.pt/v1/student/class/$aula/presence'),
      headers: {'authorization': token},
    );

    final responseData = jsonDecode(response.body);

    if (responseData['type'] == null) {
      return responseData['type'];
    } else {
      return true;
    }
  } catch (error) {
    return true;
  }
}

Future<dynamic> submitPresence(String token, String aula, String session) async {
  final payload = {"type": "local"};

  try {
    final response = await http.post(
      Uri.parse('https://academic.fw.uc.pt/v1/student/class/$aula/session/$session/presence'),
      headers: {
        'authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    return jsonDecode(response.body);
  } catch (error) {
    return false;
  }
}


Future<Map<String, String>> getAula(String token) async {
  try {
    final response = await http.get(
      Uri.parse('https://academic.fw.uc.pt/v1/student/sessions/next'),
      headers: {'authorization': token},
    );

    final responseData = jsonDecode(response.body) as List;
    String aula = '';
    String session = '';

    for (var element in responseData) {
      aula = element['edition']['key'];
      session = element['key'];
      DateTime start = DateTime.parse(element['start_date']);
      DateTime end = DateTime.parse(element['end_date']);
      DateTime now = DateTime.now();
      if (now.isAfter(start) && now.isBefore(end)) break;

      aula = '';
      session = '';
    }

    return {'aula': aula, 'session': session};
  } catch (error) {
    return {'aula': '', 'session': ''};
  }
}
