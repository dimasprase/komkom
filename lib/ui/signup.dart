import 'package:flutter/material.dart';
import 'package:komkom/controller/styles.dart';
import 'package:komkom/controller/loginAnimation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import 'package:komkom/Components/SignUpLink.dart';
import 'package:komkom/Components/Form.dart';
import 'package:komkom/Components/SignInButton.dart';
import 'package:komkom/Components/WhiteTick.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:komkom/style/theme.dart' as Theme;
import 'package:komkom/style/animations.dart';
import 'package:komkom/controller/loginAnimation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodePhoneNumber = FocusNode();
  final FocusNode myFocusNodePassword = FocusNode();

  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupPhoneNumberController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController = new TextEditingController();

  PageController _pageController;

  AnimationController _controller;
  int _state = 0;

  Animation _animation;
  AnimationController _controllerButton;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.maxFinite;

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String nama, email, telepon, kataSandi, konfirmasiKataSandi;

  String codePhone;

  @override
  void initState() {
    super.initState();
    var _duration = new Duration(seconds: 5);
    _controller = new AnimationController(duration: _duration, vsync: this);
    _controller.repeat();
    _pageController = PageController();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 500), vsync: this);
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    _controller?.dispose();
    _controllerButton.dispose();
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Tween<double> tween = new Tween<double>(begin: 0.0, end: 1.00);
  Animation<double> get stepOne => tween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.0,
        0.125,
        curve: Curves.linear,
      ),
    ),
  );
  Animation<double> get stepTwo => tween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.125,
        0.26,
        curve: Curves.linear,
      ),
    ),
  );
  Animation<double> get stepThree => tween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.25,
        0.375,
        curve: Curves.linear,
      ),
    ),
  );
  Animation<double> get stepFour => tween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.375,
        0.5,
        curve: Curves.linear,
      ),
    ),
  );
  Animation<double> get stepFive => tween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.5,
        0.625,
        curve: Curves.linear,
      ),
    ),
  );
  Animation<double> get stepSix => tween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.625,
        0.75,
        curve: Curves.linear,
      ),
    ),
  );
  Animation<double> get stepSeven => tween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.75,
        0.875,
        curve: Curves.linear,
      ),
    ),
  );
  Animation<double> get stepEight => tween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.875,
        1.0,
        curve: Curves.linear,
      ),
    ),
  );

  Widget get forwardStaggeredAnimation {
    return new Center(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new PivotBar(
            alignment: FractionalOffset.centerLeft,
            controller: _controller,
            animations: [
              stepOne,
              stepTwo,
            ],
            marginRight: 0.0,
            marginLeft: 0.0,
            isClockwise: true,
          ),
          new PivotBar(
            controller: _controller,
            animations: [
              stepThree,
              stepEight,
            ],
            marginRight: 0.0,
            marginLeft: 0.0,
            isClockwise: false,
          ),
          new PivotBar(
            controller: _controller,
            animations: [
              stepFour,
              stepSeven,
            ],
            marginRight: 0.0,
            marginLeft: 32.0,
            isClockwise: true,
          ),
          new PivotBar(
            controller: _controller,
            animations: [
              stepFive,
              stepSix,
            ],
            marginRight: 0.0,
            marginLeft: 32.0,
            isClockwise: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return new Scaffold(
      key: _scaffoldKey,
      body: new Container(
          child: new Container(
              child: new ListView(
                padding: const EdgeInsets.all(0.0),
                children: <Widget>[
                  new Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 24,
                                ),
                                new Image.asset(
                                  'assets/img/blockchain.png',
                                  width: 120,
                                  height: 120,
                                ),
                                Container(
                                  height: 16,
                                ),
                                forwardStaggeredAnimation,
                                Container(
                                  height: 10.0,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Stack(
                                        alignment: Alignment.topCenter,
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          Container(
                                            child: new Form(
                                              key: _key,
                                              autovalidate: _validate,
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 10.0, bottom: 0.0, left: 25.0, right: 25.0),
                                                    child: TextFormField(
                                                      focusNode: myFocusNodeName,
                                                      controller: signupNameController,
                                                      keyboardType: TextInputType.text,
                                                      textCapitalization: TextCapitalization.words,
                                                      style: TextStyle(fontFamily: "MontserratRegular", fontSize: 14.0, color: Colors.black),
                                                      validator: validateName,
                                                      onSaved: (String val) {
                                                        nama = val;
                                                      },
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        icon: Icon(
                                                          FontAwesomeIcons.user,
                                                          color: Colors.red,
                                                          size: 16,
                                                        ),
                                                        hintText: "Nama",
                                                        hintStyle: TextStyle(fontFamily: "MontserratRegular", fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 250.0,
                                                    height: 1.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                                                    child: TextFormField(
                                                      focusNode: myFocusNodeEmail,
                                                      controller: signupEmailController,
                                                      keyboardType: TextInputType.emailAddress,
                                                      validator: validateEmail,
                                                      onSaved: (String val) {
                                                        email = val;
                                                      },
                                                      style: TextStyle(fontFamily: "MontserratRegular", fontSize: 14.0, color: Colors.black),
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        icon: Icon(
                                                          FontAwesomeIcons.envelope,
                                                          color: Colors.red,
                                                          size: 16,
                                                        ),
                                                        hintText: "Email",
                                                        hintStyle: TextStyle(fontFamily: "MontserratRegular", fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 250.0,
                                                    height: 1.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                  new Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0),
                                                        child: CountryCodePicker(
                                                            onChanged: _onCountryChange,
                                                            initialSelection: 'ID',
                                                            favorite: ['+62', 'ID']),
                                                      ),
                                                      Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0, right: 25.0),
                                                            child: TextFormField(
                                                              focusNode: myFocusNodePhoneNumber,
                                                              controller: signupPhoneNumberController,
                                                              keyboardType: TextInputType.phone,
                                                              validator: validateMobile,
                                                              onSaved: (String val) {
                                                                telepon = val;
                                                              },
                                                              style: TextStyle(fontFamily: "MontserratRegular", fontSize: 14.0, color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText: "Nomor Telepon",
                                                                hintStyle: TextStyle(fontFamily: "MontserratRegular", fontSize: 14.0),
                                                              ),
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    width: 250.0,
                                                    height: 1.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                                                    child: TextFormField(
                                                      focusNode: myFocusNodePassword,
                                                      controller: signupPasswordController,
                                                      obscureText: _obscureTextSignup,
                                                      validator: validatePassword,
                                                      onSaved: (String val) {
                                                        kataSandi = val;
                                                      },
                                                      style: TextStyle(fontFamily: "MontserratRegular", fontSize: 14.0, color: Colors.black),
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        icon: Icon(
                                                          Icons.lock_outline,
                                                          color: Colors.red,
                                                          size: 16,
                                                        ),
                                                        hintText: "Kata Sandi",
                                                        hintStyle: TextStyle(fontFamily: "MontserratRegular", fontSize: 14.0),
                                                        suffixIcon: GestureDetector(
                                                          onTap: _toggleSignup,
                                                          child: Icon(
                                                            FontAwesomeIcons.eye,
                                                            size: 15.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 250.0,
                                                    height: 1.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                                                    child: TextFormField(
                                                      controller: signupConfirmPasswordController,
                                                      obscureText: _obscureTextSignupConfirm,
                                                      validator: validateConfirmPassword,
                                                      onSaved: (String val) {
                                                        konfirmasiKataSandi = val;
                                                      },
                                                      style: TextStyle(fontFamily: "MontserratRegular", fontSize: 14.0, color: Colors.black),
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        icon: Icon(
                                                          Icons.lock_outline,
                                                          color: Colors.red,
                                                          size: 16,
                                                        ),
                                                        hintText: "Konfirmasi Kata Sandi",
                                                        hintStyle: TextStyle(fontFamily: "MontserratRegular", fontSize: 14.0),
                                                        suffixIcon: GestureDetector(
                                                          onTap: _toggleSignupConfirm,
                                                          child: Icon(
                                                            FontAwesomeIcons.eye,
                                                            size: 15.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 250.0,
                                                    height: 1.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                ],
                                              ),
                                            )
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          new SignUp()
                        ],
                      ),
                      animationStatus == 0
                          ? new Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: new InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              left: 16,
                              right: 16,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: PhysicalModel(
                                elevation: 8,
                                shadowColor: Colors.yellowAccent,
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  key: _globalKey,
                                  height: 48,
                                  width: _width,
                                  child: RaisedButton(
                                    animationDuration: Duration(milliseconds: 1000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: EdgeInsets.all(0),
                                    child: setUpButtonChild(),
                                    onPressed: () {
                                      setState(() {
                                        if (_state == 0) {
                                          animateButton();
                                        }
                                      });
                                    },
                                    elevation: 4,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ) : new StaggerAnimation(buttonController: _loginButtonController.view)
                    ],
                  ),
                ],
              ))),
    );
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: "MontserratRegular"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "Daftar",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() async {

    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      print("Name $nama");
      print("Mobile $telepon");
      print("Email $email");
      print("Password $kataSandi");
      print("Confirm Password $konfirmasiKataSandi");

      double initialWidth = _globalKey.currentContext.size.width;

      _controllerButton =
          AnimationController(duration: Duration(milliseconds: 150), vsync: this);

      _animation = Tween(begin: 0.0, end: 1).animate(_controllerButton)
        ..addListener(() {
          setState(() {
            _width = initialWidth - ((initialWidth - 48) * _animation.value);
          });
        });
      _controllerButton.forward();

      setState(() {
        _state = 1;
      });


      /*Timer(Duration(milliseconds: 1000), () {
        setState(() {
          _state = 2;
          setState(() {
            animationStatus = 1;
          });
          //_controllerButton.reverse();
          _playAnimation();
        });
      });*/

      Map datas = {
        'nama': signupNameController.text,
        'email': signupEmailController.text,
        'nomorTelepon': codePhone+signupPhoneNumberController.text,
        'password': signupPasswordController.text
      };

      var url = 'http://kokom.gisolusi.com/mobileAppApi/insertUser.php';

      try{

        final response = await http.post(url, body:datas);

        List<dynamic> value = json.decode(response.body);
        print(value);
        bool success = value[0]['success'];
        print("Sukses "+success.toString());

        if (!success) {
          _state = 0;
          setState(() {
            animationStatus = 0;
          });
          _controllerButton.reverse();
          showInSnackBar(value[0]['value'].toString());
        } else if (success) {
          _state = 2;
          setState(() {
            animationStatus = 1;
          });
          _playAnimation();
        } else {
          _state = 0;
          setState(() {
            animationStatus = 0;
          });
          _controllerButton.reverse();
          showInSnackBar("gagal");
        }

      } catch(e) {
        showInSnackBar(e.toString());
      }

    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  String validateName(String value) {
    if (value.length == 0) {
      return "Isi nama Anda";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Isi email";
    } else if(!regExp.hasMatch(value)){
      return "Email salah";
    }else {
      return null;
    }
  }

  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Isi nomor telepon";
    } else if (!regExp.hasMatch(value)) {
      return "Nomor telepon salah";
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Isi kata sandi";
    } else if (value.length < 8) {
      return "Kata sandi terlalu pendek";
    }
    return null;
  }

  String validateConfirmPassword(String value) {
    if (value.length == 0) {
      return "Isi kata sandi";
    } else if (value.length < 8) {
      return "Kata sandi terlalu pendek";
    } else if (value != signupPasswordController.text) {
      return "Kata sandi tidak cocok";
    }
    return null;
  }

  void _onCountryChange(CountryCode countryCode) {
    //print("New Country selected: " + countryCode.toString());
    setState(() {
      codePhone = countryCode.toString();
    });
  }
}