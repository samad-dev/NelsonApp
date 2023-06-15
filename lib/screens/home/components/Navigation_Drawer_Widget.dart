import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stylish/models/User_Routes.dart';
import 'package:stylish/screens/Forms/formpage.dart';
import 'package:stylish/screens/Login.dart';
import 'package:stylish/screens/details/billing_adress_screen.dart';
import 'package:http/http.dart' as http;
import 'package:stylish/screens/details/details_screen.dart';

import '../../../Database/DatabaseHelper.dart';
import '../../../Database/Product.dart';
import '../../../main.dart';
import '../../../models/Route_Name.dart';
import '../../../models/Variations.dart';
import '../../../models/address.dart';
import '../../../models/categories.dart';
import '../../../models/users.dart';
import '../../details/Cat.dart';

class NavigationDrawerWidget extends StatefulWidget {
  NavigationDrawerWidget({Key? key}) : super(key: key);
  // final Map<String, CartItem> items;

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidget();
}

class _NavigationDrawerWidget extends State<NavigationDrawerWidget> {
  bool value = true;
  int numOfOrders = 0;
  var name = 'Nelson', email = 'Nelson Paints';
  final padding = EdgeInsets.symmetric(horizontal: 20);
  saveSwitchData(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('switch', val);
    return val;
  }

  getOrderCount() async {
    var db = await DatabaseHelper.instance.db;
    var result = await db!.rawQuery('SELECT COUNT(*) FROM orders');
    numOfOrders = Sqflite.firstIntValue(result)!;
  }

  session() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // name = prefs.getString('username')!;
    // email = prefs.getString('email')!;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    session();
    getOrderCount().then((value) {
      setState(() {
        print(numOfOrders.toString() + 'CHECKORDER');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final urlImage = "assets/images/logo_n.png";

    return Drawer(
      child: Material(
        color: Color(0xfffd80031),
        child: ListView(
          children: <Widget>[
            buildHeader(
                urlImage: urlImage,
                name: name,
                email: email,
                onClicked: () => {}),
            Divider(color: Colors.white70),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // buildSearchField(),
                  // const SizedBox(height: 24),
                 /* buildMenuItem(
                    text: 'Get Data',
                    icon: Icons.data_saver_on,
                    onClicked: () => selectedItem(context, 0),
                  ),*/
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Add Address',
                    icon: Icons.location_history,
                    onClicked: () => selectedItem(context, 1),
                  ),
                 
                 /* const SizedBox(height: 16),

                  buildMenuItem2(
                    text: 'Start Service',
                    icon: Icons.home_repair_service_rounded,
                    onClicked: () => selectedItem(context, 1),
                  ),*/
                  const SizedBox(height: 16),
                  buildMenuItem3(
                    text: 'Upload Orders',
                    icon: Icons.upload_file_rounded,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Order Page',
                    icon: Icons.shopping_cart,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Get Form',
                    icon: Icons.location_history,
                    onClicked: () => selectedItem(context, 5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromRGBO(255, 229, 228,255),
                  backgroundImage: AssetImage(urlImage,)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),

              // CircleAvatar(
              //   radius: 24,
              //   backgroundColor: Color.fromRGBO(30, 60, 168, 1),
              //   child: Icon(Icons.add_comment_outlined, color: Colors.white),
              // )
            ],
          ),
        ),
      );

  Widget buildSearchField() {
    final color = Colors.white;

    return TextField(
      style: TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Widget buildMenuItem2({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      trailing: Switch(
        value: value,
        onChanged: (val) async {
          setState(() {
            value = val;
          });
          final service = FlutterBackgroundService();
          var isRunning = await service.isRunning();
          if (!isRunning) {
            setState(() {
              value = true;
            });
            service.startService();
          } else {
            setState(() {
              value = false;
            });

            service.invoke("stopService");
          }
          saveSwitchData(value);
        },
        activeTrackColor: Color(0xffffffff),
        activeColor: Color(0xff0205a1),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Widget buildMenuItem3({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      trailing: Text(
        numOfOrders.toString(),
        style:  TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
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
        Uri.parse('https://p2ptrack.com/nelson_paints_p2/api/get/address.php'));
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
        Uri.parse('https://p2ptrack.com/nelson_paints_p2/api/get/users.php'));
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
            interval: token[i]['interval'],
            duty_out: token[i]['duty_out'],

            fieldAgent: token[i]['field_agent'],
            routeId: token[i]['route_id']));
      }
      Fluttertoast.showToast(msg: 'Getting Users');
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
            'https://p2ptrack.com/nelson_paints_p2/api/get/get_all_categories.php'));
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
            'https://p2ptrack.com/nelson_paints_p2/api/get/variations.php'));
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
          price: tokenVariations[a]['price'],
          price2: tokenVariations[a]['price2'],
          price3: tokenVariations[a]['price3'],
          price4: tokenVariations[a]['price4'],
          price5: tokenVariations[a]['price5'],
          price6: tokenVariations[a]['price6'],
          price7: tokenVariations[a]['price7'],
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
            'https://p2ptrack.com/nelson_paints_p2/api/get/user_routes.php'));
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

    var VarRequest = http.Request(
        'GET',
        Uri.parse(
            'https://p2ptrack.com/nelson_paints_p2/api/get/routes.php'));
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
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://p2ptrack.com/nelson_paints_p2/api/get/products.php'));
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

  Future<void> selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        print('Samad');
        getForm();
        getAddress();
        getCategories();
        getp();
        getVariations();
        getUserRoutes();
        getRoutes();

        Fluttertoast.showToast(msg: 'All Data Import Completed');

        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BillingAddressScreen(),
        ));
        break;

      case 4:
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('id');
        await prefs.remove('email');
        await prefs.remove('username');
        final service = FlutterBackgroundService();
        service.invoke("stopService");
        // googleAccount = await _googleSignIn.signOut();
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => LoginPage(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => FavouritesPage(),
        // ));
        break;

    }
  }
}
