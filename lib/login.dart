import 'dart:async';

import 'package:flutter/material.dart';
import 'videos.dart';
import 'package:http/http.dart' as http;

void main() => runApp(LoginApp());

String code;

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'flutter + Mysql',
        home: LoginPage(),
        routes: <String, WidgetBuilder>{
          '/videoPage': (BuildContext context) => new VideoApp(),
          '/loginPage': (BuildContext context) => new LoginPage(),
        });
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerEmailUser = new TextEditingController();
  TextEditingController controllerPass = new TextEditingController();

  String mensaje = '';

  Future<String> login() async {
    final response = await http.post(
        "http://10.1.205.96/david/httpserver/api/check_register_code.php",
        body: {"code": controllerPass.text});

    var datauser = (response.body);

    if (datauser.length == 0) {
      setState(() {
        mensaje = "Login Fail";
      });
    } else {
      Navigator.pushReplacementNamed(context, '/videoPage');
      setState(() {
        code = datauser;
      });
    }

    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.green,
          ),
          child: Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 50.0),
                child: new CircleAvatar(
                  backgroundColor: Color(0xFFFFFFFF),
                  child: new Image(
                    width: 300,
                    height: 300,
                    image: AssetImage("assets/images/LOGO.png"),
                  ),
                ),
                width: 170,
                height: 170,
                decoration: BoxDecoration(shape: BoxShape.rectangle),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 93),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 5)
                          ]),
                      child: TextFormField(
                        controller: controllerEmailUser,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            hintText: 'Correo electronico (opcional)'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 50,
                      margin: EdgeInsets.only(top: 32),
                      padding: EdgeInsets.only(top: 4, left: 16, right: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5)
                          ]),
                      child: TextField(
                        controller: controllerPass,
                        obscureText: true,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.vpn_key,
                              color: Colors.black,
                            ),
                            hintText: 'Codigo temporal de 8 digitos'),
                      ),
                    ),
                    Spacer(),
                    new RaisedButton(
                      child: new Text('Sincronizar'),
                      color: Colors.orangeAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                      onPressed: () {
                        login();
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      mensaje,
                      style: TextStyle(fontSize: 5.0, color: Colors.red),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
