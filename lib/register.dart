import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tfc/Firebase_Manager.dart';
import 'login.dart'; // Importar la pantalla de inicio de sesión

class RegisterPage extends StatefulWidget {
  @override
  Register createState() => Register();
}

class Register extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // VARIABLES
  String? usuario;
  String? correo;
  String? contrasenia1;
  String? contrasenia2;
  bool pasarDatos1 = false;
  bool pasarDatos2 = false;

  FirebaseManager fm = FirebaseManager();

  // METODOS
  void registrarse() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      fm.registerNewUser(correo!, contrasenia1!);
      // Mostrar toast si todos los datos son correctos
      Fluttertoast.showToast(
        msg: "¡Registro exitoso!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'El campo $fieldName está vacío';
    } else {
      pasarDatos1 = true;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo contraseña está vacío';
    } else if (value.length < 7) {
      return 'La contraseña debe tener al menos 6 caracteres';
    } else if (contrasenia2 != contrasenia1) {
      return 'Las contraseñas no coinciden';
    } else {
      pasarDatos2 = true;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'REGISTRO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nombre del usuario',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) => _validateField(value, 'Nombre del usuario'),
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
                      validator: (value) => _validateField(value, 'Email'),
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
                      validator: (value) => _validatePassword(value),
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
                      validator: (value) => _validatePassword(value),
                      onSaved: (value) => contrasenia2 = value,
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: SizedBox(
                        width: 200.0, // Ajusta el ancho según sea necesario
                        child: ElevatedButton(
                          onPressed: registrarse,
                          child: Text(
                            'Registrarse',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Text(
                          '¿Ya tienes cuenta? Inicia sesión',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
