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
      case 2:
        checkOutForSwitch();
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
        await prefs.remove('region');
        await prefs.clear();
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

