import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:geocoding/geocoding.dart' as GeoCoding;
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish/constants.dart';
import 'package:stylish/model/inputFormModel.dart';
import 'package:stylish/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:stylish/screens/splash_screen.dart';

import 'Database/DatabaseHelper.dart';
import 'Database/Product.dart';
import 'model/OPFormModel.dart';
import 'models/Orders.dart';
import 'models/RecordLocationBody.dart';
import 'models/Route_Name.dart';
import 'models/TrackingServiceModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'models/User_Routes.dart';
import 'models/Variations.dart';
import 'models/address.dart';
import 'models/categories.dart';
import 'models/users.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();
  bool firstRun = await IsFirstRun.isFirstRun();
  if (firstRun) {
    getForm();
    getUser();
    getAddress();
    getCategories();
    getp();
    getVariations();
    getUserRoutes();
    getRoutes();
  }
  runApp(const MyApp());
}

getAddress() async {
  // showDialog(
  //     // The user CANNOT close this dialog  by pressing outsite it
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (_) {
  //       return Dialog(
  //         // The background color
  //         backgroundColor: Colors.white,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: const [
  //               // The loading indicator
  //               CircularProgressIndicator(),
  //               SizedBox(
  //                 height: 15,
  //               ),
  //               // Some text
  //               Text('Getting Addresses')
  //             ],
  //           ),
  //         ),
  //       );
  //     });
  var request = http.Request('GET',
      Uri.parse('http://202.141.255.102:2528/nelson-paints-web/api/get/address.php'));
  request.body = '''''';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? user_id = prefs.getString('id');
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String data = await response.stream.bytesToString();
    var token = json.decode(data);
    await DatabaseHelper.instance.deleteAddress();
    for (var i = 0; i < token.length; i++) {
      print(token[i]['first_name'].toString());

      await DatabaseHelper.instance.addAddress(Address(
        id: token[i]['id'],
        user_id: token[i]['user_id'],
        first_name: token[i]['first_name'],
        last_name: token[i]['last_name'],
        address_a: token[i]['address_a'],
        address_b: token[i]['address_b'],
        state: token[i]['state'],
        city: token[i]['city'],
        post_code: token[i]['post_code'],
        country: token[i]['country'],
        email: token[i]['email'],
        phone: token[i]['phone'],
        created_by: token[i]['created_by'],
        status: 1.toString(),
      ));
    }
    Fluttertoast.showToast(msg: 'Getting Addresses');
  } else {
    Fluttertoast.showToast(msg: 'Check Your Internet Connection');
    print(response.reasonPhrase);
  }
}

getUser() async {
  // showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (_) {
  //       return Dialog(
  //         // The background color
  //         backgroundColor: Colors.white,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: const [
  //               // The loading indicator
  //               CircularProgressIndicator(),
  //               SizedBox(
  //                 height: 15,
  //               ),
  //               // Some text
  //               Text('Getting User')
  //             ],
  //           ),
  //         ),
  //       );
  //     });
  var request = http.Request('GET',
      Uri.parse('http://202.141.255.102:2528/nelson-paints-web/api/get/users.php'));
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
          fieldAgent: token[i]['field_agent'],
          routeId: token[i]['route_id'],
          interval: token[i]['interval']));
    }
    Fluttertoast.showToast(msg: 'Getting Users');
  } else {
    Fluttertoast.showToast(msg: 'Check Your Internet Connection');
    print(response.reasonPhrase);
  }
}

getForm() async {
  print(
      'http://202.141.255.102:2528/nelson-paints-web/SimplePhpFormBuilder-1.6.0/api/allform.php');
  var request = http.Request(
      'GET',
      Uri.parse(
          'http://202.141.255.102:2528/nelson-paints-web/SimplePhpFormBuilder-1.6.0/api/allform.php'));
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String data = await response.stream.bytesToString();
    var token = json.decode(data);
    print(data);
    await DatabaseHelper.instance.delDb();
    for (var i = 0; i < token.length; i++) {
      print(token[i]['name']);
      await DatabaseHelper.instance.addForms(InputForms(
          formName: token[i]['form_name'],
          formId: token[i]['form_id'],
          apiResp: token[i]['data']));
    }
    Fluttertoast.showToast(msg: 'Getting Forms');
  } else {
    Fluttertoast.showToast(msg: 'Check Your Internet Connection');
    print(response.reasonPhrase);
  }
}

getCategories() async {
  // showDialog(
  //     // The user CANNOT close this dialog  by pressing outsite it
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (_) {
  //       return Dialog(
  //         // The background color
  //         backgroundColor: Colors.white,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: const [
  //               // The loading indicator
  //               CircularProgressIndicator(),
  //               SizedBox(
  //                 height: 15,
  //               ),
  //               // Some text
  //               Text('Getting Categories')
  //             ],
  //           ),
  //         ),
  //       );
  //     });
  var request = http.Request(
      'GET',
      Uri.parse(
          'http://202.141.255.102:2528/nelson-paints-web/api/get/get_all_categories.php'));
  request.body = '''''';

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String data = await response.stream.bytesToString();
    var token = json.decode(data);
    await DatabaseHelper.instance.deleteCat();
    for (var i = 0; i < token.length; i++) {
      print(token[i]['category_name'].toString());

      await DatabaseHelper.instance.addCategories(Categories(
          id: token[i]['id'], category_name: token[i]['category_name']));
    }
    Fluttertoast.showToast(msg: 'Getting Categories');
  } else {
    Fluttertoast.showToast(msg: 'Check Your Internet Connection');

    print(response.reasonPhrase);
  }
}

getVariations() async {
  // showDialog(
  //     // The user CANNOT close this dialog  by pressing outsite it
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (_) {
  //       return Dialog(
  //         // The background color
  //         backgroundColor: Colors.white,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: const [
  //               // The loading indicator
  //               CircularProgressIndicator(),
  //               SizedBox(
  //                 height: 15,
  //               ),
  //               // Some text
  //               Text('Getting Variations')
  //             ],
  //           ),
  //         ),
  //       );
  //     });
  var VarRequest = http.Request(
      'GET',
      Uri.parse(
          'http://202.141.255.102:2528/nelson-paints-web/api/get/variations.php?id=1'));
  http.StreamedResponse VarResponse = await VarRequest.send();

  if (VarResponse.statusCode == 200) {
    DatabaseHelper.instance.deletevariation();
    String data = await VarResponse.stream.bytesToString();
    print(data);
    List tokenVariations = json.decode(data);
    print("Samad" + tokenVariations.length.toString());
    int a = 0;
    while (a < tokenVariations.length) {
      print(tokenVariations[a]['variation_name']);
      await DatabaseHelper.instance.addVaria(Variations(
        id: tokenVariations[a]['id'],
        productId: tokenVariations[a]['product_id'],
        variationId: tokenVariations[a]['variation_id'],
        name: tokenVariations[a]['name'],
        variationName: tokenVariations[a]['variation_name'],
        size: tokenVariations[a]['size'],
        color_id: tokenVariations[a]['color_id'],
        colors: tokenVariations[a]['colors'],
        price: double.parse(tokenVariations[a]['price']).toStringAsFixed(0).toString(),
        price2: double.parse(tokenVariations[a]['price2']).toStringAsFixed(0).toString(),
        price3: double.parse(tokenVariations[a]['price3']).toStringAsFixed(0).toString(),
        price4: double.parse(tokenVariations[a]['price4']).toStringAsFixed(0).toString(),
        price5: double.parse(tokenVariations[a]['price5']).toStringAsFixed(0).toString(),
        price6: double.parse(tokenVariations[a]['price6']).toStringAsFixed(0).toString(),
        price7: double.parse(tokenVariations[a]['price7']).toStringAsFixed(0).toString(),
      ));
      a++;
    }
    Fluttertoast.showToast(msg: 'Getting Variations');
  } else {
    Fluttertoast.showToast(msg: 'Check Your Internet Connection');

    print(VarResponse.reasonPhrase);
  }
}

getUserRoutes() async {
  var VarRequest = http.Request(
      'GET',
      Uri.parse(
          'http://202.141.255.102:2528/nelson-paints-web/api/get/user_routes.php?id=1'));
  http.StreamedResponse VarResponse = await VarRequest.send();

  if (VarResponse.statusCode == 200) {
    DatabaseHelper.instance.deleteroutes();
    String data = await VarResponse.stream.bytesToString();
    print(data);
    List tokenVariations = json.decode(data);
    print("Samad" + tokenVariations.length.toString());
    int a = 0;
    while (a < tokenVariations.length) {
      print(tokenVariations[a]['user_id']);
      await DatabaseHelper.instance.addRout(User_Routes(
          id: tokenVariations[a]['id'],
          user_id: tokenVariations[a]['user_id'],
          route_id: tokenVariations[a]['route_id']));
      a++;
    }
    Fluttertoast.showToast(msg: 'Getting User Routes');
  } else {
    Fluttertoast.showToast(msg: 'Check Your Internet Connection');

    print(VarResponse.reasonPhrase);
  }
}

getRoutes() async {
  var VarRequest = http.Request('GET',
      Uri.parse('http://202.141.255.102:2528/nelson-paints-web/api/get/routes.php?id=1'));
  http.StreamedResponse VarResponse = await VarRequest.send();

  if (VarResponse.statusCode == 200) {
    DatabaseHelper.instance.deleteRoute();
    String data = await VarResponse.stream.bytesToString();
    print(data);
    List tokenVariations = json.decode(data);
    print("Samad" + tokenVariations.length.toString());
    int a = 0;
    while (a < tokenVariations.length) {
      // print(tokenVariations[a]['user_id']);
      await DatabaseHelper.instance.addRoutes(Routes(
          id: tokenVariations[a]['id'],
          route_name: tokenVariations[a]['route_name']));
      a++;
    }
    Fluttertoast.showToast(msg: 'Getting User Routes');
  } else {
    Fluttertoast.showToast(msg: 'Check Your Internet Connection');

    print(VarResponse.reasonPhrase);
  }
}

getp() async {
  // showDialog(
  //     // The user CANNOT close this dialog  by pressing outsite it
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (_) {
  //       return Dialog(
  //         // The background color
  //         backgroundColor: Colors.white,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: const [
  //               // The loading indicator
  //               CircularProgressIndicator(),
  //               SizedBox(
  //                 height: 15,
  //               ),
  //               // Some text
  //               Text('Getting Products')
  //             ],
  //           ),
  //         ),
  //       );
  //     });
  var request = http.Request('GET',
      Uri.parse('http://202.141.255.102:2528/nelson-paints-web/api/get/products.php'));
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String data = await response.stream.bytesToString();
    var token = jsonDecode(data);
    await DatabaseHelper.instance.delete();
    for (var i = 0; i < token.length; i++) {
      String myStringEncode(String content) =>
          "'${content.replaceAllMapped(RegExp(r"\[\'\]"), (m) => "\\${m[0]}")}'";
      var string3 =
          [for (var s in token[i]['colors']) myStringEncode(s)].toString();
      var string4 =
          [for (var s in token[i]['size']) myStringEncode(s)].toString();

      await DatabaseHelper.instance.addProducts(Product1(
          id: int.parse(token[i]['id']),
          images: "assets/images/ps4_console_white_1.png",
          colors: string3,
          category_id: token[i]['category_id'].toString(),
          title: token[i]['name'],
          rating: 0.0,
          sizes: string4,
          price: double.parse(token[i]['price']),
          description: token[i]['description']));
    }
    Fluttertoast.showToast(msg: 'Getting Products');

    //===================
  } else {
    Fluttertoast.showToast(msg: 'Check Your Internet Connection');

    print(response.reasonPhrase);
  }
}

bool value = false;
GeolocatorPlatform locator = GeolocatorPlatform.instance;

/// Stream that emits values when velocity updates
late StreamController<double?> _velocityUpdatedStreamController;
double? _velocity = 0;
double odo = 0;

/// Highest recorded velocity so far in m/s.
double? _highestVelocity;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

double? convertedVelocity(double? velocity) {
  velocity = velocity ?? _velocity;

  return mpstokmph(velocity!);
}

double mpstokmph(double mps) => mps * 18 / 5;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int interval = int.parse(prefs.getString('interval').toString());
  print(interval);
  Timer.periodic(Duration(seconds: interval), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "My App Service",
        content: "Updated at ${DateTime.now()}",
      );
    }

    postData();
    String? device;
    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

postData() {
  recordLocation();

  checkOutForSwitch();
  PostFormData();
  postAddresses();
}

postAddresses() async {
  List<Address> addressList = await DatabaseHelper.instance.getAddress1();
  if (addressList.length > 0) {
    for (int a = 0; a < addressList.length; a++) {
      var addressHeaders = {'Cookie': 'PHPSESSID=hqeulp9ob4jvb1bcfjk7orgiav'};
      var addressRequest = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://202.141.255.102:2528/nelson-paints-web/api/get/create_address.php'));
      addressRequest.fields.addAll({
        'user_id': addressList[a].user_id,
        'first_name': addressList[a].first_name,
        'last_name': addressList[a].last_name,
        'email': addressList[a].email,
        'phone': addressList[a].phone,
        'state': addressList[a].state,
        'country': addressList[a].country,
        'city': addressList[a].city,
        'postcode': addressList[a].post_code,
        'address_a': addressList[a].address_a,
        'address_b': addressList[a].address_b,
        'created_by': addressList[a].user_id
      });
      addressRequest.headers.addAll(addressHeaders);
      http.StreamedResponse addressResponse = await addressRequest.send();

      if (addressResponse.statusCode == 200) {
        print(await addressResponse.stream.bytesToString() + "ADDRESSES");
      } else {
        print(addressResponse.reasonPhrase);
      }
    }
  }
  // Fluttertoast.showToast(msg: 'ADDRESSES POSTED');
  DatabaseHelper.instance.postAddress();
}

checkOutForSwitch() async {
  List<Orders> orderlist = await DatabaseHelper.instance.getOrders();
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      if (orderlist.length > 0) {
        for (int a = 0; a < orderlist.length; a++) {
          var headers = {'Cookie': 'PHPSESSID=dc3mbv1d5cf1nt9h0atlungtn5'};
          var request = http.MultipartRequest(
              'POST',
              Uri.parse(
                  'http://202.141.255.102:2528/nelson-paints-web/api/get/get_order.php'));
          request.fields.addAll({
            'category_id': orderlist[a].category_id,
            'order_date': orderlist[a].order_date,
            'total': orderlist[a].total,
            'address_id': orderlist[a].address_id,
            'payment_method': orderlist[a].payment_method,
            'payment_method_title': orderlist[a].payment_method_title,
            'order_items': orderlist[a].order_items,
            'created_by': orderlist[a].created_by
          });
          request.headers.addAll(headers);
          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            Fluttertoast.showToast(msg: 'ORDERS PLACED');
            print(response.statusCode.toString());
          } else {
            print(response.reasonPhrase);
          }
        }
        print("Count" + orderlist.length.toString());
        DatabaseHelper.instance.deleteOrders();
      }
    } else {
      Fluttertoast.showToast(
          msg: "Oh, Looks like you're not connected to the internet",
          backgroundColor: Colors.red);
    }
  } on SocketException catch (_) {
    Fluttertoast.showToast(
        msg: "Oh, Looks like you're not connected to the internet",
        backgroundColor: Colors.red);
  }
}

PostFormData() async {
  List<OutputForms> orderlist = await DatabaseHelper.instance.getOPForms();
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      if (orderlist.length > 0) {
        for (int a = 0; a < orderlist.length; a++) {
          var request = http.Request(
              'GET',
              Uri.parse(
                  'http://202.141.255.102:2528/nelson-paints-web/SimplePhpFormBuilder-1.6.0/'
                      'api/'
                      'save_data.php?form_id=${orderlist[a].formId}&form_name=${orderlist[a].formname}&data=${orderlist[a].dataOutput}&created_by=1'));

          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            print(response.statusCode.toString());
            Fluttertoast.showToast(msg: 'FORMS DATA UPLOADED');
          } else {
            print(response.reasonPhrase);
          }
        }
        print("Count" + orderlist.length.toString());
        DatabaseHelper.instance.delFormData();
      }
    } else {
      Fluttertoast.showToast(
          msg: "Oh, Looks like you're not connected to the internet",
          backgroundColor: Colors.red);
    }
  } on SocketException catch (_) {
    Fluttertoast.showToast(
        msg: "Oh, Looks like you're not connected to the internet",
        backgroundColor: Colors.red);
  }
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

Future<Map<Permission, PermissionStatus>> permissionServices() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.locationAlways,
  ].request();

  if (statuses[Permission.locationAlways]!.isPermanentlyDenied) {
    await openAppSettings().then(
      (value) async {
        if (value) {
          if (await Permission.locationAlways.status.isPermanentlyDenied ==
                  true &&
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

Future<Position> _getGeoLocationPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    openAppSettings().then(
      (value) async {
        if (value) {
          if (await Permission.locationAlways.status.isPermanentlyDenied ==
                  true &&
              await Permission.locationAlways.status.isGranted == false) {
            // openAppSettings();
            permissionServiceCall(); /* opens app settings until permission is granted */
          }
        }
      },
    );
    /*if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          Exception('Location permissions are permanently denied.'));
    }*/

    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error(Exception('Location permissions are denied.'));
    }
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<void> recordLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? user_id = prefs.getString('id');
  locator
      .getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      )
      .listen(
        (Position position) => {
          locator.getCurrentPosition().then(
            (Position updatedPosition) {
              _velocity = (position.speed + updatedPosition.speed) / 2;

              final startCoordinate =
                  new Location(position.latitude, position.longitude);
              final endCoordinate = new Location(
                  updatedPosition.latitude, updatedPosition.longitude);

              /// Create a new haversine object
              final haversineDistance = HaversineDistance();

              /// Then calculate the distance between the two location objects and set a unit.
              /// You can select between KM/MILES/METERS/NMI
              odo += haversineDistance.haversine(
                  startCoordinate, endCoordinate, Unit.METER);
              print("Odo____" + odo.toString());
            },
          ),
        },
      );

  String datetime = DateTime.now().toString();
  print(convertedVelocity(_velocity)!.toStringAsFixed(2));
  print('--------------Adding location' + user_id!.toString());
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
  Position position = await _getGeoLocationPosition();

  var _battery = Battery();
  String _address;
  try {
    List<GeoCoding.Placemark> _addresses =
        await GeoCoding.placemarkFromCoordinates(
            position.latitude, position.longitude);
    GeoCoding.Placemark _placeMark = _addresses.first;
    _address =
        '${_placeMark.name}, ${_placeMark.subLocality}, ${_placeMark.street}, ${_placeMark.subAdministrativeArea}, ${_placeMark.isoCountryCode}';
  } catch (e) {
    _address = 'Unknown Location Found';
  }
  print(
      'This is current Location: Latitude: ${position.latitude} Longitude: ${position.longitude} Address: ${_address}');

  RecordLocationBody _recordLocation = RecordLocationBody(
      token: user_id.toString(),
      location: _address,
      latitude: position.latitude,
      longitude: position.longitude,
      speed: double.parse(convertedVelocity(_velocity)!.toStringAsFixed(2)),
      datetime: datetime);
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      var bb = await _battery.batteryLevel.toString();
      print(build.version.sdkInt);
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://202.141.255.102:2528/nelson-paints-web/api/get/create_position.php'));
      request.fields.addAll({
        'user_id': _recordLocation.token.toString(),
        'lat': _recordLocation.latitude.toString(),
        'lng': _recordLocation.longitude.toString(),
        'speed': convertedVelocity(_velocity)!.toStringAsFixed(2),
        'location_name': _address,
        'created_at': _recordLocation.datetime.toString(),
        'created_by': user_id,
        'battery': bb.toString(),
      });
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
      DatabaseHelper.instance.getTrackingCount();
      print('--------------All Data Inserted');
      var db = await DatabaseHelper.instance.db;
      var data = await db!.query(
        'trackingService',
      );
      List<Map<String, dynamic>> maps = data;
      if (maps.length > 0) {
        print("maps ${maps.length}");
        for (int i = 0; i < maps.length; i++) {
          print(maps[i]);

          var loopRequest = http.MultipartRequest(
              'POST',
              Uri.parse(
                  'http://202.141.255.102:2528/nelson-paints-web/api/get/create_position.php'));
          loopRequest.fields.addAll({
            'user_id': maps[i]['token'].toString(),
            'lat': maps[i]['latitude'].toString(),
            'lng': maps[i]['longitude'].toString(),
            'speed': maps[i]['speed'].toString(),
            'location_name': maps[i]['location'].toString(),
            'created_at': maps[i]['datetime'].toString(),
            'battery': maps[i]['battery'].toString(),
            'created_by': maps[i]['token'].toString(),
          });
          http.StreamedResponse loopResponse = await loopRequest.send();
          if (loopResponse.statusCode == 200) {
            print(await loopResponse.stream.bytesToString());
            DatabaseHelper.instance.deleteOneLocation(maps[i]['id'].toString());
          } else {
            print(loopResponse.reasonPhrase);
          }
          print("Offline Data" + "    " + loopResponse.statusCode.toString());
        }
      }
    }
  } on SocketException catch (_) {
    print('not connected ${_recordLocation.location}');
    DatabaseHelper.instance.addOfflineTrackingData(TrackingService(
      token: user_id.toString(),
      latitude: position.latitude,
      longitude: position.longitude,
      location: _address,
      speed: _velocity.toString(),
      angle: '45',
      odo: odo.toString(),
      datetime: datetime,
      battery: await _battery.batteryLevel,
    ));
    print('--------------Failed record' + _battery.batteryLevel.toString());
    print('user id' + user_id.toString());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    _requestLocation();
    permissionServiceCall();
  }

  String _result = 'N/A';

  void _requestLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      setState(() => _result = 'Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      openAppSettings().then(
        (value) async {
          if (value) {
            if (await Permission.locationAlways.status.isPermanentlyDenied ==
                    true &&
                await Permission.locationAlways.status.isGranted == false) {
              // openAppSettings();
              permissionServiceCall(); /* opens app settings until permission is granted */
            }
          }
        },
      );
      // permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.denied) {
      //   setState(() => _result = 'Location permissions are denied');
      //   return;
      // }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _result = 'Location permissions are permanently denied.');
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() => _result = position.toString());
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
            if (await Permission.locationAlways.status.isPermanentlyDenied ==
                    true &&
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Flutter Way',
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        primarySwatch: Colors.blue,
        fontFamily: "Gordita",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
