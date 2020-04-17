import 'package:carros/drawer_list.dart';
import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:carros/pages/carro/carros_listview.dart';
import 'package:carros/pages/carro/carros_page.dart';
import 'package:carros/pages/favoritos/favoritos_page.dart';
import 'package:carros/utils/prefs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _initTabs();
  }

  _initTabs() async {
    _tabController = TabController(length: 4, vsync: this);

    int tabIdx = await Prefs.getInt("tabIdx");
    _tabController.index = tabIdx;

    _tabController.addListener(() {
      Prefs.setInt("tabIdx", _tabController.index);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        centerTitle: true,
        bottom: TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(
                text: "Clássicos",
                icon: Icon(Icons.directions_car),
              ),
              Tab(
                text: "Esportivos",
                icon: Icon(Icons.flag),
              ),
              Tab(text: "Luxo", icon: Icon(Icons.attach_money)),
              Tab(text: "Favoritos", icon: Icon(Icons.favorite)),
            ]),
      ),
      body: TabBarView(controller: _tabController, children: [
        CarrosPage(
          TipoCarro.classicos,
        ),
        CarrosPage(
          TipoCarro.esportivos,
        ),
        CarrosPage(
          TipoCarro.luxo,
        ),
        FavoritosPage(),
      ]),
      drawer: DrawerList(),
    );
  }
}
