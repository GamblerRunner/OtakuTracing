import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text(
            'Otaku Tracing',
                style: TextStyle(
                fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.white
                ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('Bienvenido'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {  },
        child: Text(
            'click'
        ),
        backgroundColor: Colors.black,
      ),
    )
  ));
}
