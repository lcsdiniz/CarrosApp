import 'dart:async';

import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carro_page.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:carros/pages/carro/carros_bloc.dart';
import 'package:carros/pages/carro/carros_listview.dart';
import 'package:carros/pages/favoritos/favoritos_bloc.dart';
import 'package:carros/utils/nav_push.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';

class FavoritosPage extends StatefulWidget {

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> with AutomaticKeepAliveClientMixin<FavoritosPage> {

  final _bloc = FavoritosBloc();

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();

    _bloc.fetch();
  }

  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
      stream: _bloc.stream,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return TextError("Erro ao buscar carros.");
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)),
          );
        }

        List<Carro> carros = snapshot.data;
        return RefreshIndicator(
            onRefresh: _onRefresh,
        child: CarrosListView(carros),);
      },
    );
  }

  Future<void> _onRefresh() {
    return _bloc.fetch();
  }

  void dispose() {
    super.dispose();
  }
}
