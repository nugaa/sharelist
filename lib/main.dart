import 'package:afazeres/servicos/conexao_bloc.dart';
import 'package:afazeres/ui/login_layout.dart';
import 'package:afazeres/ui/postit_layout.dart';
import 'package:afazeres/ui/tarefas_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/tarefas_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Conexao_Bloc conexaoStatus = Conexao_Bloc.getInstance();
  conexaoStatus.initConexao();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TarefasData>(
      create: (context) => TarefasData(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => LoginLayout(),
          '/postit': (context) => PostIt_Layout(),
          '/tarefas': (context) => TarefasLayout(),
        },
      ),
    );
  }
}
