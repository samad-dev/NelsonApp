import 'dart:convert';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/DatabaseHelper.dart';
import '../../Database/group_sadqa_provider.dart';
import '../../constants.dart';
import '../../models/Orders.dart';
import '../../models/Route_Name.dart';
import '../../models/address.dart';
import '../../models/cart.dart';
import '../../models/cart_check.dart';
import 'package:intl/intl.dart';

import '../home/home_screen.dart';

class ViewCartScreen extends StatefulWidget {
  final Map<String, CartItem> items;

  const ViewCartScreen({Key? key, required this.items}) : super(key: key);

  @override
  State<ViewCartScreen> createState() => _ViewCartScreenState(items);
}
class _ViewCartScreenState extends State<ViewCartScreen> {
  final Map<String, CartItem> items;
  late Map<String, CartItem> ca;
  double total = 0.0;
  bool isFirstClick = false;
  bool isSecondClick = false;
  List<TextEditingController>? _controllers = [];
  List<Cart_Check> list = [];
  DropdownEditingController<String> addressVal = DropdownEditingController();
  String addressId = "";
  String route_id= "";
  TextEditingController remarksCont = TextEditingController();

  _ViewCartScreenState(this.items);

  var first_name = "Abdul Samad",
      id,
      last_name = "Abdul Qadir",
      address1 = "Plot L-532",
      address_2 = "",
      postcode,
      city = "Karachi",
      state = "Sindh",
      country = "PK",
      email = "abdulsamadq67@gmail.com",
      phone = "";
  var bank;
  late String addrId;
  String? remarks;
  checkOut() async {
    String json = jsonEncode(list);
    print(json);
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.black26,
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
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('id');
    var data = DatabaseHelper.instance.addOrders(Orders(
        remarks: remarksCont.text.toString(),
        category_id: '2',
        order_date: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        total: total.toString(),
        address_id: addressId,
        payment_method: 'cod',
        payment_method_title: 'Cash On Delivery',
        order_items: json,
        created_by: user_id.toString()));
        print(data);

    /*request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'ORDER PLACED');
      print(response.statusCode.toString());
    } else {
      print(response.reasonPhrase);
    }*/
    Navigator.of(context).pop();
    showGeneralDialog(
        barrierColor:
        Colors.black.withOpacity(0.5),
        transitionBuilder:
            (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  title: Text(
                    "Please Confirm",
                    style: TextStyle(
                      fontWeight:
                      FontWeight.w400,
                      fontSize:
                      12,
                    ),
                  ),
                  actionsAlignment:
                  MainAxisAlignment
                      .spaceAround,
                  content: Text(
                    "You Wants to share order on whatsapp",
                    style: TextStyle(
                      fontWeight:
                      FontWeight.w600,
                      fontSize: MediaQuery.of(
                          context)
                          .size
                          .width *
                          0.03,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty
                                .all(Colors
                                .red)),
                        onPressed: () {

                          print('samad');
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors
                                .white,
                            fontFamily:
                            'Nunito',
                            fontWeight:
                            FontWeight
                                .w600,
                            fontSize: MediaQuery.of(
                                context)
                                .size
                                .width *
                                0.03,
                          ),
                        )),
                    TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty
                                .all(Colors
                                .grey)),
                        onPressed: () =>
                            Navigator.of(
                                context)
                                .pop(false),
                        child: Text(
                          "No",
                          style: TextStyle(
                            color: Colors
                                .white,
                            fontFamily:
                            'Nunito',
                            fontWeight:
                            FontWeight
                                .w600,
                            fontSize: MediaQuery.of(
                                context)
                                .size
                                .width *
                                0.03,
                          ),
                        )),
                  ],
                )),
          );
        },
        transitionDuration: const Duration(
            milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1,
            animation2) {
          return const Text('PAGE BUILDER');
        });
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeScreen({})),
    // );
  }

  Future<List<Address>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Address> response = await DatabaseHelper.instance.getAddress("${prefs.get('id')}");
    print(response);
    return response.toList();
  }


  @override
  void initState() {
    super.initState();
    // profile();
    items.forEach((key, cartItem) {
      // print(i);
      if (list.contains(key)) {
      } else {
        total = total + cartItem.price * cartItem.quantity;
        list.add(Cart_Check(int.parse(cartItem.pid), cartItem.quantity,
            int.parse(cartItem.vid), cartItem.remarks.toString()));
        print(list.length.toString()+"Remark");
      }
    });
    ca = items;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var total = 0.0;
    List<Cart_Check> list = [];
    items.forEach((key, cartItem) {
      list.add(Cart_Check(
          int.parse(cartItem.pid), cartItem.quantity, int.parse(cartItem.vid), cartItem.remarks.toString().toString()));

      total = total + cartItem.price * cartItem.quantity;
    });

    return ChangeNotifierProvider(
      create: (_) => new Cart(),
      child: Consumer<Cart>(builder: (context, cart, child) {
        print(items.length);

            cart.items = ca;

        return SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xffefeeee),
            appBar: AppBar(
              centerTitle: true,
              leading: const BackButton(color: Colors.black),
              title: Text(
                "Cart",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            body: WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeScreen(items)));
                  return false;
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                      top: height * 0.01),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        items.length == 0
                            ? Column(children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Icon(
                            Icons.shopping_cart_checkout_sharp,
                            size: height * 0.3,
                            color: Colors.green,
                          ),
                          Text(
                            "Your cart is empty",
                            style: TextStyle(
                                color: Colors.black12,
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w700),
                          ),
                        ])
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: width * 0.35,
                              child: Text(
                                "Items",
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        items.length > 0
                            ? Container()
                            : SizedBox(
                          height: height * 0.008,
                        ),
                        Container(
                          height: height*.5,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                _controllers!.add(new TextEditingController());
                                return Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0.0, 0, 0, 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(width * 0.025)),
                                            color: Colors.white),
                                        width: width * 0.8,
                                        height: height * 0.13,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${items.values.toList()[index].title.toString()}\nQuantity: ${items.values.toList()[index].quantity.toString()}\nUnit Price: ${items.values.toList()[index].price.toString()}\nSize: ${items.values.toList()[index].size.toString()}",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: width * 0.031,
                                                  ),
                                                ),
                                                Text("${items.values.toList()[index].color.toString()}",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: width * 0.031,
                                                  ),)
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Rs.${items.values.toList()[index].price * items.values.toList()[index].quantity}",
                                                  style: TextStyle(overflow: TextOverflow.ellipsis,
                                                    color: Color.fromRGBO(
                                                        36, 124, 38, 1),
                                                    fontSize: width * 0.03,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showGeneralDialog(
                                              barrierColor:
                                              Colors.black.withOpacity(0.5),
                                              transitionBuilder:
                                                  (context, a1, a2, widget) {
                                                return Transform.scale(
                                                  scale: a1.value,
                                                  child: Opacity(
                                                      opacity: a1.value,
                                                      child: AlertDialog(
                                                        title: Text(
                                                          "Please Confirm",
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            fontSize:
                                                            width * 0.04,
                                                          ),
                                                        ),
                                                        actionsAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                        content: Text(
                                                          "Are you sure you want to delete?",
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .width *
                                                                0.03,
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                      .red)),
                                                              onPressed: () {
                                                                setState(() {
                                                                  items.remove(items
                                                                      .keys
                                                                      .toList()[
                                                                  index]);
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop(false);
                                                                });
                                                                print('samad');
                                                              },
                                                              child: Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                  'Nunito',
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  fontSize: MediaQuery.of(
                                                                      context)
                                                                      .size
                                                                      .width *
                                                                      0.03,
                                                                ),
                                                              )),
                                                          TextButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                      .grey)),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop(false),
                                                              child: Text(
                                                                "No",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                  'Nunito',
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  fontSize: MediaQuery.of(
                                                                      context)
                                                                      .size
                                                                      .width *
                                                                      0.03,
                                                                ),
                                                              )),
                                                        ],
                                                      )),
                                                );
                                              },
                                              transitionDuration: const Duration(
                                                  milliseconds: 200),
                                              barrierDismissible: false,
                                              barrierLabel: '',
                                              context: context,
                                              pageBuilder: (context, animation1,
                                                  animation2) {
                                                return const Text('PAGE BUILDER');
                                              });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: height *0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),

                        /////////////////////////////////

                        isFirstClick == true && isSecondClick == true
                            ? Container()
                            : Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.08,
                              right: width * 0.14,
                              top: height * 0.04),
                          child: Container(
                            margin: const EdgeInsets.all(5.0),
                            padding: const EdgeInsets.all(13.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(20.0),
                                  topRight: const Radius.circular(20.0),
                                  bottomLeft: const Radius.circular(20.0),
                                  bottomRight:
                                  const Radius.circular(20.0),
                                )),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total          ",
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: width * 0.035,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "Rs. ${total}",
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: width * 0.035,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          "Select Routes",
                          style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child:  DropdownSearch<Routes>(
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Routes",
                                ),
                              ),
                              asyncItems: (String filter) async {

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                print(prefs.getString('id'));
                                List<Routes> response = await DatabaseHelper.instance.getRoutes(prefs.getString('id')) ;
                                return response;
                              },
                              itemAsString: (Routes a) => a.route_name.toLowerCase(),
                              onChanged: (Routes? data) {
                                route_id = data!.id.toString();
                                print(route_id+"111111111111");
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          "Select Address",
                          style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child:  DropdownSearch<Address>(
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Address",

                                ),
                              ),
                              asyncItems: (String filter) async
                              {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                print(prefs.getString('id'));
                                List<Address> response = await DatabaseHelper.instance.getAddress(route_id) ;
                                return response;
                              },

                              itemAsString: (Address a) => a.address_a.toLowerCase(),
                              onChanged: (Address? data) {
                                addressId = data!.id.toString();
                                print(addressId+"111111111111");
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        TextField(
                          style: TextStyle(fontSize: 12),
                          controller: remarksCont,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Remarks"),
                        ),
                        const SizedBox(height: defaultPadding * 2),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                // width: 5.0,
                                color: Colors.black26,
                              ),
                              minimumSize: Size.fromHeight(
                                  MediaQuery.of(context).size.height * 0.052),
                              primary: const Color.fromRGBO(239, 22, 31, 1.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.02),
                              ),
                            ),
                            onPressed: () {
                              if (items.length > 0) {
                                addressId == "" ? Fluttertoast.showToast(msg: 'Please Select Address',
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.black26) :   checkOut();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Your Cart is Empty ",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.black26);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.022,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.022),
                              child: Text(
                                "Place Order",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(items)));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.047, bottom: height * 0.02),
                            child: Text(
                              "or continue to contribute more",
                              style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

          ),
        );
      }),
    );
  }

 /* Future<Map<String, CartItem>> _navigateAndDisplaySelection3(
      BuildContext context, CartItem) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    // print(cart1.items);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainDrawerScreen(items: items)),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.

    ca = result;
    // After the  Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    print(result);
    return ca;
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));
  }*/

  void removeItem(String id) {
    items.remove(id);
    // notifyListeners();
  }
}