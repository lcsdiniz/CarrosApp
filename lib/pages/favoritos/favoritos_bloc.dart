import 'dart:async';

import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:carros/pages/carro/carro_dao.dart';
import 'package:carros/pages/favoritos/favorito_service.dart';
import 'package:carros/utils/network.dart';

class FavoritosBloc {

  final _streamController = StreamController<List<Carro>>();

  Stream<List<Carro>> get stream => _streamController.stream;

  Future<List<Carro>> fetch() async{
    try {
      List<Carro> carros = await FavoritoService.getCarros();

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
