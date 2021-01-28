import 'package:afazeres/models/tarefas_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class PostItInfo {
  staggeredTilesAdd() => StaggeredTile.count(1, 1);
  tilesAdd(Color cor, String nome) => PostItInfoWidget(cor, nome);
}

class PostItInfoWidget extends StatelessWidget {
  PostItInfoWidget(this.backgroundColor, this.nomeDaLista);
  final Color backgroundColor;
  final String nomeDaLista;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 10.0,
      color: backgroundColor,
      child: InkWell(
        onTap: () async {
          String passar = await Provider.of<TarefasData>(context, listen: false)
              .idDaLista(nomeDaLista);
          Navigator.of(context).pushNamed('/first', arguments: passar);
        },
        child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    nomeDaLista,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
