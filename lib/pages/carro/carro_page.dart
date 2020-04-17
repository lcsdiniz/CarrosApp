import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/loripsum_bloc.dart';
import 'package:carros/pages/favoritos/favorito.dart';
import 'package:carros/pages/favoritos/favorito_service.dart';
import 'package:carros/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarroPage extends StatefulWidget {

  Carro carro;

  CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _loripsumApiBloc = LoripsumBloc();

  Color color = Colors.grey;

  Carro get carro => widget.carro;

  @override
  void initState() {
    super.initState();

    FavoritoService.isFavorito(carro).then((bool favorito) {
      setState(() {
        color = favorito ? Colors.redAccent : Colors.grey;
      });
    });

    _loripsumApiBloc.fetch();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.carro.nome,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: _onClickMapa,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _onClickVideo,
          ),
          PopupMenuButton<String>(
              onSelected: (String value) => _onClickPopupMenu(value),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: "Editar",
                    child: Text("Editar"),
                  ),
                  PopupMenuItem(
                    value: "Deletar",
                    child: Text("Deletar"),
                  ),
                  PopupMenuItem(
                    value: "Compartilhar",
                    child: Text("Compartilhar"),
                  ),
                ];
              })
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
      CachedNetworkImage(
      imageUrl: widget.carro.urlFoto),
          firstBlock(),
          Divider(color: Colors.white,),
          secondBlock(),
        ],
      ),
    );
  }

  firstBlock() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text(widget.carro.nome, fontSize: 20, bold: true),
                  text(widget.carro.tipo, fontSize: 16, bold: false),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.favorite, size:30),
                  onPressed: _onClickFavorito,
                  color: color,
                ),
                IconButton(
                  icon: Icon(Icons.share, size:30),
                  onPressed: _onClickShare,
                ),
              ],
            )
          ],
        );
  }

  secondBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20,),
        text(widget.carro.descricao, fontSize: 16, bold: true),
        SizedBox(height: 20,),
        StreamBuilder<String>(
          stream: _loripsumApiBloc.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)),);
            }

            return text(snapshot.data, fontSize: 16);
          },
        )
      ],
    );
  }

  _onClickMapa() {}

  _onClickVideo() {}

  _onClickPopupMenu(String value) {
    switch (value) {
      case "Editar":
        print("Editando!");
        break;
      case "Deletar":
        print("Deletando!");
        break;
      case "Compartilhar":
        print("Compartilhando!");
        break;
    }
  }

  _onClickFavorito() async {
    bool favorito = await FavoritoService.favoritar(carro);

    setState(() {
      color = favorito ? Colors.redAccent : Colors.grey;
    });
  }

  _onClickShare() {
  }

  void dispose() {
    super.dispose();

    _loripsumApiBloc.dispose();
  }
}
