import 'dart:convert';

import 'package:douban_game_flutter/model/login_response.dart';
import 'package:douban_game_flutter/util/constant.dart';
import 'package:douban_game_flutter/util/douban_connection.dart';
import 'package:douban_game_flutter/util/exception.dart';
import 'package:douban_game_flutter/widget/back_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _doubanConn = DoubanConnection();

  Future<void> _handleSubmit() async {
    if (_usernameCtrl.text.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Input Username plz'),
      ));
      return;
    }
    if (_passwordCtrl.text.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Input Password plz'),
      ));
      return;
    }
    try {
      final response = await _doubanConn.login(
        _usernameCtrl.text,
        _passwordCtrl.text,
      );
      Map responseJson = json.decode(response);
      var loginResponse = LoginResponse.fromJson(responseJson);
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString(SHARED_PREFS['access_token'], loginResponse.accessToken);
      await prefs.setString(SHARED_PREFS['refresh_token'], loginResponse.refreshToken);
      await prefs.setString(SHARED_PREFS['douban_user_id'], loginResponse.doubanUserId);
      await prefs.setString(SHARED_PREFS['douban_user_name'], loginResponse.doubanUserName);
      await prefs.setInt(SHARED_PREFS['expires_in'], loginResponse.expiresIn);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Login Success!'),
      ));
      // TODO: trigger home page update
      Navigator.pop(context);
    } on BadRequestException {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Login Failed, Please Check Your Login Info.'),
      ));
    }
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        _handleSubmit();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff027333),
                  Color(0xff03A66A),
                ])),
        child: Text('Login'),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField('Username', _usernameCtrl),
        _entryField('Password', _passwordCtrl, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -MediaQuery.of(context).size.height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: BezierContainer(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                _emailPasswordWidget(),
                SizedBox(
                  height: 20,
                ),
                _submitButton(),
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 0,
            child: BackButtonWidget(),
          ),
        ],
      ),
    )));
  }
}
