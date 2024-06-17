import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool pasarFire = true;

  FirebaseManager fm = FirebaseManager();

  // METODOS
  void registrarse() {
    pasarFire = true;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (contrasenia1 != contrasenia2) {
        Fluttertoast.showToast(
          msg: 'Passwords do not match',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      fm.registerNewUser(correo!, contrasenia1!, usuario!).then((success) async {
        if (success == true) {
          Fluttertoast.showToast(
            msg: 'Successfully registered user',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
          SharedPreferences preferences = await SharedPreferences.getInstance();

          await preferences.setString("newImgProfile", "https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Error registering user',
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
      return 'The field $fieldName is empty';
    } else if (fieldName == 'Nombre del usuario' && !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'The field $fieldName can only contain \nletters from A to Z and numbers';
    } else if (fieldName == 'Email' && !value.contains('@')) {
      return 'The field $fieldName must contain an "@"';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'REGISTRATION',
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
                            labelText: 'Username',
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
                            labelText: 'Password',
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
                            labelText: 'Confirm password',
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
                                'Sign up',
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
                              'Do you already have an account? Sign in',
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
