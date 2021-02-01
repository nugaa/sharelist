import 'package:flutter/material.dart';

Widget waitNoticeWidget(BuildContext context, String aviso) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(16.0),
        ),
        height: MediaQuery.of(context).size.height / 6,
        width: MediaQuery.of(context).size.width / 1.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 15.0),
              Center(
                child: Text(
                  aviso,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ]);
}
