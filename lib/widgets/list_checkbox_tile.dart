import 'package:flutter/material.dart';

class ListCheckboxTile extends StatelessWidget {
  final bool isChecked;
  final Function toggleIt;
  final String nomeTarefa;

  ListCheckboxTile({this.isChecked, this.toggleIt, this.nomeTarefa});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        nomeTarefa,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
          color: Colors.black,
          fontSize: 20.0,
        ),
      ),
      value: isChecked,
      onChanged: toggleIt,
    );
  }
}
