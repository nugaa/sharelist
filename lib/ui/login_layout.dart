import 'package:afazeres/servicos/autenticacao_bloc.dart';
import 'package:flutter/material.dart';

class LoginLayout extends StatelessWidget {
  Auth_Bloc _authBloc = Auth_Bloc();
  @override
  Widget build(BuildContext context) {
    var result;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.blueGrey[700],
              Colors.blueGrey[500],
              Colors.blueGrey[200],
            ],
          ),
        ),
        child: SafeArea(
          child: Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.45), BlendMode.dstIn),
                image: AssetImage('images/logo.png'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 35.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        result = await _authBloc.googleSignInn();
                        if (result != null) {
                          Navigator.of(context)
                              .pushNamed('/postit', arguments: {
                            'user': result.user.displayName,
                            'foto': result.user.photoURL,
                            'email': result.user.email
                          });
                        }
                      },
                      child: Image.asset(
                        'images/google_mail_logo.png',
                        scale: 25.0,
                      ),
                    ),
                    SizedBox(
                      width: 40.0,
                    ),
                    InkWell(
                      onTap: () async {
                        result = await _authBloc.obterDadosFacebook();
                        if (result != null) {
                          Navigator.of(context)
                              .pushNamed('/postit', arguments: {
                            'user': result['name'],
                            'foto': result['picture']['data']['url'],
                            'email': result['email']
                          });
                        }
                      },
                      child: Image.asset(
                        'images/f_Logo_(with_gradient).png',
                        scale: 28.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  'Entre com uma das suas contas.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
