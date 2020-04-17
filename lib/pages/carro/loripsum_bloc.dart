import 'dart:async';
import 'package:carros/pages/carro/loripsum_api.dart';

class LoripsumBloc {

  static String lorim;

  final _streamController = StreamController<String>();

  Stream<String> get stream => _streamController.stream;

  fetch() async {
    String s = lorim ?? await LoripsumApi.getLoripsum();

    lorim = s;

    _streamController.add(s);
  }

  void dispose() {
    _streamController.close();
  }
}
