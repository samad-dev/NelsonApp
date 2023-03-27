
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/DatabaseHelper.dart';
import '../main.dart';
import '../models/users.dart';
import 'home/home_screen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  late Users user;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  Future<void> login() async {
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    var db = await DatabaseHelper.instance.db;
    print('User Login');
    print("SELECT * FROM users where email = '"+emailcontroller.text.toString()+"' and password = '"+passwordcontroller.text.toString()+"'");
    List<Map> maps = await db!.rawQuery("SELECT * FROM users where email = '"+emailcontroller.text.toString()+"' and password = '"+passwordcontroller.text.toString()+"'");
    if(maps.length>0)
    {
      permissionServiceCall();
      print(maps[0]['id']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', maps[0]['id'].toString());
      await prefs.setString('email', maps[0]['email']);
      await prefs.setString('username', maps[0]['name']);
      await prefs.setString('route_id', maps[0]['route_id']);
      await prefs.setString('region', maps[0]['description']);
      await prefs.setString('out', maps[0]['duty_out']);
      await prefs.setString('interval', maps[0]['interval']);
      print(prefs.getString('id'));
      await initializeService();
      final service = FlutterBackgroundService();
      service.startService();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen({})));

    }
    else
    {
      Fluttertoast.showToast(msg: "Incorrect email or password, please try again");
      Navigator.of(context).pop();
    }
    /*var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie':
          'mailpoet_page_view=%7B%22timestamp%22%3A1661795477%7D; mailpoet_subscriber=%7B%22subscriber_id%22%3A12%7D'
    };
    var request = http.Request('POST',
        Uri.parse('https://sadqapakistan.org/wp-json/jwt-auth/v1/token'));
    request.bodyFields = {
      'username': emailcontroller.text.toString(),
      'password': passwordcontroller.text.toString()
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    // print(response.statusCode);
    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      final token = json.decode(data);
      // print(token);
      print(token['data']['email']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', token['data']['id'].toString());
      await prefs.setString('email', token['data']['email']);
      await prefs.setString('username', token['data']['displayName']);
      print(prefs.getString('id'));
      Navigator.of(context).pop();
      navigationService.navigateTo(homeScreenRoute);
    } else if (response.statusCode == 403) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Incorrect email or password, please try again");
    } else {
      Navigator.of(context).pop();
      print(response.stream.bytesToString());
    }*/
  }
  permissionServiceCall() async { 
    await permissionServices().then(
          (value) {
        if (value != null) {
          if (value[Permission.locationAlways]!.isGranted) {
            print(value);
          }
        }
      },
    );
  }



  /*Permission services*/
  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationAlways,
    ].request();

    if (statuses[Permission.locationAlways]!.isPermanentlyDenied) {
      await openAppSettings().then(
            (value) async {
          if (value) {
            if (await Permission.locationAlways.status.isPermanentlyDenied == true &&
                await Permission.locationAlways.status.isGranted == false) {
              // openAppSettings();
              permissionServiceCall(); /* opens app settings until permission is granted */
            }
          }
        },
      );
    } else {
      if (statuses[Permission.locationAlways]!.isDenied) {
        permissionServiceCall();
      }
    }

    /*{Permission.camera: PermissionStatus.granted, Permission.storage: PermissionStatus.granted}*/
    return statuses;
  }

  Widget _entryField(String title, {bool isPassword = false}) {
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
              obscureText: isPassword,
              controller: passwordcontroller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: (){
        login();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffff3764), Color(0xffd80031)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  // Widget _facebookButton() {
  //   return Container(
  //     height: 50,
  //     margin: EdgeInsets.symmetric(vertical: 20),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //     ),
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //           flex: 1,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Color(0xff1959a9),
  //               borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(5),
  //                   topLeft: Radius.circular(5)),
  //             ),
  //             alignment: Alignment.center,
  //             child: Text('f',
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 25,
  //                     fontWeight: FontWeight.w400)),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 5,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Color(0xff2872ba),
  //               borderRadius: BorderRadius.only(
  //                   bottomRight: Radius.circular(5),
  //                   topRight: Radius.circular(5)),
  //             ),
  //             alignment: Alignment.center,
  //             child: Text('Log in with Facebook',
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w400)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'N',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)
          ),
          children: [
            TextSpan(
              text: 'el',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'son',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Enter Email Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  obscureText: false,
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Enter Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  obscureText: true,
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true))
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                     /* Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),*/
                      // _divider(),
                      // _facebookButton(),
                      SizedBox(height: height * .055),
                      // _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              // Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ));
  }
}

class ClipPainter extends CustomClipper<Path>{
  @override

  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height );
    path.lineTo(size.width , height);
    path.lineTo(size.width , 0);

    /// [Top Left corner]
    var secondControlPoint =  Offset(0  ,0);
    var secondEndPoint = Offset(width * .2  , height *.3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);



    /// [Left Middle]
    var fifthControlPoint =  Offset(width * .3  ,height * .5);
    var fiftEndPoint = Offset(  width * .23, height *.6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy, fiftEndPoint.dx, fiftEndPoint.dy);


    /// [Bottom Left corner]
    var thirdControlPoint =  Offset(0  ,height);
    var thirdEndPoint = Offset(width , height  );
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy, thirdEndPoint.dx, thirdEndPoint.dy);



    path.lineTo(0, size.height  );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }


}


class BezierContainer extends StatelessWidget {
  const BezierContainer({Key ?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
          angle: -pi / 3.5,
          child: ClipPath(
            clipper: ClipPainter(),
            child: Container(
              height: MediaQuery.of(context).size.height *.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfffc6a8a), Color(0xffd80031)]
                  )
              ),
            ),
          ),
        )
    );
  }
}