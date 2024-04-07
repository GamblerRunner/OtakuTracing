import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LoginPage extends StatelessWidget {

  // VARIABLES
  String? user = '';
  String? email = '';
  String? password1 = '';
  String? password2 = '';

  String emailCorrecto = 'javi@gmail.com';
  String passwordCorrecto = 'javier2004';

  // METODOS
  void iniciarSesion() {
  }


  // MAIN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INICIO DE SESIÓN'),
        backgroundColor: Colors.lightBlue
      ),

      body: Container(
          padding: EdgeInsets.all(16.100),
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
                              labelText: 'Nombre del usuario',
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
                          onSaved: ( String? value ) => user = value,
                        ),
                        SizedBox(height: 15),

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
                        SizedBox(height: 15),

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
                          onSaved: ( String? value ) => password1 = value,
                        ),
                        SizedBox(height: 15),

                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Confirmar contraseña',
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
                          onSaved: ( String? value ) => password2 = value,
                        ),
                        SizedBox(height: 15),

                        Row(
                          children: <Widget>[
                            Checkbox(value: false, onChanged: null),
                            Text('Recordar contraseña')
                          ],
                        ),
                        SizedBox(height: 235),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text('Iniciar Sesión', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              onPressed: () => iniciarSesion(),
                            ),
                          ],

                        )

                      ],
                    ),
                  ),
                ),
              )

            ],
          )
      ),

    );
  }
}

