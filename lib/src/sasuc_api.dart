import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage.dart' as storage;

Future<bool> tryLogin(String user, String password) async {
  try {
    var response = await http.post(
      Uri.parse('https://portaldossas.uc.pt/PySiges/services/signetpos/login.json'),
      body: <String, String>{
        'user': user,
        'pwd': password
      },
    );

    String cookie = response.headers['set-cookie'] ?? '';

    if (cookie == '') return false;
    response = await http.post(
      Uri.parse('https://portaldossas.uc.pt/PySiges/services/signetpos/app/create_pin_token'),
      body: <String, String>{
        'p_user': user,
        'p_password': password,
        'p_pin': '0000',
      },
      headers: <String, String>{
        'Cookie': cookie
      },
    );
    if (response.statusCode != 200) return false;
    String token = jsonDecode(response.body)['token'] ?? '';
    storage.saveTokenSASUC(token);
    return true;
  } catch (error) {
    return false;
  }
}

