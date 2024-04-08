import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  // VARIABLES
  String? email = '';
  String? contrasenia = '';
  bool recordarUsuario = false;

  // METODOS
  void iniciarSesion(){

  }

  // MAIN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'INICIAR SESIÓN',
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
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          validator: ( String? value ) {
                            if( value!.isEmpty ) {
                              return 'El campo Email esta vacio';
                            } else {
                              return null;
                            }
                          },
                          onSaved: ( String? value ) => email = value,
                        ),
                        SizedBox(height: 15),

                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Contraseña',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          validator: ( String? value ) {
                            if( value!.isEmpty ) {
                              return 'El campo Contraseña esta vacio';
                            } else {
                              return null;
                            }
                          },
                          onSaved: ( String? value ) => contrasenia = value,
                        ),
                        SizedBox(height: 15),

                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: recordarUsuario,
                              onChanged: (bool? value) {
                                recordarUsuario = value!;
                              },
                            ),
                            Text('Recordar contraseña'),
                          ],
                        ),
                        SizedBox(height: 50),

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