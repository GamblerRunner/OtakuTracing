import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Firebase_Manager.dart';
import 'register.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  Login createState() => Login();
}

class Login extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  String? email = '';
  String? contrasenia = '';
  bool obscureText = true;

  bool rememberEmailPassword = false;

  late FirebaseManager fm;

  // METODOS
  @override
  void initState() {
    super.initState();
    fm = FirebaseManager();
    loadUser();
  }

  Future<void> iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? success = await fm.loginUser(email!, contrasenia!);
      if (success!='') {
        Fluttertoast.showToast(
          msg: 'Successful login \nWelcome Otaku',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString("uid", success!);
        if(rememberEmailPassword){
          await preferences.setBool('rememberEmailPassword', true);
          await preferences.setString("email", email!);
          await preferences.setString("contrasenia", contrasenia!);
        }else{
          await preferences.remove('rememberEmailPassword');
          await preferences.remove("email");
          await preferences.remove("contrasenia");
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(animeManga: false,)),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Incorrect email or password \nPlease try again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> loadUser() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    bool remember = preferences.getBool("rememberEmailPassword") ?? false;
    if (remember) {
      email = preferences.getString("email") ?? '';
      contrasenia = preferences.getString("contrasenia") ?? '';

      await Future.delayed(Duration(seconds: 1));

      String? success = await fm.loginUser(email!, contrasenia!);
      print('jd que putada $success');
      if (success != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(animeManga: false,)),
        );
      }else{
        await preferences.remove("uid");
      }
    }
  }

  // MAIN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        automaticallyImplyLeading: false,
        title: Text(
          'LOGIN',
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
                        labelText: 'Password',
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
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberEmailPassword,
                          onChanged: (bool? value) {
                            setState(() {
                              rememberEmailPassword = value ?? false;
                            });
                          },
                        ),
                        Text('Remember me'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: SizedBox(
                        width: 200.0,
                        child: ElevatedButton(
                          onPressed: iniciarSesion,
                          child: Text(
                            'Sign in',
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
                          'You do not have an account? Sign up',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

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
