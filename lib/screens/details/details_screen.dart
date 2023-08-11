import 'dart:math';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stylish/constants.dart';
import 'package:stylish/models/Product.dart';

import '../../Database/DatabaseHelper.dart';
import '../../Database/Product.dart';
import '../../models/Variations.dart';
import '../../models/cart.dart';
import '../../models/categories.dart';
import '../Cart/View_Cart_Screen.dart';
import '../home/home_screen.dart';
import 'components/color_dot.dart';

class DetailsScreen extends StatefulWidget {
  // final Product1 product;
  final Map<String, CartItem> items;
  DetailsScreen({Key? key, /*required this.product,*/ required this.items}) : super(key: key);
  @override
  State<DetailsScreen> createState() => _Details(/*this.product,*/this.items);
}



class _Details extends State<DetailsScreen> {
  DropdownEditingController<String> colorVal = DropdownEditingController();
  List<String> col = [];
  late Product1 product;
  Map<String, CartItem> items;
  var image = 'assets/icons/extra.png';
  bool DrmDisabled = false;
  bool GlnDisabled = false;
  var rng = Random();
  bool QtrDisabled = false;
  TextEditingController drm = new TextEditingController();
  TextEditingController gln = new TextEditingController();
  TextEditingController qtr = new TextEditingController();
  TextEditingController remarksCont = TextEditingController();
  List<Categories> catList = [];
  DropdownEditingController<String> catVal = DropdownEditingController();
  DropdownEditingController<String> prodVal = DropdownEditingController();
  var qprice;
  var gprice;
  var dprice;
  var qvid;
  var qsku;
  var gsku;
  var dsku;
  var qvname;
  var dvname;
  var gvid;
  var dvid;
  int p_id = 0;
  late String c_id;
  String pname = "";
  String price = "";
  var selected_color;
  String prodName = "";
  List<Product1> currentProdData = [];
  List<Product1> prodList = [];
  List<Product1> searchedProd = [];
  String searchProd = "";
  late Categories currentCatData;

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

    fetchData('1');
    getCatsFromLocal().then((value) {
      print("check" + (catList.length).toString());
      setState(() {});
    });
    p_id = 1;
    pname = 'Acrylic Filling Putty';

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

  _Details(/*this.product,*/this.items);
  @override
  Widget build(BuildContext context) {
    if(product.category_id == '1')
    {
      image='assets/icons/extra.png';
    }
    if(product.category_id =='2')
    {
      image='assets/icons/bold.png';
    }
    if(product.category_id =='3')
    {
      image='assets/icons/trends.png';
    }
    if(product.category_id =='4')
    {
      image='assets/icons/exclusive.png';
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen(items)));
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFEFBF9),
        appBar: AppBar(
          centerTitle: true,
          leading: const BackButton(color: Colors.black),
          title: Text(
            "Detials",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: [
            IconButton(
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
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                height:MediaQuery.of(context).size.height * 0.07 ,
                child: TextDropdownFormField(
                  controller: catVal,
                  options: catList.map((item) {
                    currentCatData = item;
                    return item.id + "-" + item.category_name.toLowerCase();
                  }).toList(),
                  onChanged: (dynamic str) {

                    String ss = str.replaceAll(new RegExp(r'[^0-9]'), '');
                    c_id = ss.toString();
                    getProductsPerCategory(
                        cat_ID: int.parse(ss.toString()));
                    setState(() {
                      str = catVal.value;
                      print(catVal.value);
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      labelText: "Categories"),
                  dropdownHeight: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                height:MediaQuery.of(context).size.height * 0.07 ,
                child: TextDropdownFormField(

                  controller: prodVal,
                  options: (catVal.value).toString().isEmpty
                      ? []
                      : prodList.map((item) {
                    currentProdData = prodList;
                    return item.id.toString() + "-" + item.title;
                  }).toList(),
                  onChanged: (dynamic str) {
                    setState(() async {

                      DrmDisabled = false;
                      QtrDisabled = false;
                      GlnDisabled  = false;
                      String ss =
                      str.replaceAll(new RegExp(r'[^0-9]'), '');
                      pname =
                          str.replaceAll(new RegExp(r'[^A-Za-z ]'), '');
                      prodName = pname;
                      // updateData(int.parse(ss));
                      print(pname);
                      p_id = int.parse(ss);
                      col = [];
                      List<Variations> ll = await DatabaseHelper.instance
                          .getVariationP(prodId: p_id.toString());

                      for (int a = 0; a < ll.length; a++) {
                        if (col.contains(ll[a].colors)) {
                        } else {
                          print(ll[a].colors);
                          col.add(ll[a].colors);
                        }
                      }

                      str = prodVal.value;
                      print("Checkkk" + searchProd);
                    });
                  },
                  decoration: InputDecoration(

                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      labelText: "Products"),
                  dropdownHeight: 200,
                ),
              ),
            ),
            Image.asset(
              image,
              height: MediaQuery.of(context).size.height * 0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: defaultPadding * 1.5),
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
                child: SingleChildScrollView(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Row(
                        children: [
                          Expanded(
                            child: Text(
                              pname,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          const SizedBox(width: defaultPadding),
                          Text(
                            "Rs. ${price}",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),*/
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child:
                        TextDropdownFormField(

                          controller: colorVal,
                          options: col,
                          onChanged: (dynamic str) async {
                            print(str);
                            DrmDisabled = false;
                            QtrDisabled = false;
                            GlnDisabled  = false;
                            colorVal.value = str;
                            selected_color = str;
                            List<Variations> sb =
                            await DatabaseHelper
                                .instance
                                .getVariationId(
                                prodId: p_id.toString(),
                                color: str.toString());
                            sb.forEach((element) {
                              if(element.size == 'Drm')
                              {

                                this.setState(() {
                                  print(element.size);
                                  DrmDisabled = true;
                                  dprice = element.price;
                                  dvid = element.id.toString();
                                  dvname = element.variationName.toString();

                                });

                              }
                              if(element.size == 'Qtr')
                              {

                                this.setState(() {
                                  print(element.size);
                                  QtrDisabled = true;
                                  qprice = element.price;
                                  qvid = element.id.toString();
                                  qvname = element.variationName;
                                });

                              }
                              if(element.size == 'Gln')
                              {

                                this.setState(() {
                                  print(element.size);
                                  GlnDisabled = true;
                                  gprice = element.price;
                                  gvid = element.id.toString();
                                  gsku = element.variationName.toString();

                                });

                              }
                            });
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon:
                              Icon(Icons.arrow_drop_down),
                              labelText: "Colors"),
                          dropdownHeight: 200,
                        ),
                      ),
                      Text(
                        "Sizes",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      const SizedBox(height: defaultPadding / 2),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height *0.05,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                enabled: QtrDisabled,
                                controller: qtr,

                                decoration: InputDecoration(

                                    border: OutlineInputBorder(),
                                    labelText: 'Qtr Quantity',
                                    hintText: 'Enter Quantity'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: SizedBox(

                              height: MediaQuery.of(context).size.height *0.05,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                enabled: GlnDisabled,
                                controller: gln,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Gln Quantity',
                                    hintText: 'Enter Quantity'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height *0.05,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                enabled: DrmDisabled,
                                controller: drm,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Drm Quantity',
                                    hintText: 'Enter Quantity'),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(fontSize: 12),
                        controller: remarksCont,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Remarks"),
                      ),
                      const SizedBox(height: defaultPadding * 2),
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (qvid.toString() != 'null') {

                                items.putIfAbsent(
                                    rng.nextInt(100).toString(),
                                        () => CartItem(
                                        id: DateTime.now().toString(),
                                        vid: qvid.toString(),
                                        pid: p_id.toString(),
                                        price: double.parse(qprice.toString()),
                                        quantity: int.parse(qtr.text.toString()),
                                        title: pname.toString(),
                                        size: 'Qtr',
                                        color: selected_color,
                                        variation_name: qvname.toString(),
                                        category_name: product.category_id,
                                        remarks: remarksCont.text.toString()));


                                QtrDisabled = false;
                                qtr.clear();
                                remarksCont.clear();
                              }
                              if (dvid.toString() != 'null') {
                                items.putIfAbsent(
                                    dvid.toString(),
                                        () => CartItem(
                                        id: DateTime.now().toString(),
                                        vid: dvid.toString(),
                                        pid: p_id.toString(),
                                        price: double.parse(dprice.toString()),
                                        quantity: int.parse(drm.text.toString()),
                                        title: pname.toString(),
                                        size: 'Drm',
                                        color: selected_color,
                                        variation_name: dvname.toString(),
                                        category_name: product.category_id.toString(),
                                        remarks: remarksCont.text.toString()));
                                // Fluttertoast.showToast(
                                //     msg: 'Drm Products Added to Cart',
                                //     textColor: Colors.white,
                                //     backgroundColor: Colors.green,
                                //     toastLength: Toast.LENGTH_SHORT);
                                drm.clear();
                                DrmDisabled = false;
                                remarksCont.clear();
                              }
                              if (gvid.toString() != 'null') {

                                items.putIfAbsent(
                                    gvid.toString(),
                                        () => CartItem(
                                        id: DateTime.now().toString(),
                                        vid: gvid.toString(),
                                        pid: p_id.toString(),
                                        price: double.parse(gprice.toString()),
                                        quantity: int.parse(gln.text.toString()),
                                        title: pname.toString(),
                                        size: 'Gln',
                                        color: selected_color,
                                        variation_name: gsku.toString(),
                                        category_name: product.category_id.toString(),
                                        remarks: remarksCont.text.toString()));
                                // Fluttertoast.showToast(
                                //     msg: 'Gln Products Added to Cart',
                                //     textColor: Colors.white,
                                //     backgroundColor: Colors.green,
                                //     toastLength: Toast.LENGTH_SHORT);
                                gln.clear();
                                GlnDisabled = false;
                                remarksCont.clear();
                              }
                              setState(() {
                                print('Samad');
                                selected_color = "";

                              });
                              print(product.title.toString()+ " is added to cart");
                            },
                            style: ElevatedButton.styleFrom(
                                primary: primaryColor,
                                shape: const StadiumBorder()),
                            child: const Text("Add to Cart"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<List<Variations>> fetchData(id) async {
    product = await DatabaseHelper.instance.getProduct(1);
    List<Variations> ll = await DatabaseHelper.instance.getVariationP(prodId: '1');

    for (int a = 0; a < ll.length; a++) {
      if (col.contains(ll[a].colors)) {
      } else {
        print(ll[a].colors);
        col.add(ll[a].colors);
      }

      print("_______________" + col.length.toString());
    }

    return ll;
  }
}
