import 'package:flutter/material.dart';
import 'package:tfc/otaku.dart';

class RegisterPage extends StatelessWidget {

  // VARIABLES
  String? usuario = '';
  String? correo = '';
  String? contrasenia1 = '';
  String? contrasenia2 = '';

  // METODOS
  void registrarse() {
  }

  // MAIN
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'REGISTRO',
           style: TextStyle(
               fontWeight: FontWeight.bold,
               color: Colors.white
          ),
        ),
        backgroundColor: Colors.black
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
                              labelText: 'Usuario',
                              // hintText: 'Introduzca su nombre de usuario',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          validator: ( String? value ) {
                            if( value!.isEmpty ) {
                              return 'El campo Usuario esta vacio';
                            } else {
                              return null;
                            }
                          },
                          onSaved: ( String? value ) => usuario = value,
                        ),
                        SizedBox(height: 15),

                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Email',
                              // hintText: 'Introduzca su email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          validator: ( String? value ) {
                            if( value!.isEmpty ) {
                              return 'El campo Email esta vacio';
                            } else {
                              if( value.contains(' ')) {
                                return 'El campo Email tiene espacios';
                              } else if (!value.contains('@') || !value.contains('.com')) {
                                return 'El campo Email le falta caracter clave';
                            } else {
                                return null;
                              }
                            }
                          },
                          onSaved: ( String? value ) => correo = value,
                        ),
                        SizedBox(height: 15),

                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Contraseña',
                              // hintText: 'Introduzca su contraseña',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          validator: ( String? value ) {
                            if( value!.isEmpty ) {
                              return 'El campo Contraseña esta vacio';
                            } else {
                              if( value.length < 9 ) {
                                return 'La Contraseña es demasiado corta';
                              } else {
                                return null;
                              }
                            }
                          },
                          onSaved: ( String? value ) => contrasenia1 = value,
                        ),
                        SizedBox(height: 15),

                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Confirmar contraseña',
                              // hintText: 'Introduzca su contraseña',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          validator: ( String? value ) {
                            if( value!.isEmpty ) {
                              return 'El Confirmar contraseña campo esta vacio';
                            }
                            else {
                              if( value.length < 9 ) {
                                return 'Contraseña demasiado corta';
                              }
                              else {
                                return null;
                              }
                            }
                          },
                          onSaved: ( String? value ) => contrasenia2 = value,
                        ),
                        SizedBox(height: 50),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text('Registrarse', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              onPressed: () => registrarse(),
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

