import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:stylish/constants.dart';
import 'package:stylish/models/Product.dart';
import 'package:stylish/models/Variation.dart';

import '../../Database/DatabaseHelper.dart';
import '../../Database/Product.dart';
import '../../models/New_Variations.dart';
import '../../models/Variations.dart';
import '../../models/cart.dart';
import '../../models/categories.dart';
import '../Cart/View_Cart_Screen.dart';
import '../Cart/components/CustomScrollView.dart';
import '../home/components/search_form.dart';
import '../home/home_screen.dart';
import 'components/color_dot.dart';

class ProductDet extends StatefulWidget {
  final Product1 product;
  final Map<String, CartItem> items;
  ProductDet({Key? key, required this.product, required this.items})
      : super(key: key);
  @override
  State<ProductDet> createState() => _ProductDetails(this.product, this.items);
}

class _ProductDetails extends State<ProductDet> {
  DropdownEditingController<String> colorVal = DropdownEditingController();
  List<String> col = [];
  Product1 product;
  Map<String, CartItem> items;
  final ScrollController _controller = ScrollController();
  var image = 'assets/icons/extra.png';
  bool DrmDisabled = true;
  bool GlnDisabled = true;
  List<Variation_n> ll = [];
  var rng = Random();
  bool QtrDisabled = true;
  TextEditingController drm = new TextEditingController();
  TextEditingController gln = new TextEditingController();
  TextEditingController qtr = new TextEditingController();
  TextEditingController remarksCont = TextEditingController();
  TextEditingController search = new TextEditingController();
  List<Categories> catList = [];
  List<Product1> pd = [];
  DropdownEditingController<String> catVal = DropdownEditingController();
  DropdownEditingController<String> prodVal = DropdownEditingController();
  var qprice;
  var gprice;
  var dprice;
  var qvid;
  var qvname;
  var gvname;
  var dvname;
  var gvid;
  var dvid;
  int p_id = 0;
  late String c_id;
  String pname = "";
  String catname = "";
  var selected_color;
  String prodName = "";
  List<Product1> currentProdData = [];
  List<Product1> prodList = [];
  List<Product1> searchedProd = [];
  String searchProd = "";
  late Categories currentCatData;
  List<TextEditingController>? _qcontrollers = [];
  List<TextEditingController>? _dcontrollers = [];
  List<TextEditingController>? _gcontrollers = [];
  var total;
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }
  Future<List<Categories>> getCatsFromLocal() async {
    var db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM categories');
    catList =
        maps.isNotEmpty ? maps.map((e) => Categories.fromMap(e)).toList() : [];
    return catList;
  }

  @override
  void initState() {
    fetchData(product.id);

    getCatsFromLocal().then((value) {
      print("check" + (catList.length).toString());
      setState(() {
         total = 0.0;
        items.forEach((key, cartItem) {
          total = total + cartItem.price * cartItem.quantity;
        });
      });
    });

    p_id = this.product.id;
    pname = this.product.title;
  }

  Future<List<Product1>> getProductsPerCategory({required int cat_ID}) async {
    var db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> maps = await db!
        .query('products', where: 'category_id = ?', whereArgs: [cat_ID]);
    prodList =
        maps.isNotEmpty ? maps.map((e) => Product1.fromMap(e)).toList() : [];
    print("++++++++" + prodList.length.toString());
    return prodList;
  }

  _ProductDetails(this.product, this.items);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (product.category_id == '1') {
      image = 'assets/icons/extra.png';
    }
    if (product.category_id == '2') {
      image = 'assets/icons/bold.png';
    }
    if (product.category_id == '3') {
      image = 'assets/icons/trends.png';
    }
    if (product.category_id == '4') {
      image = 'assets/icons/exclusive.png';
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen(items)));
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFffe5e4),
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/Location.svg"),
              const SizedBox(width: defaultPadding / 2),
              Text(
                "Product Details",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: SvgPicture.asset("assets/icons/basket.svg"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewCartScreen(
                        items: items,
                      ),
                    ));
              },
            ),
          ],
        ),
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            catname.toUpperCase(),
                            style: TextStyle(
                                color: Color(0xffd80031),
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(

                    itemCount: pd.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          FilterChip(
                            backgroundColor: Colors.white,
                            avatar: CircleAvatar(
                              backgroundColor: Color(0xffd80031)  ,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  pd[index].title[0].toUpperCase(),
                                  style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.w600,fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            label: Text(pd[index].title),
                            selected: false,
                            onSelected: (bool selected) {
                              print(pd[index].title);

                              setState(() {
                                product = pd[index];
                                _clearTextFields();
                                fetchData(product.id);
                                _scrollDown();
                              });
                            },
                          ),
                          SizedBox(
                            width: 6,
                          ),
                        ],
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: TextFormField(
                      controller: search,
                      onSaved: (value) {
                        setState(() async {
                          ll = await DatabaseHelper.instance.Searchbycolor(
                              search.text.toString(), product.id.toString());
                        });
                      },
                      onFieldSubmitted: (value) {
                        setState(() async {
                          ll = await DatabaseHelper.instance.Searchbycolor(
                              search.text.toString(), product.id.toString());
                        });
                      },
                      onChanged: (value) async {
                        print('ass');
                        List<Variation_n> ll1 = await DatabaseHelper.instance.Searchbycolor(
                            search.text.toString(), product.id.toString());
                        setState(() {
                          ll = ll1;
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
                              horizontal: defaultPadding,
                              vertical: defaultPadding / 2),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: primaryColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                              onPressed: () {
                                /*setState(() async {
                                  ll =await DatabaseHelper.instance.Searchbycolor(search.text.toString(),product.id.toString());
                                });*/
                              },
                              child: Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(defaultPadding,
                      defaultPadding * 2, defaultPadding, defaultPadding),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(defaultBorderRadius * 3),
                      topRight: Radius.circular(defaultBorderRadius * 3),
                    ),
                  ),
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: ll.length,
                      primary: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        _qcontrollers?.add(new TextEditingController());
                        _dcontrollers?.add(new TextEditingController());
                        _gcontrollers?.add(new TextEditingController());
                        // print("Qtr___"+ll[index].qtr);
                        // print("Drm___"+ll[index].drm);
                        // print("Gln___"+ll[index].gln);
                        return Card(
                          color: Color(0xffd80031),
                          shadowColor: Colors.grey,
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DottedBorder(
                              borderType: BorderType.Rect,
                              radius: Radius.circular(12),
                              color: Colors.white,
                              padding: EdgeInsets.all(1),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 15.0,
                                                ),
                                                RichText(
                                                  overflow: TextOverflow.visible,
                                                  maxLines: 1,
                                                  text: TextSpan(
                                                      text:
                                                          '${ll[index].colors.toString()}\n',
                                                      style: const TextStyle(

                                                          fontFamily: 'Gordita',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Container(
                                                  decoration: new BoxDecoration(
                                                      color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
                                                      borderRadius: new BorderRadius.all(
                                                          Radius.circular(24.0))
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                          text:
                                                              'Rs. ${ll[index].price.toString()}\n',
                                                          style: const TextStyle(
                                                              color: Colors.pink,
                                                              fontFamily: 'Gordita',
                                                              fontWeight:
                                                                  FontWeight.bold)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.height *
                                                  0.09,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: RichText(
                                              overflow: TextOverflow.visible,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                  text:
                                                  'Qtr',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: RichText(
                                              overflow: TextOverflow.visible,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                  text:
                                                  'Gln',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: RichText(
                                              overflow: TextOverflow.visible,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                  text:
                                                  'Drm',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                          width:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: NumberInputWithIncrementDecrement(
                                              incIconColor: Colors.white,
                                              decIconColor: Colors.white,
                                              style: TextStyle(color: Colors.grey),
                                              widgetContainerDecoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                  Colors.transparent,
                                                ),
                                              ),
                                              numberFieldDecoration:InputDecoration(

                                                  filled: true,
                                                  fillColor: ll[index].qtr != 'null' && ll[index].qtrp != '0'
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    const BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(

                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.white),
                                                  ),
                                                  focusedBorder:OutlineInputBorder(
                                                    borderSide:
                                                    const BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        15.0),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide:
                                                    const BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        15.0),
                                                  ),
                                                  // //labeltext: 'Qtr Quantity',
                                                  labelStyle: TextStyle(
                                                    color: Colors
                                                        .red, //<-- SEE HERE
                                                  ),
                                                  hintText: 'Enter Quantity'),

                                              onChanged: (value)
                                              async {
                                                print(_qcontrollers![index].text.toString());
                                                if(_qcontrollers![index].text.toString() == "0")
                                                  {
                                                    Fluttertoast.showToast(msg: '0 Amount Not Added in Cart',backgroundColor: Colors.redAccent.shade100,textColor: Colors.black);
                                                  }
                                                else
                                                  {
                                                    if (items.containsKey(ll[index].qtr.toString()))
                                                    {
                                                      items.update(
                                                          ll[index].qtr.toString(),
                                                              (existing) => CartItem(
                                                              id: existing.id,
                                                              vid: existing.vid,
                                                              pid: existing.pid,
                                                              price: existing.price,
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: existing.title,
                                                              size: existing.size,
                                                              color: existing.color,
                                                              variation_name: existing
                                                                  .variation_name,
                                                              category_name: existing
                                                                  .category_name,
                                                              remarks:
                                                              existing.remarks));
                                                      print('updated');
                                                    }
                                                    else {
                                                      String variation_name= await DatabaseHelper.instance.getvariationName(ll[index].qtr);
                                                      items.putIfAbsent(
                                                          ll[index].qtr.toString(),
                                                              () => CartItem(
                                                              id: DateTime.now()
                                                                  .toString(),
                                                              vid: ll[index]
                                                                  .qtr
                                                                  .toString(),
                                                              pid:
                                                              product.id.toString(),
                                                              price: double.parse(ll[index].qtrp.toString()),
                                                              quantity: int.parse(value.toString()),
                                                              title: product.title.toString(),
                                                              size: 'Qtr',
                                                              color: ll[index].colors,
                                                              variation_name: variation_name,
                                                              category_name: product
                                                                  .category_id
                                                                  .toString(),
                                                              remarks: ""));
                                                      print('inserted');
                                                    }
                                                    print(ll[index].colors);
                                                    print(ll[index].qtr);
                                                  }

                                              },

                                              onIncrement: (value)
                                              async {
                                                if(_qcontrollers![index].text.toString() == "0")
                                                  {
                                                    Fluttertoast.showToast(msg: '0 Amount Not Added in Cart',backgroundColor: Colors.redAccent.shade100,textColor: Colors.black);
                                                  }
                                                else
                                                  {
                                                    print(value);
                                                    print("Samo-----------------${ll[index].qtr}");
                                                    String variation_name= await DatabaseHelper.instance.getvariationName(ll[index].qtr);
                                                    if (items.containsKey(ll[index].qtr.toString()))
                                                    {
                                                      items.update(
                                                          ll[index].qtr.toString(),
                                                              (existing) => CartItem(
                                                              id: existing.id,
                                                              vid: existing.vid,
                                                              pid: existing.pid,
                                                              price: existing.price,
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: existing.title,
                                                              size: existing.size,
                                                              color: existing.color,
                                                              variation_name: existing
                                                                  .variation_name,
                                                              category_name: existing
                                                                  .category_name,
                                                              remarks:
                                                              existing.remarks));
                                                      print('updated');
                                                    }
                                                    else
                                                    {
                                                      items.putIfAbsent(
                                                          ll[index].qtr.toString(),
                                                              () => CartItem(
                                                              id: DateTime.now()
                                                                  .toString(),
                                                              vid: ll[index]
                                                                  .qtr
                                                                  .toString(),
                                                              pid:
                                                              product.id.toString(),
                                                              price: double.parse(ll[index].qtrp.toString()),
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: product.title
                                                                  .toString(),
                                                              size: 'Qtr',
                                                              color: ll[index].colors,
                                                              variation_name: variation_name,
                                                              category_name: product
                                                                  .category_id
                                                                  .toString(),
                                                              remarks: ""));
                                                      print('inserted');
                                                    }
                                                    print(ll[index].colors);
                                                    print(ll[index].qtr);
                                                  }

                                              },
                                              onDecrement: (value)
                                              async {
                                                if(_qcontrollers![index].text.toString() == "0")
                                                {
                                                  Fluttertoast.showToast(msg: '0 Amount Not Added in Cart',backgroundColor: Colors.redAccent.shade100,textColor: Colors.black);
                                                  items.remove(ll[index].qtr.toString());
                                                }
                                                else
                                                  {
                                                    String variation_name= await DatabaseHelper.instance.getvariationName(ll[index].qtr);
                                                    if(items.containsKey(ll[index].qtr.toString()))
                                                    {
                                                      items.update(
                                                          ll[index].qtr.toString(),
                                                              (existing) => CartItem(
                                                              id: existing.id,
                                                              vid: existing.vid,
                                                              pid: existing.pid,
                                                              price: existing.price,
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: existing.title,
                                                              size: existing.size,
                                                              color: existing.color,
                                                              variation_name: existing
                                                                  .variation_name,
                                                              category_name: existing
                                                                  .category_name,
                                                              remarks:
                                                              existing.remarks));
                                                      print('updated');
                                                    }
                                                    else
                                                    {
                                                      items.putIfAbsent(
                                                          ll[index].qtr.toString(),
                                                              () => CartItem(
                                                              id: DateTime.now()
                                                                  .toString(),
                                                              vid: ll[index]
                                                                  .qtr
                                                                  .toString(),
                                                              pid:
                                                              product.id.toString(),
                                                              price: double.parse(
                                                                  ll[index]
                                                                      .qtrp
                                                                      .toString()),
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: product.title
                                                                  .toString(),
                                                              size: 'Qtr',
                                                              color: ll[index].colors,
                                                              variation_name: variation_name,
                                                              category_name: product
                                                                  .category_id
                                                                  .toString(),
                                                              remarks: ""));
                                                      print('inserted');
                                                    }
                                                  }

                                              },
                                              buttonArrangement:
                                              ButtonArrangement.rightEnd,
                                              enabled: ll[index].qtr != 'null' && ll[index].qtrp != '0'
                                                  ? true
                                                  : false,
                                              controller: _qcontrollers![index],

                                              scaleHeight: 0.65,
                                              incDecBgColor: Color(0xFFF67952),
                                              separateIcons: true,
                                              incIconDecoration: BoxDecoration(

                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5.0) //                 <--- border radius here
                                                  ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    stops: [
                                                      0.1,
                                                      0.4,
                                                    ],
                                                    colors: [
                                                      Colors.grey.shade200,
                                                      Color(0xff0001a4),
                                                    ],
                                                  )
                                              ),
                                              incIcon: Icons.add,
                                              decIconDecoration: BoxDecoration(

                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5.0) //                 <--- border radius here
                                                  ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    stops: [
                                                      0.1,
                                                      0.4,
                                                    ],
                                                    colors: [
                                                      Colors.grey.shade200,
                                                      Color(0xff0001a4),
                                                    ],
                                                  )
                                              ),
                                              decIcon: Icons.remove,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: NumberInputWithIncrementDecrement(
                                              decIconColor: Colors.white,
                                              incIconColor: Colors.white,
                                              widgetContainerDecoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                  Colors.transparent,
                                                ),
                                              ),
                                              numberFieldDecoration:InputDecoration(

                                                  filled: true,
                                                  fillColor: ll[index].gln != 'null' && ll[index].glnp != '0'
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    const BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(

                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.white),
                                                  ),

                                                  focusedBorder:OutlineInputBorder(
                                                    borderSide:
                                                    const BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        15.0),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide:
                                                    const BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        15.0),
                                                  ),
                                                  // //labeltext: 'Qtr Quantity',
                                                  labelStyle: TextStyle(
                                                    color: Colors
                                                        .red, //<-- SEE HERE
                                                  ),
                                                  hintText: 'Enter Quantity'),
                                              style: TextStyle(color: Colors.grey),

                                              onChanged: (value) async {
                                                print(value);
                                                if(_gcontrollers![index].text.toString() == "0")
                                                {
                                                  Fluttertoast.showToast(msg: '0 Amount Not Added/Updated in Cart',backgroundColor: Colors.redAccent.shade100,textColor: Colors.black);
                                                  // items.remove(items.keys.toList()[index]);
                                                }
                                                else
                                                  {
                                                    String variation_name= await DatabaseHelper.instance.getvariationName(ll[index].gln);
                                                    if (items.containsKey(ll[index].gln.toString()))
                                                    {
                                                      items.update(
                                                          ll[index].gln.toString(),
                                                              (existing) => CartItem(
                                                              id: existing.id,
                                                              vid: existing.vid,
                                                              pid: existing.pid,
                                                              price: existing.price,
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: existing.title,
                                                              size: existing.size,
                                                              color: existing.color,
                                                              variation_name: existing
                                                                  .variation_name,
                                                              category_name: existing
                                                                  .category_name,
                                                              remarks:
                                                              existing.remarks));
                                                      print('updated');
                                                    }
                                                    else
                                                    {
                                                      items.putIfAbsent(
                                                          ll[index].gln.toString(),
                                                              () => CartItem(
                                                              id: DateTime.now()
                                                                  .toString(),
                                                              vid: ll[index]
                                                                  .gln
                                                                  .toString(),
                                                              pid:
                                                              product.id.toString(),
                                                              price: double.parse(
                                                                  ll[index]
                                                                      .glnp
                                                                      .toString()),
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: product.title
                                                                  .toString(),
                                                              size: 'Gln',
                                                              color: ll[index].colors,
                                                              variation_name: variation_name,
                                                              category_name: product
                                                                  .category_id
                                                                  .toString(),
                                                              remarks: ""));
                                                      print('inserted');
                                                    }
                                                  }


                                                print(ll[index].colors);
                                                print(ll[index].gln);
                                              },
                                              onIncrement: (value) async {
                                                print(value);
                                                if (items.containsKey(ll[index].gln.toString()))
                                                {
                                                  items.update(
                                                      ll[index].gln.toString(),
                                                          (existing) => CartItem(
                                                          id: existing.id,
                                                          vid: existing.vid,
                                                          pid: existing.pid,
                                                          price: existing.price,
                                                          quantity: int.parse(
                                                              value.toString()),
                                                          title: existing.title,
                                                          size: existing.size,
                                                          color: existing.color,
                                                          variation_name: existing
                                                              .variation_name,
                                                          category_name: existing
                                                              .category_name,
                                                          remarks:
                                                          existing.remarks));
                                                  print('updated');
                                                } else {
                                                  String variation_name= await DatabaseHelper.instance.getvariationName(ll[index].gln);
                                                  items.putIfAbsent(
                                                      ll[index].gln.toString(),
                                                          () => CartItem(
                                                          id: DateTime.now()
                                                              .toString(),
                                                          vid: ll[index]
                                                              .gln
                                                              .toString(),
                                                          pid:
                                                          product.id.toString(),
                                                          price: double.parse(
                                                              ll[index]
                                                                  .glnp
                                                                  .toString()),
                                                          quantity: int.parse(
                                                              value.toString()),
                                                          title: product.title
                                                              .toString(),
                                                          size: 'Gln',
                                                          color: ll[index].colors,
                                                          variation_name:variation_name,
                                                          category_name: product
                                                              .category_id
                                                              .toString(),
                                                          remarks: ""));
                                                  print('inserted');
                                                }
                                                print(ll[index].colors);
                                                print(ll[index].qtr);
                                              },
                                              onDecrement: (value) async {
                                                if(_gcontrollers![index].text.toString() == "0")
                                                {
                                                  Fluttertoast.showToast(msg: '0 Amount Not Added in Cart',backgroundColor: Colors.redAccent.shade100,textColor: Colors.black);
                                                  items.remove(ll[index].gln.toString());
                                                }
                                                else
                                                  {
                                                    String variation_name= await DatabaseHelper.instance.getvariationName(ll[index].gln);
                                                    if (items.containsKey(ll[index].gln.toString()))
                                                    {
                                                      items.update(
                                                          ll[index].gln.toString(),
                                                              (existing) => CartItem(
                                                              id: existing.id,
                                                              vid: existing.vid,
                                                              pid: existing.pid,
                                                              price: existing.price,
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: existing.title,
                                                              size: existing.size,
                                                              color: existing.color,
                                                              variation_name: existing
                                                                  .variation_name,
                                                              category_name: existing
                                                                  .category_name,
                                                              remarks:
                                                              existing.remarks));
                                                      print('updated');
                                                    }
                                                    else
                                                    {
                                                      items.putIfAbsent(
                                                          ll[index].gln.toString(),
                                                              () => CartItem(
                                                              id: DateTime.now()
                                                                  .toString(),
                                                              vid: ll[index]
                                                                  .gln
                                                                  .toString(),
                                                              pid:
                                                              product.id.toString(),
                                                              price: double.parse(
                                                                  ll[index]
                                                                      .glnp
                                                                      .toString()),
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: product.title
                                                                  .toString(),
                                                              size: 'Gln',
                                                              color: ll[index].colors,
                                                              variation_name: variation_name,
                                                              category_name: product
                                                                  .category_id
                                                                  .toString(),
                                                              remarks: ""));
                                                      print('inserted');
                                                    }
                                                  }

                                              },
                                              buttonArrangement:
                                              ButtonArrangement.rightEnd,
                                              enabled: ll[index].gln != 'null' && ll[index].glnp != '0'
                                                  ? true
                                                  : false,
                                              controller: _gcontrollers![index],
                                              scaleHeight: 0.65,
                                              incDecBgColor: Color(0xFFF67952),
                                              separateIcons: true,
                                              incIconDecoration: BoxDecoration(

                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5.0) //                 <--- border radius here
                                                  ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    stops: [
                                                      0.1,
                                                      0.4,
                                                    ],
                                                    colors: [
                                                      Colors.grey.shade200,
                                                      Color(0xff0001a4),
                                                    ],
                                                  )
                                              ),
                                              incIcon: Icons.add,
                                              decIconDecoration: BoxDecoration(

                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5.0) //                 <--- border radius here
                                                  ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    stops: [
                                                      0.1,
                                                      0.4,
                                                    ],
                                                    colors: [
                                                      Colors.grey.shade200,
                                                      Color(0xff0001a4),
                                                    ],
                                                  )
                                              ),
                                              decIcon: Icons.remove,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.09,
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: NumberInputWithIncrementDecrement(

                                              // initialValue: 3,
                                              decIconColor: Colors.white,
                                              incIconColor: Colors.white,
                                              widgetContainerDecoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                  Colors.transparent,
                                                ),
                                              ),
                                              numberFieldDecoration:InputDecoration(

                                                  filled: true,
                                                  fillColor: ll[index].drm != 'null' && ll[index].drmp != '0'
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  enabledBorder: OutlineInputBorder(

                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.white),
                                                  ),
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    const BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5.0),
                                                  ),
                                                  focusedBorder:OutlineInputBorder(
                                                    borderSide:
                                                    const BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        15.0),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide:
                                                    const BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        15.0),
                                                  ),
                                                  labelStyle: TextStyle(
                                                    color: Colors
                                                        .red, //<-- SEE HERE
                                                  ),
                                                  hintText: 'Enter Quantity'),
                                              style: TextStyle(color: Colors.grey),
                                              onChanged: (value) async {
                                                if(_dcontrollers![index].text.toString() == "0")
                                                {
                                                  Fluttertoast.showToast(msg: '0 Amount Not Added in Cart',backgroundColor: Colors.redAccent.shade100,textColor: Colors.black);
                                                  // items.remove(ll[index].drm.toString());
                                                }
                                                else
                                                {
                                                  String variation_name= await DatabaseHelper.instance.getvariationName(ll[index].drm);
                                                  print(variation_name);
                                                  if (value == 0) {
                                                    print('Samad ${ll[index].drm
                                                        .toString()}');
                                                    _dcontrollers![index]
                                                        .clear();
                                                    print(value);
                                                    if (items.containsKey(ll[index].drm.toString()))
                                                    {
                                                      items.update(
                                                          ll[index].drm
                                                              .toString(),
                                                              (existing) =>
                                                              CartItem(
                                                                  id: existing
                                                                      .id,
                                                                  vid: existing
                                                                      .vid,
                                                                  pid: existing
                                                                      .pid,
                                                                  price: existing
                                                                      .price,
                                                                  quantity: int
                                                                      .parse(
                                                                      value
                                                                          .toString()),
                                                                  title: existing
                                                                      .title,
                                                                  size: existing
                                                                      .size,
                                                                  color: existing
                                                                      .color,
                                                                  variation_name: existing
                                                                      .variation_name,
                                                                  category_name: existing
                                                                      .category_name,
                                                                  remarks:
                                                                  existing
                                                                      .remarks));
                                                      print('updated');
                                                    }
                                                    else {
                                                      items.putIfAbsent(
                                                          ll[index].drm
                                                              .toString(),
                                                              () =>
                                                              CartItem(
                                                                  id: DateTime
                                                                      .now()
                                                                      .toString(),
                                                                  vid: ll[index]
                                                                      .drm
                                                                      .toString(),
                                                                  pid:
                                                                  product.id
                                                                      .toString(),
                                                                  price: double
                                                                      .parse(
                                                                      ll[index]
                                                                          .drmp
                                                                          .toString()),
                                                                  quantity: int
                                                                      .parse(
                                                                      value
                                                                          .toString()),
                                                                  title: product
                                                                      .title
                                                                      .toString(),
                                                                  size: 'Drm',
                                                                  color: ll[index]
                                                                      .colors,
                                                                  variation_name: variation_name,
                                                                  category_name: product
                                                                      .category_id
                                                                      .toString(),
                                                                  remarks: ""));
                                                      print('inserted');
                                                    }
                                                  }
                                                  else {
                                                    print(
                                                        'Samad //////${ll[index]
                                                            .drm.toString()}');
                                                    print(value);

                                                    if (items.containsKey(
                                                        ll[index].drm
                                                            .toString())) {
                                                      items.update(
                                                          ll[index].drm
                                                              .toString(),
                                                              (existing) =>
                                                              CartItem(
                                                                  id: existing
                                                                      .id,
                                                                  vid: existing
                                                                      .vid,
                                                                  pid: existing
                                                                      .pid,
                                                                  price: existing
                                                                      .price,
                                                                  quantity: int
                                                                      .parse(
                                                                      value
                                                                          .toString()),
                                                                  title: existing
                                                                      .title,
                                                                  size: existing
                                                                      .size,
                                                                  color: existing
                                                                      .color,
                                                                  variation_name: existing
                                                                      .variation_name,
                                                                  category_name: existing
                                                                      .category_name,
                                                                  remarks:
                                                                  existing
                                                                      .remarks));
                                                      print('updated');
                                                    }
                                                    else {
                                                      items.putIfAbsent(
                                                          ll[index].drm
                                                              .toString(),
                                                              () =>
                                                              CartItem(
                                                                  id: DateTime
                                                                      .now()
                                                                      .toString(),
                                                                  vid: ll[index]
                                                                      .drm
                                                                      .toString(),
                                                                  pid:
                                                                  product.id
                                                                      .toString(),
                                                                  price: double
                                                                      .parse(
                                                                      ll[index]
                                                                          .drmp
                                                                          .toString()),
                                                                  quantity: int
                                                                      .parse(
                                                                      value
                                                                          .toString()),
                                                                  title: product
                                                                      .title
                                                                      .toString(),
                                                                  size: 'Drm',
                                                                  color: ll[index]
                                                                      .colors,
                                                                  variation_name: variation_name,
                                                                  category_name: product
                                                                      .category_id
                                                                      .toString(),
                                                                  remarks: ""));
                                                      print('inserted');
                                                    }
                                                  }
                                                }
                                                print(ll[index].colors);
                                                print(ll[index].gln);
                                              },
                                              onIncrement: (value) async {
                                                if (items.containsKey(ll[index].drm.toString()))
                                                {
                                                  items.update(
                                                      ll[index].drm.toString(),
                                                          (existing) => CartItem(
                                                          id: existing.id,
                                                          vid: existing.vid,
                                                          pid: existing.pid,
                                                          price: existing.price,
                                                          quantity: int.parse(
                                                              value.toString()),
                                                          title: existing.title,
                                                          size: existing.size,
                                                          color: existing.color,
                                                          variation_name: existing
                                                              .variation_name,
                                                          category_name: existing
                                                              .category_name,
                                                          remarks:
                                                          existing.remarks));
                                                  print('updated');
                                                }
                                                else {
                                                  String variation_name= await DatabaseHelper.instance.getvariationName(ll[index].drm);
                                                  print(variation_name);
                                                  items.putIfAbsent(ll[index].drm.toString(),
                                                          () => CartItem(
                                                          id: DateTime.now()
                                                              .toString(),
                                                          vid: ll[index]
                                                              .drm
                                                              .toString(),
                                                          pid:
                                                          product.id.toString(),
                                                          price: double.parse(
                                                              ll[index]
                                                                  .drmp
                                                                  .toString()),
                                                          quantity: int.parse(
                                                              value.toString()),
                                                          title: product.title
                                                              .toString(),
                                                          size: 'Drm',
                                                          color: ll[index].colors,
                                                          variation_name: variation_name,
                                                          category_name: product
                                                              .category_id
                                                              .toString(),
                                                          remarks: ""));
                                                  print('inserted');
                                                }
                                                print(ll[index].colors);
                                                print(ll[index].qtr);
                                              },

                                              onDecrement: (value) async {
                                                if(_dcontrollers![index].text.toString() == "0")
                                                {
                                                  Fluttertoast.showToast(msg: '0 Amount Not Added in Cart',backgroundColor: Colors.redAccent.shade100,textColor: Colors.black);
                                                  items.remove(ll[index].drm.toString());
                                                }
                                                else
                                                  {
                                                    String variation_name= await DatabaseHelper.instance.getvariationName(ll[index].drm);
                                                    if (items.containsKey(ll[index].drm.toString())) {
                                                      items.update(
                                                          ll[index].drm.toString(),
                                                              (existing) => CartItem(
                                                              id: existing.id,
                                                              vid: existing.vid,
                                                              pid: existing.pid,
                                                              price: existing.price,
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: existing.title,
                                                              size: existing.size,
                                                              color: existing.color,
                                                              variation_name: existing.variation_name,
                                                              category_name: existing.category_name,
                                                              remarks:
                                                              existing.remarks));
                                                      print('updated');
                                                    }
                                                    else {
                                                      items.putIfAbsent(
                                                          ll[index].drm.toString(),
                                                              () => CartItem(
                                                              id: DateTime.now()
                                                                  .toString(),
                                                              vid: ll[index]
                                                                  .drm
                                                                  .toString(),
                                                              pid:
                                                              product.id.toString(),
                                                              price: double.parse(
                                                                  ll[index]
                                                                      .drmp
                                                                      .toString()),
                                                              quantity: int.parse(
                                                                  value.toString()),
                                                              title: product.title
                                                                  .toString(),
                                                              size: 'Drm',
                                                              color: ll[index].colors,
                                                              variation_name: variation_name,
                                                              category_name: product
                                                                  .category_id
                                                                  .toString(),
                                                              remarks: ""));
                                                      print('inserted');
                                                    }
                                                  }

                                              },
                                              buttonArrangement:
                                              ButtonArrangement.rightEnd,
                                              enabled: ll[index].drm != 'null'
                                                  ? true
                                                  : false,
                                              controller: _dcontrollers![index],
                                              scaleHeight: 0.65,
                                              incDecBgColor: Color(0xFFF67952),
                                              separateIcons: true,
                                              incIconDecoration: BoxDecoration(

                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5.0) //                 <--- border radius here
                                                  ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    stops: [
                                                      0.1,
                                                      0.4,
                                                    ],
                                                    colors: [
                                                      Colors.grey.shade200,
                                                      Color(0xff0001a4),
                                                    ],
                                                  )
                                              ),
                                              incIcon: Icons.add,
                                              decIconDecoration: BoxDecoration(

                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5.0) //                 <--- border radius here
                                                  ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    stops: [
                                                      0.1,
                                                      0.4,
                                                    ],
                                                    colors: [
                                                      Colors.grey.shade200,
                                                      Color(0xff0001a4),
                                                    ],
                                                  )
                                              ),
                                              decIcon: Icons.remove,
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),

        ]),
      ),
    );
  }

  void _clearTextFields() {
    for (var controller in _qcontrollers!) {
      controller.text = '0';
    }

    for (var controller in _dcontrollers!) {
      controller.text = '0';
    }
    for (var controller in _gcontrollers!) {
      controller.text = '0';
    }
  }

  Future<List<Variation_n>> fetchData(id) async {
    ll = await DatabaseHelper.instance.getVariationPr(prodId: id.toString());
    pd = await DatabaseHelper.instance.getCProducts(product.category_id);
    catname = await DatabaseHelper.instance.getCategory(product.category_id);
    setState(() {
      ll = ll;
      pd = pd;
    });
    print("Somi" + pd.length.toString());
    return ll;
  }

  Future<List<Variation_n>> fetchData2(id) async {
    ll = await DatabaseHelper.instance.getVariationPr(prodId: id.toString());
    print("Somi" + ll.length.toString());

    return ll;
  }

  Widget actionChips() {
    return ActionChip(
      elevation: 6.0,
      padding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.green[60],
        child: Icon(Icons.call),
      ),
      label: Text('Call'),
      onPressed: () {
        // _key.currentState.showSnackBar(SnackBar(
        //   content: Text('Calling...'),
        // ));
      },
      backgroundColor: Colors.white,
      shape: StadiumBorder(
          side: BorderSide(
        width: 1,
        color: Colors.blueAccent,
      )),
    );
  }
}
