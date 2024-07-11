import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/Firebase/Firebase_Manager.dart';
import 'login.dart'; // Importar la pantalla de inicio de sesión

class RegisterPage extends StatefulWidget {
  @override
  Register createState() => Register();
}

class Register extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? usuario;
  String? correo;
  String? contrasenia1;
  String? contrasenia2;
  bool isPasswordVisible1 = false;
  bool isPasswordVisible2 = false;
  bool passFire = true;

  FirebaseManager fm = FirebaseManager();

  /// Handles the user registration process.
  void registrarse() {
    passFire = true; // Flag indicating that password validation should be triggered.

    if (formKey.currentState!.validate()) {
      // If the form is valid, save the form state.
      formKey.currentState!.save();

      // Check if the passwords match.
      if (contrasenia1 != contrasenia2) {
        // Show a toast message if the passwords do not match.
        Fluttertoast.showToast(
          msg: 'Passwords do not match',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      // Attempt to register a new user.
      fm.registerNewUser(correo!, contrasenia1!, usuario!).then((success) async {
        if (success == true) {
          // Show a toast message if registration is successful.
          Fluttertoast.showToast(
            msg: 'Successfully registered user',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );

          // Store the default profile image URL in shared preferences.
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString("newImgProfile", "https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg");

          // Navigate to the login page.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // Show a toast message if there is an error during registration.
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


  String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'The field $fieldName is empty';
    } else if (fieldName == 'User name' && !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
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
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          validator: (value) => validateField(value, 'Nombre del usuario'),
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
                          validator: (value) => validateField(value, 'Email'),
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
                                isPasswordVisible1 ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible1 = !isPasswordVisible1;
                                });
                              },
                            ),
                          ),
                          obscureText: !isPasswordVisible1,
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
                                isPasswordVisible2 ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible2 = !isPasswordVisible2;
                                });
                              },
                            ),
                          ),
                          obscureText: !isPasswordVisible2,
                          validator: (value) {
                            contrasenia2 = value;
                            return validateField(value, 'Confirmar contraseña');
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
