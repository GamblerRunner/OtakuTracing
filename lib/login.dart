import 'package:flutter/material.dart';

void main() {

  String? email = '';
  String? password = '';

  String emailCorrecto = 'javi@gmail.com';
  String passwordCorrecto = 'Javier';

  runApp(MaterialApp(
    home: Scaffold(

      appBar: AppBar(
        title: Text('Inicio de Sesion'),
      ),

      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(5.0),
              elevation: 4.0,
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Introduzca su email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          )
                        ),
                        validator: ( String? value ) {
                          if( value!.isEmpty ) {
                            return 'El campo esta vacio';
                          }
                          else {
                            if( value.contains(' ') ) {
                              return 'El email contiene espacios';
                            }
                            else {
                              return null;
                            }
                          }
                        },
                        onSaved: ( String? value ) => email = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            hintText: 'Introduzca su contraseña',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            )
                        ),
                        validator: ( String? value ) {
                          if( value!.isEmpty ) {
                            return 'El campo esta vacio';
                          }
                          else {
                            if( value.length < 6 ) {
                              return 'Contraseña demasiado corta';
                            }
                            else {
                              return null;
                            }
                          }
                        },
                        onSaved: ( String? value ) => email = value,
                      )
                    ],
                  ),
                ),
              ),
            )

          ],
        )
      ),
    )
  ));

}