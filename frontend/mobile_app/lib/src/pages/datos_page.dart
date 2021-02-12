import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:connectivity/connectivity.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:app_deteccion_personas/src/models/image_model.dart';
import 'package:app_deteccion_personas/src/providers/image_provider.dart';
import 'package:app_deteccion_personas/src/models/ap_model.dart';
import 'package:app_deteccion_personas/src/models/wlc_model.dart';
import 'package:app_deteccion_personas/src/providers/ap_provider.dart';
import 'package:app_deteccion_personas/src/providers/wlc_provider.dart';
import 'package:app_deteccion_personas/src/widgets/varios_widget.dart';
import 'package:app_deteccion_personas/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:app_deteccion_personas/src/utils/utils.dart' as utils;

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState() => super.initState();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final wlcProvider = new WlcProvider();
  final apProvider = new ApProvider();
  final imageProvider = new ImagenProvider();
  final _prefs = PreferenciasUsuario();
  final _texto =
      'Para ver la información de la red, dirigirte a Información y Ajustes y el token de red que aparece cópialo en Tinkvice SSH';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight - 15),
          child: Container(
            color: utils.setColor('color6t5', 'color2'),
            child: Tab(
                child: Text('INFORMACIÓN DE RED',
                    style: TextStyle(
                        color: utils.getColor('color6'), fontSize: 18))),
          ),
        ),
        body: Container(child: _crearListado(context)));
  }

  Widget _crearListado(BuildContext context) {
    return FutureBuilder(
      future: apProvider.cargarWlcsAps(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: [
              utils.errorInfo(snapshot.error, Colors.red),
              utils.iconFont(Icons.wifi_off, context, '')
            ],
          );
        } else if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Column(
              children: [
                utils.errorInfo('Sin Información', Colors.purple),
                Expanded(
                    child:
                        utils.iconFont(Icons.business_sharp, context, _texto))
              ],
            );
          } else {
            final wlcs = snapshot.data;
            return ListView.builder(
              itemCount: wlcs.length,
              itemBuilder: (context, i) => _crearCard(wlcs[i], context),
            );
          }
        } else {
          return circularProgressIndicatorWidget();
        }
      },
    );
  }

  Widget _crearCard(WlcModel wlc, BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.bottom,
            ),
            header: Container(
              decoration: BoxDecoration(color: utils.getColor('color3t1')),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Text("WLC",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                        title: Text('${wlc.productName}'),
                        subtitle: Text('${wlc.mac}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            expanded: buildList(wlc.aps, context),
          ),
        ),
      ),
    ));
  }

  buildList(List<ApModel> aps, BuildContext context) {
    return Column(children: makeAps(aps, context));
  }

  List<Widget> makeAps(List<ApModel> aps, BuildContext context) {
    List<Widget> list = [];
    for (var item in aps) {
      list.add(Container(
        decoration: BoxDecoration(
            border: Border.all(width: 0.1, color: Colors.black45)),
        child: Column(
          children: [
            ListTile(
              dense: true,
              onTap: () async {
                final connectivityResult =
                    await (Connectivity().checkConnectivity());
                if (connectivityResult == ConnectivityResult.none) {
                  if (!_prefs.snackbarActive) {
                    _prefs.snackbarActive = true;
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(
                            content: Row(children: [
                          Icon(Icons.info),
                          SizedBox(width: 10.0),
                          Text("Sin conexión")
                        ])))
                        .closed
                        .then((SnackBarClosedReason reason) {
                      _prefs.snackbarActive = false;
                    });
                  }
                } else {
                  _actualizarAp(
                      context, item.limit, item.piso, item.mac, item.name);
                }
              },
              leading: Text("AP",
                  style:
                      TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
              title: Text(item.name, style: TextStyle(fontSize: 16)),
              subtitle: Text(item.model),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lím: ${item.limit}'),
                  Text((item.piso == "0") ? 'Piso: PB' : 'Piso: ${item.piso}P'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: LinearPercentIndicator(
                trailing: _mapFlatButton(context, item),
                leading: Text('${item.devices}/${item.limit}'),
                percent:
                    setPercent(int.parse(item.devices), int.parse(item.limit)),
                progressColor: utils.setColor('color6', 'color4'),
              ),
            ),
          ],
        ),
      ));
    }
    return list;
  }

  Widget _mapFlatButton(BuildContext context, ApModel ap) {
    bool hayPlanos = false;
    return FlatButton(
      color: utils.getColor('color5'),
      height: double.minPositive,
      minWidth: double.minPositive,
      child: Text('Ubicar', style: TextStyle(color: Colors.white)),
      onPressed: () async {
        List<ImageModel> planos = await imageProvider.cargarImages();
        for (ImageModel item in planos) {
          if (ap.piso.toString() == item.piso.toString()) {
            hayPlanos = true;
            Navigator.pushNamed(context, 'photo', arguments: ap);
          }
        }
        if (hayPlanos == false) {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('No se ha cargado un plano para este piso'),
                    actions: [
                      FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Aceptar",
                            style: TextStyle(color: utils.getColor('color5'))),
                      ),
                    ],
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  _actualizarAp(BuildContext context, String limit, String piso, String mac,
      String model) {
    showDialog(
      context: context,
      builder: (context) {
        String limitText = limit;
        String pisoText = piso;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  Text("Actualizar"),
                  Text(model, style: TextStyle(fontWeight: FontWeight.normal))
                ],
              ),
              content: Column(
                children: [
                  Row(children: [
                    Text('Límite'),
                    Expanded(child: Container()),
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          if (limitText != '1')
                            limitText = (int.parse(limitText) - 1).toString();
                          setState(() {});
                        }),
                    Text(limitText,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          limitText = (int.parse(limitText) + 1).toString();
                          setState(() {});
                        }),
                  ]),
                  Row(children: [
                    Text('Piso'),
                    Expanded(child: Container()),
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          if (pisoText != '0')
                            pisoText = (int.parse(pisoText) - 1).toString();
                          setState(() {});
                        }),
                    Text((pisoText == '0') ? 'PB' : '${pisoText}P',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          pisoText = (int.parse(pisoText) + 1).toString();
                          setState(() {});
                        }),
                  ]),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar",
                            style: TextStyle(color: utils.getColor('color5')))
                ),
                FlatButton(
                  onPressed: () async {
                    final connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.none) {
                      Navigator.pop(context);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Row(children: [
                        Icon(Icons.info),
                        SizedBox(width: 10.0),
                        Text("Sin conexión")
                      ])));
                    } else {
                      apProvider.actualizarPisoLimite(mac, limitText, pisoText);
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, 'home');
                    }
                  },
                  child: Text("Aceptar",
                            style: TextStyle(color: utils.getColor('color5')))
                ),
              ],
            );
          },
        );
      },
    );
  }

  double setPercent(int devices, int limit) {
    if (devices > limit) return 1.0;
    else return devices / limit;
  }
}
