import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Importar Fluttertoast
import 'Firebase_Manager.dart';
import 'register.dart'; // Importa la pantalla de registro
import 'main.dart'; // Importa la pantalla principal

class LoginPage extends StatefulWidget {
  @override
  Login createState() => Login();
}

class Login extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // VARIABLES
  String? email = '';
  String? contrasenia = '';
  bool obscureText = true;

  late FirebaseManager fm;

  // METODOS
  @override
  void initState() {
    super.initState();
    fm = FirebaseManager();
  }

  void iniciarSesion() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      fm.loginUser(email!, contrasenia!);

      Fluttertoast.showToast(
        msg: "Inicio de sesión exitoso",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  // MAIN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'INICIAR SESIÓN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/img/Icono.jpg',
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
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
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
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
                    SizedBox(height: 25),
                    Center(
                      child: SizedBox(
                        width: 200.0, // Ajusta el ancho según sea necesario
                        child: ElevatedButton(
                          onPressed: iniciarSesion,
                          child: Text(
                            'Iniciar Sesión',
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
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          '¿No tienes una cuenta? Regístrate',
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
