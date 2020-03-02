import 'package:flutter/material.dart';

class LibraryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.https),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          )
        ],
      ),
    );
  }
}
