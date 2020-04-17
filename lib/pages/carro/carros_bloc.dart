import 'dart:async';

import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:carros/pages/carro/carro_dao.dart';
import 'package:carros/utils/network.dart';

class CarrosBloc {

  final _streamController = StreamController<List<Carro>>();

  Stream<List<Carro>> get stream => _streamController.stream;

  Future<List<Carro>> fetch(String tipo) async{
    try {

      bool networkOn = await isNetworkOn();

      if(!networkOn) {
        List<Carro> carros = await CarroDAO().findAllByTipo(tipo);
        _streamController.add(carros);
        return carros;
      }

      List<Carro> carros = await CarrosApi.getCarros(tipo);

      if (carros.isNotEmpty){
         final dao = CarroDAO();
        //Salva todos os carros
        carros.forEach(dao.save);
      }

      _streamController.add(carros);

      return carros;
    } catch (e) {
     _streamController.addError(e);
    }
  }

  void dispose() {
    _streamController.close();
  }
}
