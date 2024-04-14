import 'package:flutter/material.dart';
import 'package:tfc/otaku.dart';
import 'package:tfc/Firebase_Manager.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //VARIABLES
  String? usuario;
  String? correo;
  String? contrasenia1;
  String? contrasenia2;

  FirebaseManager fm = FirebaseManager();


  //METODOS
  void registrarse() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      fm.registerNewUser(correo!, contrasenia1!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'REGISTRO',
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
                  labelText: 'Usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El campo Usuario está vacío';
                  }
                  return null;
                },
                onSaved: (value) => usuario = value,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (value) {
                  // validación del correo electrónico
                },
                onSaved: (value) => correo = value,
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
                  // validación de la contraseña
                },
                onSaved: (value) => contrasenia1 = value,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (value) {
                  // validación de la confirmación de la contraseña
                },
                onSaved: (value) => contrasenia2 = value,
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: registrarse,
                    child: Text(
                      'Registrarse',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
