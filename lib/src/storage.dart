import 'package:localstorage/localstorage.dart';

final LocalStorage storage = LocalStorage('allThereUC');

Future saveCredentials(String email, String password) async {
  await storage.ready;
  await storage.setItem('email', email);
  await storage.setItem('password', password);
}

Future<List<String>> getCredentials() async {
  await storage.ready;
  return [await storage.getItem('email') ?? '', await storage.getItem('password') ?? ''];
}

Future saveTokenUC(String token) async {
  await storage.ready;
  await storage.setItem('tokenUC', token);
}

Future<String> getTokenUC() async {
  await storage.ready;
  return await storage.getItem('tokenUC') ?? '';
}

void saveTokenSASUC(String token) async {
  await storage.ready;
  await storage.setItem('tokenSASUC', token);
}

Future<String> getTokenSASUC() async {
  await storage.ready;
  return await storage.getItem('tokenSASUC') ?? '';
}

Future clear() async {
  await storage.ready;
  await storage.clear();
}