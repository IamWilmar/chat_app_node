import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String titulo;
  final String subTitulo;
  const Labels({
    Key key,
    @required this.route,
    @required this.titulo,
    @required this.subTitulo,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, route),
            child: Text(
              subTitulo,
              style: TextStyle(color: Colors.blue[600]),
            ),
          ),
        ],
      ),
    );
  }
}
