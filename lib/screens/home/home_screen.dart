import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stylish/constants.dart';
import 'package:stylish/screens/Cart/View_Cart_Screen.dart';
import 'package:stylish/screens/Forms/formpage.dart';
import 'package:stylish/screens/details/Cat.dart';

import '../../Database/DatabaseHelper.dart';
import '../../main.dart';
import '../../models/Route_Name.dart';
import '../../models/User_Routes.dart';
import '../../models/address.dart';
import '../../models/cart.dart';
import '../Forms/form_list.dart';
import '../Login.dart';
import '../details/billing_adress_screen.dart';
import '../details/details_screen.dart';
import 'components/Navigation_Drawer_Widget.dart';
import 'components/categories.dart';
import 'components/new_arrival_products.dart';
import 'components/popular_products.dart';
import 'components/product_card.dart';
import 'components/search_form.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/Product.dart';
import '../../models/Variations.dart';
import '../../models/address.dart';
import '../../models/categories.dart';
import '../../models/users.dart';
import 'components/section_title.dart';

class HomeScreen extends StatefulWidget {
  Map<String, CartItem> items;
  late Map<String, CartItem> ca;
  HomeScreen(this.items);
  @override
  State<HomeScreen> createState() => _HomeScreenState(items);
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product1>> demo_products;
  Map<String, CartItem> items;
  _HomeScreenState(this.items);
  late Map<String, CartItem> ca;
  late final GlobalKey<FormState> formKey;
  TextEditingController search = new TextEditingController();

  init() async
  {
    await initializeService();
  }
  bool allow = true;
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
    final formKey = GlobalKey<FormState>();
    var db = await DatabaseHelper.instance.db;
    var result = await db!.rawQuery('SELECT COUNT(*) FROM orders');
    numOfOrders = Sqflite.firstIntValue(result)!;
  }
  getTime(startTime, endTime) {
    bool result = false;
    int startTimeInt = (startTime.hour * 60 + startTime.minute) * 60;
    int EndTimeInt = (endTime.hour * 60 + endTime.minute) * 60;
    int dif = EndTimeInt - startTimeInt;

    if (EndTimeInt > startTimeInt) {
      print('your shift is not finished');
      result = false;
    } else {
      print('your shift is  finished');
      result = true;
    }
    return result;
  }

  session() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Users us = await DatabaseHelper.instance.getUserById(prefs.getString('id'));

    String time =  us.duty_out.toString();
    print(time);
    List<String> timeparts = time.split(':');
    // print(timeparts[0]);
    int hour = int.parse(timeparts[0]);
    int minute = int.parse(timeparts[1]);
    TimeOfDay tt = TimeOfDay(hour: hour, minute: minute);
    TimeOfDay now = TimeOfDay.now();
    setState(() {
      allow = getTime(now, tt);

    });




    // name = prefs.getString('username')!;
    // email = prefs.getString('email')!;
  }


  @override
  void initState() {
    super.initState();
    // init();
    session();
    formKey = GlobalKey<FormState>();
    demo_products = DatabaseHelper.instance.getProducts();
    ca = items;
    print(ca.length);
    getOrderCount().then((value) {
      setState(() {
        print(numOfOrders.toString() + 'CHECKORDER');
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final urlImage = "assets/images/logo_n.png";
    late Future<List<Categories>> demo_categories =
        DatabaseHelper.instance.getCatsFromLocal();


    return ChangeNotifierProvider(
        create: (_) => new Cart(),
        child: Consumer<Cart>(builder: (context, cart, child) {

          cart.items = ca;
          print("SOi"+ca.length.toString());
      return Scaffold(
      key: scaffoldKey,
        resizeToAvoidBottomInset: false,
          appBar: AppBar(

        leading: IconButton(
          onPressed: () => {
            if (scaffoldKey.currentState!.isDrawerOpen)
              {
                scaffoldKey.currentState!.closeDrawer(),
                //close drawer, if drawer is open
              }
            else
              {
                scaffoldKey.currentState!.openDrawer(),
                //open drawer, if drawer is closed
              }
          },
          icon: SvgPicture.asset("assets/icons/menu.svg"),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/Location.svg"),
            const SizedBox(width: defaultPadding / 2),
            Text(
              "Nelson Paints",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        actions: [
          new Stack(
            children:[ IconButton(
              icon: SvgPicture.asset("assets/icons/basket.svg"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewCartScreen(items: items,),
                    ));
              },
            ),
              new Positioned(
                right: 3,
                top: 2,
                child: new Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    cart.itemCount.toString(),
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
          ),
        ],
      ),
        drawer: Drawer(
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
                       buildMenuItem(
                    text: 'Get Data',
                    icon: Icons.data_saver_on,
                    onClicked: () => selectedItem(context, 0),
                  ),
                      const SizedBox(height: 16),
                      buildMenuItem(
                        text: 'Add Address',
                        icon: Icons.location_history,
                        onClicked: () => selectedItem(context, 1),
                      ),
                       const SizedBox(height: 16),

                  buildMenuItem2(
                    text: 'Start Service',
                    icon: Icons.home_repair_service_rounded,
                    onClicked: () => selectedItem(context, 1),
                  ),
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
                      Divider(color: Colors.white70),
                      const SizedBox(height: 24),
                      buildMenuItem(
                        text: 'Forms',
                        icon: Icons.account_tree,
                        onClicked: () => selectedItem(context, 5),
                      ),
                      const SizedBox(height: 24),
                      if(allow == true)
                      buildMenuItem(
                        text: 'Logout',
                        icon: Icons.logout,
                        onClicked: () => selectedItem(context, 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
        displacement: 250,
        backgroundColor: Colors.white,
        color: Colors.orange,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          setState(() {
            session();
            demo_products = DatabaseHelper.instance.getProducts();
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/banner_1.png",
                fit: BoxFit.cover,
              ),
             /* Text(
                "Explore",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const Text(
                "best Products for you",
                style: TextStyle(fontSize: 18),
              ),*/
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Form(
                   key: formKey,
                   child: TextFormField(
                     controller: search,
                     onSaved: (value) {
                       setState((){
                         demo_products = DatabaseHelper.instance.SearchProducts(search.text.toString());
                       });
                     },
                     onChanged: (value) {
                       setState((){
                         demo_products = DatabaseHelper.instance.SearchProducts(search.text.toString());
                       });
                     },
                     onTap: () {
                       FocusScope.of(context).requestFocus(new FocusNode());
                     },
                     onFieldSubmitted: (value){
                       setState((){
                         demo_products = DatabaseHelper.instance.SearchProducts(search.text.toString());
                       });
                     },
                     decoration: InputDecoration(
                       filled: true,
                       fillColor: Colors.white,
                       hintText: "Search items...",
                       border: outlineInputBorder,
                       enabledBorder: outlineInputBorder,
                       focusedBorder: outlineInputBorder,
                       errorBorder: outlineInputBorder,
                       prefixIcon: Padding(
                         padding: const EdgeInsets.all(14),
                         child: SvgPicture.asset("assets/icons/Search.svg"),
                       ),
                       suffixIcon: Padding(
                         padding: const EdgeInsets.symmetric(
                             horizontal: defaultPadding, vertical: defaultPadding / 2),
                         child: SizedBox(
                           width: 48,
                           height: 48,
                           child: ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               primary: primaryColor,
                               shape: const RoundedRectangleBorder(
                                 borderRadius: BorderRadius.all(Radius.circular(12)),
                               ),
                             ),
                             onPressed: () {
                               setState((){
                                 demo_products = DatabaseHelper.instance.SearchProducts(search.text.toString());
                               });
                             },
                             child: SvgPicture.asset("assets/icons/Filter.svg",color: Colors.white),
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 84,
                  child: FutureBuilder<List<Categories>>(
                      future: demo_categories,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Categories>? data = snapshot.data;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: OutlinedButton(
                                  onLongPress: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsScreen(items: cart.items,),
                                        ));
                                  },
                                  onPressed: (){
                                    print('Somi');
                                    setState((){
                                      demo_products = DatabaseHelper.instance.getCProducts(data![index].id);
                                    });


                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(defaultBorderRadius)),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: defaultPadding / 2, horizontal: defaultPadding / 4),
                                    child: Column(
                                      children: [
                                        if (data![index].id == '1')
                                          Image.asset('assets/icons/extra.png', width: 39, height: 38),
                                        if (data![index].id == '2')
                                          Image.asset('assets/icons/bold.png', width: 39, height: 38),
                                        if (data![index].id == '3')
                                          Image.asset('assets/icons/trends.png', width: 39, height: 38),
                                        if (data![index].id == '4')
                                          Image.asset('assets/icons/exclusive.png',
                                              width: 39, height: 38),
                                        const SizedBox(height: defaultPadding / 2),
                                        Text(
                                          data![index].category_name,
                                          style: Theme.of(context).textTheme.subtitle2,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SectionTitle(
                  title: "Products",
                  pressSeeAll: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<Product1>>
                  (
                    future: demo_products,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Product1>? data = snapshot.data;
                        return GridView.builder(
                          itemCount: data?.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: defaultPadding),
                              child: ProductCard(
                                title: data![index].title,
                                image: data![index].category_id,
                                price: data![index].price,
                                bgColor: const Color(0xFFFEFBF9),
                                press: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDet(product: data[index],items: cart.items,),
                                      ));
                                },
                              ),
                            );
                          },
                          physics: ScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),

            ],
          ),
        ),
      ),
    );
    }),
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

  /*getAddress() async {
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
            price: tokenVariations[a]['price']));
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
  }*/

  Future<void> selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        getForm();
        getUser();
        print('Samad');
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
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(items: items,),
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
      case 5:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OurFormPage()
            ));
        break;
    }
  }
}

