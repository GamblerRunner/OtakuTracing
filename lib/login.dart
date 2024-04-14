import 'package:flutter/material.dart';

import 'Firebase_Manager.dart';


class LoginPage extends StatefulWidget {
  @override
  Login createState() => Login();
}

class Login extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // VARIABLES
  String? email = '';
  String? contrasenia = '';
  bool recordarUsuario = false;

  late FirebaseManager fm;

  // METODOS
  @override
  void initState() {
    super.initState();
    fm = FirebaseManager();
  }

  void iniciarSesion() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Guardar los valores del formulario
      fm.loginUser(email!, contrasenia!);
    }
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
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El campo Email está vacío';
                  }
                  return null;
                },
                onSaved: (value) => email = value,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El campo Contraseña está vacío';
                  }
                  return null;
                },
                onSaved: (value) => contrasenia = value,
              ),
              SizedBox(height: 15),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: recordarUsuario,
                    onChanged: (bool? value) {
                      setState(() {
                        recordarUsuario = value!;
                      });
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
                    onPressed: iniciarSesion,
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
