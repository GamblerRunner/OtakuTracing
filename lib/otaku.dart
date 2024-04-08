class Otaku {
  Otaku(this._id, this._user, this._email, this._password);
  int _id;
  String _user;
  String _email;
  String _password;

  /*
  Otaku.map(dynamic obj) {
    this._user = obj['Usuario'];
    this._email = obj['Email'];
    this._password = obj['Contraseña'];
  }

  int get id => _id;
  String get user => _user;
  String get email => _email;
  String get password => _password;

  Otaku.fromSnapShot(DataSnapshot snapshot) {
    _id = snapshot.ket;
    _user = snapshot.value['Usuario'];
    _email = snapshot.value['Email'];
    _password = snapshot.value['Contraseña'];
  }
   */

}