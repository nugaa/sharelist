import 'package:afazeres/ui/tarefas_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/tarefas_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TarefasData>(
      create: (context) => TarefasData(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => TarefasLayout(),
        },
      ),
    );
  }
}
