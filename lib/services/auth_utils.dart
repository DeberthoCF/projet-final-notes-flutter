import 'dart:convert';
import 'package:crypto/crypto.dart';

String hacherMotDePasse(String motDePasse) {
  final bytes = utf8.encode(motDePasse);
  final hash = sha256.convert(bytes);

  return hash.toString();
}
