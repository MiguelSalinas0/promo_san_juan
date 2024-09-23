import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class _MenuProvider {
  List<dynamic> comercios = [];

  _MenuProvider();

  Future<List<dynamic>> cargarData() async {
    final resp = await rootBundle.loadString('data/comercios.json');
    Map dataMap = json.decode(resp);
    comercios = dataMap['comercios'];
    return comercios;
  }
}

final menuProvider = _MenuProvider();
