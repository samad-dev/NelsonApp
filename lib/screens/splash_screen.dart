import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish/screens/Login.dart';

import '../Database/DatabaseHelper.dart';
import '../main.dart';
import '../models/users.dart';
// import '../widgets/exit_alert_dialog.dart';
import 'package:http/http.dart' as http;

import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  getUser() async {
    var request = http.Request(
        'GET', Uri.parse('https://p2ptrack.com/nelson_paints_p2/api/get/users.php'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      var token = json.decode(data);
      await DatabaseHelper.instance.deleteUsers();
      for (var i = 0; i < token.length; i++) {
        print(token[i]['name']);
        await DatabaseHelper.instance.addUsers(Users(
            id: token[i]['id'],
            name: token[i]['name'],
            privilege: token[i]['privilege'],
            login: token[i]['login'],
            password: token[i]['password'],
            status: token[i]['status'],
            description: token[i]['description'],
            address: token[i]['address'],
            telephone: token[i]['telephone'],
            email: token[i]['email'],
            duty_in: token[i]['duty_in'],
            duty_out: token[i]['duty_out'],
            // odo: token[i]['odo'],
            interval: token[i]['interval'],
            fieldAgent: token[i]['field_agent'],
            routeId: token[i]['route_id']));
      }
      ;
    } else {
      print(response.reasonPhrase);
    }
  }
  @override
  void initState() {
    super.initState();

    // getUser();
    Timer(const Duration(seconds: 7), () async {
      try {
        if (await Permission.locationAlways.serviceStatus.isEnabled)
        {
          var status = await Permission.locationAlways.status;
          if (status.isGranted) {
          }
          else if (status.isDenied){
            Map<Permission, PermissionStatus> status = await [
              Permission.locationAlways,
            ].request();

          }
          if (await Permission.locationAlways.isPermanentlyDenied)
            openAppSettings();

          // Location permission is granted [
          // Location permission is not granted

          // permission is enabled
        }
        else
        {
          var status = await Permission.locationAlways.status;
          if (status.isGranted) {
          }
          else if (status.isDenied){
            Map<Permission, PermissionStatus> status = await [
              Permission.locationAlways,
            ].request();

          }
          if (await Permission.locationAlways.isPermanentlyDenied)
            openAppSettings();

        }
// Obtain shared preferences.
        final prefs = await SharedPreferences.getInstance();
        // await Provider.of<ContentProvider>(context, listen: false).getContentByPosition();
        String? id = await prefs.getString('id');
        print(id);
        if(id != null)
          {
            print('Herer');
            await initializeService();
            final service = FlutterBackgroundService();
            service.startService();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen({})));
          }
        else {

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
          // navigationService.navigateTo(loginScreenRoute);
        }
      } catch (err) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future<bool> _onBackPressed() {
    //   return showDialog(
    //         context: context,
    //         builder: (context) => ExitAlertDialog(),
    //       ) ??
    //       false;
    // }

    return WillPopScope(
      onWillPop: null,
      child: Stack(
          // fit: StackFit.expand,
          children: <Widget>[
            // Container(
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage('assets/images/01a-Splash.jpg'),
            //         fit: BoxFit.cover),0
            //   ),
            // ),
            Positioned(
                child: Align(
              alignment: FractionalOffset.center,
              child: Image.asset(
                'assets/images/splash_1.jpeg',
                scale: 2,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            )),
          ]),
    );
  }
}
