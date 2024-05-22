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
  bool _isPasswordVisible1 = false;
  bool _isPasswordVisible2 = false;
  bool pasarFire = true; // Definir la variable pasarFire

  FirebaseManager fm = FirebaseManager();

  // METODOS
  void registrarse() {
    pasarFire = true;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (contrasenia1 != contrasenia2) {
        Fluttertoast.showToast(
          msg: 'Las contraseñas no coinciden',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      fm.registerNewUser(correo!, contrasenia1!, usuario!).then((success) {
        if (success == true) {
          Fluttertoast.showToast(
            msg: 'Usuario registrado correctamente',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Error al registrar el usuario',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      });
    }
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'El campo $fieldName está vacío';
    } else if (fieldName == 'Nombre del usuario' && !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'El campo $fieldName solo puede contener \nletras de la A a la Z y números';
    } else if (fieldName == 'Email' && !value.contains('@')) {
      return 'El campo $fieldName debe contener un "@"';
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
      body: Stack(
        children: [
          Positioned(
            top: 20.0,
            left: 20.0,
            right: 20.0,
            child: Image.asset(
              'assets/img/OtakuTracing_Logo.jpg',
              width: MediaQuery.of(context).size.width - 40.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 230.0), // Ajusta el espacio según sea necesario
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
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible1 ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible1 = !_isPasswordVisible1;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible1,
                          onSaved: (value) => contrasenia1 = value,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirmar contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible2 ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible2 = !_isPasswordVisible2;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible2,
                          validator: (value) {
                            contrasenia2 = value;
                            return _validateField(value, 'Confirmar contraseña');
                          },
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
        ],
      ),
    );
  }
}
