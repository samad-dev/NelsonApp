import 'dart:math';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Database/DatabaseHelper.dart';
import '../../models/address.dart';

class BillingAddressScreen extends StatefulWidget {
  const BillingAddressScreen({Key? key}) : super(key: key);

  @override
  State<BillingAddressScreen> createState() => _BillingAddressScreenState();
}

class _BillingAddressScreenState extends State<BillingAddressScreen> {
  TextEditingController address_1c = TextEditingController();
  TextEditingController address_2c = TextEditingController();
  TextEditingController first_namec = TextEditingController();
  TextEditingController last_namec = TextEditingController();
  TextEditingController emailc = TextEditingController();
  TextEditingController phonec = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  TextEditingController statec = TextEditingController();
  TextEditingController cityc = TextEditingController();
  TextEditingController postal = TextEditingController();
  TextEditingController country1 = TextEditingController();
  TextEditingController state1 = TextEditingController();
  TextEditingController city1 = TextEditingController();
  bool isLoading = true;
  var first_name = "Abdul Samad",
      id,
      last_name = "Abdul Qadir",
      address1 = "",
      address_2 = "",
      city = "Karachi",
      state = "Sindh",
      country = "",
      email = "abdulsamadq67@gmail.com",
      phone = "03323490754",
      post;
  var bank;

  Future<void> update1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('id');
    String? route_id = prefs.getString('route_id');
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
    var rng = Random();

    int res = await DatabaseHelper.instance.addAddress(Address(
        id: rng.nextInt(100).toString(),
        user_id: route_id.toString(),
        first_name: first_namec.text.toString(),
        last_name: last_namec.text.toString(),
        address_a: address_1c.text.toString(),
        address_b: address_2c.text.toString(),
        state: state1.text.toString(),
        city: city1.text.toString(),
        post_code: postal.text.toString(),
        country: country1.text.toString(),
        email: emailc.text.toString(),
        phone: phonec.text.toString(),
        created_by: user_id.toString(),
        status: 0.toString()));
    print(res);
    Fluttertoast.showToast(msg: 'Address Added Successfully');
    address_1c.text = "";
    address_2c.text = "";
    emailc.text = "";
    first_namec.text = "";
    last_namec.text = "";
    phonec.text = "";
    postal.text = "";
    state1.text = "";
    city1.text = "";
    Navigator.of(context).pop();
  }

  @override
  void initState() {}

  @override
  void didPop() {
    print('HomePage: Called didPop');
  }

  @override
  void didPopNext() {
    print('HomePage: Called didPopNext');
  }

  late String countryValue;
  late String stateValue;
  late String cityValue;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Billing Address",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                "assets/icons/Heart.svg",
                height: 20,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: width * 0.05, right: width * 0.05, top: height * 0.01),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Billing Address",
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.035,
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(
              width: width,
              height: height * 0.063,
              child: TextField(
                controller: first_namec,
                keyboardType: TextInputType.name,
                // textAlign: TextAlign.center,
                cursorColor: Colors.orange,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.035,
                    height: 2,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.035),
                    // contentPadding: EdgeInsets.all(width * 0.04),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.035,
                    ),
                    hintText: "First Name",
                    fillColor: Colors.grey.shade100),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(
              width: width,
              height: height * 0.063,
              child: TextField(
                controller: last_namec,
                keyboardType: TextInputType.name,
                // textAlign: TextAlign.center,
                cursorColor: Colors.orange,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.035,
                    height: 2,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.035),
                    // contentPadding: EdgeInsets.all(width * 0.04),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.035,
                    ),
                    hintText: "Last Name",
                    fillColor: Colors.grey.shade100),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(
              width: width,
              height: height * 0.063,
              child: TextField(
                controller: emailc,
                keyboardType: TextInputType.name,
                // textAlign: TextAlign.center,
                cursorColor: Colors.orange,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.035,
                    height: 2,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.035),
                    // contentPadding: EdgeInsets.all(width * 0.04),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.035,
                    ),
                    hintText: "Email",
                    fillColor: Colors.grey.shade100),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(
              width: width,
              height: height * 0.063,
              child: TextField(
                controller: phonec,
                keyboardType: TextInputType.name,
                // textAlign: TextAlign.center,
                cursorColor: Colors.orange,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.035,
                    height: 2,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.035),
                    // contentPadding: EdgeInsets.all(width * 0.04),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.035,
                    ),
                    hintText: "Phone",
                    fillColor: Colors.grey.shade100),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            SizedBox(
              width: width,
              height: height * 0.063,
              child: TextField(
                controller: address_1c,
                keyboardType: TextInputType.name,
                // textAlign: TextAlign.center,
                cursorColor: Colors.orange,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.035,
                    height: 2,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.035),
                    // contentPadding: EdgeInsets.all(width * 0.04),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.035,
                    ),
                    hintText: "Address Line 1 ..",
                    fillColor: Colors.grey.shade100),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(
              width: width,
              height: height * 0.063,
              child: TextField(
                controller: address_2c,
                keyboardType: TextInputType.name,
                // textAlign: TextAlign.center,
                cursorColor: Colors.orange,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.035,
                    height: 2,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.035),
                    // contentPadding: EdgeInsets.all(width * 0.04),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.035,
                    ),
                    hintText: "Address Line 2 ..",
                    fillColor: Colors.grey.shade100),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              "Country",
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.035,
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(
              width: width,
              child: CountryStateCityPicker(
                country: country1,
                state: state1,
                city: city1,
                textFieldInputBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(width * 0.025),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Text(
              "Zip/Postal code",
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.035,
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(
              width: width,
              height: height * 0.063,
              child: TextField(
                controller: postal,
                keyboardType: TextInputType.text,
                // textAlign: TextAlign.center,
                cursorColor: Colors.orange,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.035,
                    height: 2,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    // isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.035),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.035,
                    ),
                    hintText: "75500",
                    fillColor: Colors.grey.shade100),
              ),
            ),
            SizedBox(height: height * 0.03,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    // width: 5.0,
                    color: Colors.orange,
                  ),
                  minimumSize: Size.fromHeight(
                      MediaQuery.of(context).size.height * 0.052),
                  primary: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10 ?? MediaQuery.of(context).size.width * 0.02),
                  ),
                ),
                onPressed: () {
                  update1();
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.022,
                      bottom: MediaQuery.of(context).size.height * 0.022),
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                )),
                SizedBox(height: 12,)
          ]),
        ),
      ),
    );
  }
}
