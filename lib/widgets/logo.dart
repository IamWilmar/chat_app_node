import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Image(image: AssetImage('assets/paper-plane.png'), height: 170.0),
            SizedBox(height: 20),
            Text('Fast Message', style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}