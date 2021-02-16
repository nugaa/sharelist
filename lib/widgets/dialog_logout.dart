import 'package:afazeres/servicos/autenticacao_bloc.dart';
import 'package:flutter/material.dart';

mostrarDialogLogout(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.blueGrey, Colors.blueGrey[200]],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Pretende desconectar a sua conta?',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.black38;
                              } else {
                                return Colors.blueGrey[500];
                              }
                            }),
                          ),
                          onPressed: () {
                            Auth_Bloc().logout();
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/', (route) => false);
                          },
                          child: Text('Sim'),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.black38;
                              } else {
                                return Colors.blueGrey[500];
                              }
                            }),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Não'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
