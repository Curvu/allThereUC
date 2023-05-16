import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'storage.dart' as storage;

Future<bool> tryLogin(String email, String password) async {
  try {
    var response = await http.post(
      Uri.parse('https://id.fw.uc.pt/v1/login'),
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'longLivedToken': 'true',
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    String token = jsonDecode(response.body)['token'] ?? '';
    print('token: $token');
    if (token == '') return false;
    await storage.saveTokenUC(token);
    return true;
  } catch (error) {
    return false;
  }
}

Future<bool> refreshToken() async {
  final credentials = await storage.getCredentials();
  return await tryLogin(credentials[0], credentials[1]);
}

Future<String> getToken() async {
  final token = await storage.getTokenUC();
  try {
    final response = await http.get(
      Uri.parse('https://id.fw.uc.pt/v1/user'),
      headers: {'authorization': token},
    );
    if(response.statusCode == 200) return token;
    await refreshToken();
    return '';
  } catch (error) {
    return '';
  }
}

Future<bool> getPresence(String token, String aula) async {
  try {
    final response = await http.get(
      Uri.parse('https://academic.fw.uc.pt/v1/student/class/$aula/presence'),
      headers: {'authorization': token},
    );
    return jsonDecode(response.body)['type'] == null;
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
