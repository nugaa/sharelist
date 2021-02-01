import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class Conexao_Bloc {
  static final Conexao_Bloc _instance = new Conexao_Bloc._internal();
  Conexao_Bloc._internal();

  static Conexao_Bloc getInstance() => _instance;
  final Connectivity _conexao = Connectivity();
  bool conBool = false;
  final conexaoStreamController = new StreamController.broadcast();
  Stream get conexaoStream => conexaoStreamController.stream;

  Future<bool> updateConexaoStatus(ConnectivityResult result) async {
    bool connPrevia = conBool;
    try {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        final resultado = await InternetAddress.lookup('google.com');
        if (resultado.isNotEmpty && resultado[0].rawAddress.isNotEmpty) {
          conBool = true;
        }
      } else {
        conBool = false;
      }
    } on Exception catch (_) {
      conBool = false;
    }
    if (connPrevia != conBool) {
      conexaoStreamController.add(conBool);
    }
  }

  Future<void> initConexao() async {
    ConnectivityResult result;
    try {
      result = await _conexao.checkConnectivity();
      updateConexaoStatus(result);
      _conexao.onConnectivityChanged.listen((result) {
        updateConexaoStatus(result);
      });
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return updateConexaoStatus(result);
  }

  void dispose() {
    conexaoStreamController.close();
  }
}
