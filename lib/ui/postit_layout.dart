import 'dart:async';
import 'package:afazeres/servicos/autenticacao_bloc.dart';
import 'package:afazeres/servicos/conexao_bloc.dart';
import 'package:afazeres/servicos/firestore_listas.dart';
import 'package:afazeres/widgets/dialog_logout.dart';
import 'package:afazeres/widgets/dialog_nova_lista.dart';
import 'package:afazeres/widgets/waitNoticeWidget.dart';
import 'package:flutter/material.dart';

class PostIt_Layout extends StatefulWidget {
  @override
  _PostIt_LayoutState createState() => _PostIt_LayoutState();
}

class _PostIt_LayoutState extends State<PostIt_Layout>
    with TickerProviderStateMixin {
  StreamSubscription _conexaoAlteradaStream;
  bool isOff = false;
  Auth_Bloc authBloc = Auth_Bloc();
  bool alterar;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    alterar = true;
    Conexao_Bloc conexaoStatus = Conexao_Bloc.getInstance();
    _conexaoAlteradaStream =
        conexaoStatus.conexaoStream.listen(conexaoAlterada);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  void animate(BuildContext context) {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  void conexaoAlterada(dynamic temConexao) {
    setState(() {
      isOff = !temConexao;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _conexaoAlteradaStream.cancel();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map result = ModalRoute.of(context).settings.arguments as Map;
    String fotoUrl = result['foto'];
    String nomeUser = result['user'];
    String emailUser = result['email'];
    return Scaffold(
      appBar: AppBar(
        leading: Image.network(fotoUrl),
        title: Text(nomeUser),
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.logout,
                size: 30.0,
              ),
            ),
            onTap: () {
              mostrarDialogLogout(context);
            },
          ),
        ],
        backgroundColor: Colors.black38,
      ),
      floatingActionButton: alterar
          ? FloatingActionButton(
              backgroundColor: Colors.blueGrey.withOpacity(0.35),
              child: Icon(
                Icons.add,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: isOff == false
                  ? () async {
                      await mostrarDialogNovaLista(context, emailUser, true);
                    }
                  : null,
            )
          : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.blueGrey, Colors.blueGrey[200]],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FlatButton(
                      color:
                          alterar == true ? Colors.black26 : Colors.transparent,
                      onPressed: alterar == false
                          ? () {
                              setState(() {
                                alterar = true;
                                animate(context);
                                _animationController.forward();
                              });
                            }
                          : () {},
                      child: Text(
                        'Listas Pessoais',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      color: alterar == false
                          ? Colors.black26
                          : Colors.transparent,
                      onPressed: alterar == true
                          ? () {
                              setState(() {
                                alterar = false;
                                animate(context);
                                _animationController.forward();
                              });
                            }
                          : () {},
                      child: Text(
                        'Listas Partilhadas',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity > 0) {
                      // User swiped Left
                      setState(() {
                        alterar = true;
                        animate(context);
                        _animationController.forward();
                      });
                      return Container(color: Colors.red);
                    } else if (details.primaryVelocity < 0) {
                      // User swiped Right
                      setState(() {
                        alterar = false;
                        animate(context);
                        _animationController.forward();
                      });
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: alterar
                        ? SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(-1, 0),
                              end: Offset.zero,
                            ).animate(_animationController),
                            child: listasPessoais(
                              isOff: isOff,
                              emailUser: emailUser,
                            ))
                        : SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(1, 0),
                              end: Offset.zero,
                            ).animate(_animationController),
                            child: listasPartilhadas(
                              isOff: isOff,
                              emailUser: emailUser,
                            )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class listasPessoais extends StatelessWidget {
  const listasPessoais({
    Key key,
    @required this.isOff,
    @required this.emailUser,
  }) : super(key: key);

  final bool isOff;
  final String emailUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: isOff == false
              ? FirestoreListas().streamNomeLista(emailUser, false)
              : SafeArea(
                  child: waitInternetWidget(
                      context, 'A aguardar ligação à internet...')),
        ),
      ),
    );
  }
}

class listasPartilhadas extends StatelessWidget {
  const listasPartilhadas({
    Key key,
    @required this.isOff,
    @required this.emailUser,
  }) : super(key: key);

  final bool isOff;
  final String emailUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: isOff == false
            ? FirestoreListas().streamNomeLista(emailUser, true)
            : SafeArea(
                child: waitInternetWidget(
                    context, 'A aguardar ligação à internet...')),
      )),
    );
  }
}
