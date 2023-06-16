import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:http/http.dart' as http;
import 'package:stylish/models/User_Routes.dart';

import '../model/OPFormModel.dart';
import '../model/inputFormModel.dart';
import '../models/New_Variations.dart';
import '../models/Orders.dart';
import '../models/Route_Name.dart';
import '../models/TrackingServiceModel.dart';
import '../models/Variation.dart';
import '../models/Variations.dart';
import '../models/address.dart';
import '../models/categories.dart';
import '../models/users.dart';
import 'Product.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get db async => _database ??= await _initDatabase();

  _initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,
        'nelson.db'); //At the time of deployment 'nelson00'

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database? db, int version) async {
    await db?.execute('''CREATE TABLE IF NOT EXISTS trackingService 
     (id INTEGER PRIMARY KEY AUTOINCREMENT,
          token TEXT, latitude TEXT, angle TEXT, speed TEXT,
          longitude TEXT, location TEXT, battery TEXT, datetime TEXT, odo TEXT)''');

    await db?.execute('''CREATE TABLE products 
        (id INTEGER, title TEXT, description TEXT,images TEXT,category_id TEXT,
        price TEXT, rating TEXT,colors TEXT,sizes TEXT,isFavourite TEXT,isPopular TEXT)''');

    await db?.execute('''CREATE TABLE variations 
        (id INTEGER, name TEXT, size TEXT,colors TEXT,color_id TEXT,
        product_id TEXT, variation_id, variation_name, price TEXT, price2 TEXT, price3 TEXT,  price4 TEXT, price5 TEXT, price6 TEXT, price7 TEXT)''');

    await db?.execute('''CREATE TABLE categories 
        (id INTEGER, category_name TEXT)''');

    await db?.execute('''CREATE TABLE routes 
        (id INTEGER, route_name TEXT)''');

    await db?.execute('''CREATE TABLE users 
        (id INTEGER, name TEXT, privilege TEXT, login TEXT,
        password TEXT, status TEXT,description TEXT, address TEXT,
        telephone TEXT, email TEXT, field_agent TEXT, route_id TEXT, odo TEXT, duty_in TEXT, duty_out TEXT, interval TEXT)''');

    await db?.execute('''CREATE TABLE user_routes 
        (id INTEGER, user_id TEXT, route_id TEXT)''');

    await db?.execute('''CREATE TABLE address 
        (id INTEGER, user_id TEXT, first_name TEXT, last_name TEXT,
        address_a TEXT, address_b TEXT,state TEXT, status TEXT, city TEXT,
        post_code TEXT, country TEXT, email TEXT, phone TEXT, created_by TEXT)''');

    await db?.execute('''CREATE TABLE orders 
        (id INTEGER, category_id TEXT, order_date TEXT, total TEXT,
        address_a TEXT, address_id TEXT,payment_method TEXT, payment_method_title TEXT,
        order_items TEXT, remarks TEXT, created_by TEXT)''');
    await db?.execute('''CREATE TABLE getForm 
        (id INTEGER PRIMARY KEY AUTOINCREMENT,formId TEXT, formName TEXT, apiResp TEXT)''');
    await db?.execute('''CREATE TABLE IF NOT EXISTS showForm 
 (id INTEGER PRIMARY KEY AUTOINCREMENT,
        formId TEXT, 
        formname TEXT,
        dataOutput TEXT)''');
  }



  Future<List<InputForms>> getInputForms() async {
    var db = await instance.db;
    var forms = await db!.query(
      'getForm',
      columns: [
        'formId',
        'formName',
        'apiResp',
      ],
    );
    List<InputForms> InpformsList = forms.isNotEmpty
        ? forms.map((e) => InputForms.fromMap(e)).toList()
        : [];
    return InpformsList;
  }

  Future<List<InputForms>> search(String kw) async {
    var db = await instance.db;
    var forms = await db!
        .query('getForm', where: 'formName LIKE ?', whereArgs: ["%$kw%"]);
    List<InputForms> InpformsList = forms.isNotEmpty
        ? forms.map((e) => InputForms.fromMap(e)).toList()
        : [];
    return InpformsList;
  }

  Future<List<InputForms>> getOneFor(formName) async {
    var db = await instance.db;
    var forms = await db!.query('getForm',
        columns: [
          'formId',
          'formName',
          'apiResp',
        ],
        where: 'formId = ?',
        whereArgs: [formName]);
    List<InputForms> InpformsList = forms.isNotEmpty
        ? forms.map((e) => InputForms.fromMap(e)).toList()
        : [];
    return InpformsList;
  }

  Future<int> addForms(
      InputForms form,
      ) async {
    var db = await instance.db;
    return await db!.insert(
      'getForm',
      form.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future delDb() async {
    final db = await instance.db;
    db!.delete('getForm');
    db.delete('showForm');
    print('DONE');
  }
  Future delFormData() async {
    final db = await instance.db;
    db?.delete('showForm');
    print('DONE');
  }


  int cnt = 0;
  Future<int> getCount() async {
    Database? db = await this.db;
    var result = await db!.query('getForm');
    int count = result.length;
    cnt = count;
    print(cnt);
    return count;
  }

  Future<int> addOPForms(OutputForms form, ctx) async {
    var check = false;
    var db = await instance.db;
    check = !check;
    if (check == true) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Added')));
    }

    return await db!.insert(
      'showForm',
      form.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<OutputForms>> getOPForms() async {
    var db = await instance.db;
    var forms = await db!.query(
      'showForm',
      columns: [
        'formId',
        'formname',
        'dataOutput',
      ],
    );
    List<OutputForms> formsList = forms.isNotEmpty
        ? forms.map((e) => OutputForms.fromMap(e)).toList()
        : [];
    return formsList;
  }





  Future<int> addProducts(
    Product1 add,
  ) async {
    var db = await instance.db;
    print('added products');
    return await db!.insert(
      'products',
      add.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> addRoutes(
    Routes add,
  ) async {
    var db = await instance.db;
    print('added Routes');
    return await db!.insert(
      'routes',
      add.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> addOfflineTrackingData(
    TrackingService add,
  ) async {
    var db = await instance.db;
    return await db!.insert(
      'trackingService',
      add.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> addAddress(
    Address add,
  ) async {
    var db = await instance.db;
    print('added address');
    return await db!.insert(
      'address',
      add.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> addVaria(
    Variations add,
  ) async {
    var db = await instance.db;
    print('added variations');
    return await db!.insert(
      'variations',
      add.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> addRout(
    User_Routes add,
  ) async {
    var db = await instance.db;
    print('added User Routes');
    return await db!.insert(
      'user_routes',
      add.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Variations>> getVariationId(
      {required String prodId, required String color}) async {
    var db = await instance.db;
    print("SELECT * FROM nelson01.variations WHERE product_id = " +
        prodId +
        " and colors = '$color'");
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM variations WHERE product_id = " +
            prodId +
            " and colors = '$color'");
    print(maps.length);
    return List.generate(maps.length, (i) {
      return Variations(
        id: maps[i]['id'].toString(),
        productId: maps[i]['product_id'],
        variationId: maps[i]['variation_id'],
        name: maps[i]['name'],
        variationName: maps[i]['variation_name'],
        size: maps[i]['size'],
        color_id: maps[i]['color_id'],
        colors: maps[i]['colors'],
        price: maps[i]['price'],
        price2: maps[i]['price2'],
        price3: maps[i]['price3'],
        price4: maps[i]['price4'],
        price5: maps[i]['price5'],
        price6: maps[i]['price6'],
        price7: maps[i]['price7'],
      );
    });
  }

  Future<List<Variations>> getVariationP({required String prodId}) async {
    var db = await instance.db;
    print("SELECT * FROM variations WHERE product_id = " +
        prodId +
        " order by colors asc");
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM variations WHERE product_id = " +
            prodId +
            " order by colors asc");
    print(maps.length);
    return List.generate(maps.length, (i) {
      return Variations(
        id: maps[i]['id'].toString(),
        productId: maps[i]['product_id'],
        variationId: maps[i]['variation_id'],
        name: maps[i]['name'],
        variationName: maps[i]['variation_name'],
        size: maps[i]['size'],
        color_id: maps[i]['color_id'],
        colors: maps[i]['colors'],
        price: maps[i]['price'],
        price2: maps[i]['price2'],
        price3: maps[i]['price3'],
        price4: maps[i]['price4'],
        price5: maps[i]['price5'],
        price6: maps[i]['price6'],
        price7: maps[i]['price7'],
      );
    });
  }

  Future<List<Variation_n>> getVariationPr({required String prodId}) async {
    var db = await instance.db;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Samad____"+prefs.getString('region').toString());
    String que ="";
    if(prefs.getString('region').toString()=='1')
    {
      que = "SELECT colors,price||'-'||MAX(price) as price, MAX(CASE WHEN size = 'Drm' THEN price END ) as drmp,MAX(CASE WHEN size = 'Gln' THEN price END ) as glnp,MAX(CASE WHEN size = 'Qtr' THEN price END ) as qtrp, MAX(CASE WHEN size = 'Drm' THEN variation_id END ) as drm, MAX(CASE WHEN size = 'Gln' THEN variation_id END ) as gln, MAX(CASE WHEN size = 'Qtr' THEN variation_id END ) as qtr FROM variations where product_id = " +
          prodId +
          " GROUP BY color_id ;";
    }
    if(prefs.getString('region').toString()=='3')
      {
         que = "SELECT colors,price2||'-'||MAX(price2) as price, MAX(CASE WHEN size = 'Drm' THEN price2 END ) as drmp,MAX(CASE WHEN size = 'Gln' THEN price2 END ) as glnp,MAX(CASE WHEN size = 'Qtr' THEN price2 END ) as qtrp, MAX(CASE WHEN size = 'Drm' THEN variation_id END ) as drm, MAX(CASE WHEN size = 'Gln' THEN variation_id END ) as gln, MAX(CASE WHEN size = 'Qtr' THEN variation_id END ) as qtr FROM variations where product_id = " +
            prodId +
            " GROUP BY color_id ;";
      }
    if(prefs.getString('region').toString()=='4')
    {
      que = "SELECT colors,price3||'-'||MAX(price3) as price, MAX(CASE WHEN size = 'Drm' THEN price3 END ) as drmp,MAX(CASE WHEN size = 'Gln' THEN price3 END ) as glnp,MAX(CASE WHEN size = 'Qtr' THEN price3 END ) as qtrp, MAX(CASE WHEN size = 'Drm' THEN variation_id END ) as drm, MAX(CASE WHEN size = 'Gln' THEN variation_id END ) as gln, MAX(CASE WHEN size = 'Qtr' THEN variation_id END ) as qtr FROM variations where product_id = " +
          prodId +
          " GROUP BY color_id ;";
    }
    if(prefs.getString('region').toString()=='5')
    {
      que = "SELECT colors,price4||'-'||MAX(price4) as price, MAX(CASE WHEN size = 'Drm' THEN price4 END ) as drmp,MAX(CASE WHEN size = 'Gln' THEN price4 END ) as glnp,MAX(CASE WHEN size = 'Qtr' THEN price4 END ) as qtrp, MAX(CASE WHEN size = 'Drm' THEN variation_id END ) as drm, MAX(CASE WHEN size = 'Gln' THEN variation_id END ) as gln, MAX(CASE WHEN size = 'Qtr' THEN variation_id END ) as qtr FROM variations where product_id = " +
          prodId +
          " GROUP BY color_id ;";
    }
    if(prefs.getString('region').toString()=='6')
    {
      que = "SELECT colors,price5||'-'||MAX(price5) as price, MAX(CASE WHEN size = 'Drm' THEN price5 END ) as drmp,MAX(CASE WHEN size = 'Gln' THEN price5 END ) as glnp,MAX(CASE WHEN size = 'Qtr' THEN price5 END ) as qtrp, MAX(CASE WHEN size = 'Drm' THEN variation_id END ) as drm, MAX(CASE WHEN size = 'Gln' THEN variation_id END ) as gln, MAX(CASE WHEN size = 'Qtr' THEN variation_id END ) as qtr FROM variations where product_id = " +
          prodId +
          " GROUP BY color_id ;";
    }
    if(prefs.getString('region').toString()=='7')
    {
      que = "SELECT colors,price6||'-'||MAX(price6) as price, MAX(CASE WHEN size = 'Drm' THEN price6 END ) as drmp,MAX(CASE WHEN size = 'Gln' THEN price6 END ) as glnp,MAX(CASE WHEN size = 'Qtr' THEN price6 END ) as qtrp, MAX(CASE WHEN size = 'Drm' THEN variation_id END ) as drm, MAX(CASE WHEN size = 'Gln' THEN variation_id END ) as gln, MAX(CASE WHEN size = 'Qtr' THEN variation_id END ) as qtr FROM variations where product_id = " +
          prodId +
          " GROUP BY color_id ;";
    }
    if(prefs.getString('region').toString()=='8')
    {
      que = "SELECT colors,price7||'-'||MAX(price7) as price, MAX(CASE WHEN size = 'Drm' THEN price7 END ) as drmp,MAX(CASE WHEN size = 'Gln' THEN price7 END ) as glnp,MAX(CASE WHEN size = 'Qtr' THEN price7 END ) as qtrp, MAX(CASE WHEN size = 'Drm' THEN variation_id END ) as drm, MAX(CASE WHEN size = 'Gln' THEN variation_id END ) as gln, MAX(CASE WHEN size = 'Qtr' THEN variation_id END ) as qtr FROM variations where product_id = " +
          prodId +
          " GROUP BY color_id ;";
    }

    print(
        "SELECT colors,price||'-'||MAX(price) as price, MAX(CASE WHEN size = 'Drm' THEN price END ) as drmp,MAX(CASE WHEN size = 'Gln' THEN price END ) as glnp,MAX(CASE WHEN size = 'Qtr' THEN price END ) as qtrp, MAX(CASE WHEN size = 'Drm' THEN variation_id END ) as drm, MAX(CASE WHEN size = 'Gln' THEN variation_id END ) as gln, MAX(CASE WHEN size = 'Qtr' THEN variation_id END ) as qtr FROM variations where product_id = " +
            prodId +
            " GROUP BY color_id ;");
    final List<Map<String, dynamic>> maps = await db!.rawQuery(que);
    print("_______________" + maps.length.toString());
    return List.generate(maps.length, (i) {
      return Variation_n(
        colors: maps[i]['colors'],
        qtr: maps[i]['qtr'].toString(),
        drm: maps[i]['drm'].toString(),
        gln: maps[i]['gln'].toString(),
        qtrp: maps[i]['qtrp'].toString(),
        drmp: maps[i]['drmp'].toString(),
        glnp: maps[i]['glnp'].toString(),
        price: maps[i]['price'].toString(),
      );
    });
  }

  Future<List<Product1>> getProducts() async {
    // Get a reference to the database.
    var db = await instance.db;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db!.query('products');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Product1(
          id: maps[i]['id'],
          images: 'assets/images/paint.png',
          colors: maps[i]['colors'],
          category_id: maps[i]['category_id'],
          title: maps[i]['title'],
          sizes: maps[i]['sizes'],
          price: double.parse(maps[i]['price']),
          description: maps[i]['description'],
          isFavourite: true,
          isPopular: true);
    });
  }

  Future<List<Orders>> getOrders() async {
    // Get a reference to the database.
    var db = await instance.db;
    final List<Map<String, dynamic>> maps = await db!.query('orders');
    return List.generate(maps.length, (i) {
      return Orders(
          id: maps[i]['id'].toString(),
          category_id: maps[i]['category_id'],
          order_date: maps[i]['order_date'],
          total: maps[i]['total'],
          address_id: maps[i]['address_id'],
          payment_method: maps[i]['payment_method'],
          payment_method_title: maps[i]['payment_method_title'],
          order_items: maps[i]['order_items'],
          created_by: maps[i]['created_by'],
          remarks: maps[i]['remarks']);
    });
  }

  Future<int> getOrderCount() async {
    var db = await instance.db;
    var result = await db!.rawQuery('SELECT COUNT(*) FROM orders');
    int count = result.length;
    return count;
  }

  Future<List<Product1>> getCProducts(String id) async {
    // Get a reference to the database.
    var db = await instance.db;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db!.query('products', where: 'category_id = ?', whereArgs: [id]);
    print(maps.length);
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Product1(
          id: maps[i]['id'],
          images: 'assets/images/paint.png',
          colors: maps[i]['colors'],
          category_id: maps[i]['category_id'],
          title: maps[i]['title'],
          sizes: maps[i]['sizes'],
          price: double.parse(maps[i]['price']),
          description: maps[i]['description'],
          isFavourite: true,
          isPopular: true);
    });
  }

  Future<String> getCategory(String id) async {
    // Get a reference to the database.
    var db = await instance.db;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db!
        .rawQuery('SELECT category_name from categories where id = ' + id + '');
    print(maps[0]['category_name']);
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return maps[0]['category_name'].toString();
  }

  Future<List<Variation_n>> Searchbycolor(String str, String id) async {
    var db = await instance.db;
    String que="SELECT colors,price||'-'||MAX(price) as price, MAX(CASE WHEN size = 'Drm' THEN price END ) as drmp,MAX(CASE WHEN size = 'Gln' THEN price END ) as glnp,MAX(CASE WHEN size = 'Qtr' THEN price END ) as qtrp, MAX(CASE WHEN size = 'Drm' THEN variation_id END ) as drm, MAX(CASE WHEN size = 'Gln' THEN variation_id END ) as gln, MAX(CASE WHEN size = 'Qtr' THEN variation_id END ) as qtr FROM variations where product_id = " +
        id +
        " and colors like '%" +
        str +
        "%' GROUP BY color_id ";
    final List<Map<String, dynamic>> maps = await db!.rawQuery(que);
    print(maps.length);
    return List.generate(maps.length, (i) {
      return Variation_n(
        colors: maps[i]['colors'],
        qtr: maps[i]['qtr'].toString(),
        drm: maps[i]['drm'].toString(),
        gln: maps[i]['gln'].toString(),
        qtrp: maps[i]['qtrp'].toString(),
        drmp: maps[i]['drmp'].toString(),
        glnp: maps[i]['glnp'].toString(),
        price: maps[i]['price'],
      );
    });
  }

  Future<List<Product1>> SearchProducts(String str) async {
    // Get a reference to the database.
    var db = await instance.db;

    // Query the table for all The Dogs.
    print("SELECT * from products where title like '%?%'");
    final List<Map<String, dynamic>> maps = await db!
        .query("products", where: "title LIKE ?", whereArgs: ['%$str%']);
    print(maps.length);
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Product1(
          id: maps[i]['id'],
          images: 'assets/images/paint.png',
          colors: maps[i]['colors'],
          category_id: maps[i]['category_id'],
          title: maps[i]['title'],
          sizes: maps[i]['sizes'],
          price: double.parse(maps[i]['price']),
          description: maps[i]['description'],
          isFavourite: true,
          isPopular: true);
    });
  }

  Future<List<Address>> getAddress(routeID) async {
    // Get a reference to the database.
    var db = await instance.db;
    print("Samad____" + routeID);
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db!
        .rawQuery('SELECT * FROM address where user_id = ?', ["$routeID"]);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('id');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Address(
          id: maps[i]['id'].toString(),
          user_id: maps[i]['user_id'],
          first_name: maps[i]['first_name'],
          last_name: maps[i]['last_name'],
          address_a: maps[i]['address_a'],
          address_b: maps[i]['address_b'],
          state: maps[i]['state'],
          city: maps[i]['city'],
          post_code: maps[i]['post_code'],
          country: maps[i]['country'],
          email: maps[i]['email'],
          phone: maps[i]['phone'],
          created_by: user_id.toString(),
          status: maps[i]['status']);
    });
  }

  Future<int> delete() async {
    var db = await instance.db;
    return db!.delete('products');
  }

  Future<int> deleteUsers() async {
    var db = await instance.db;
    return db!.delete('users');
  }

  Future<int> deleteCat() async {
    var db = await instance.db;
    return db!.delete('categories');
  }

  Future<int> deleteRoute() async {
    var db = await instance.db;
    return db!.delete('routes');
  }

  Future<int> deletevariation() async {
    var db = await instance.db;
    return db!.delete('variations');
  }

  Future<int> deleteroutes() async {
    var db = await instance.db;
    return db!.delete('user_routes');
  }

  Future<int> deleteAddress() async {
    var db = await instance.db;
    return db!.delete('address');
  }

  Future<int> deleteOrders() async {
    var db = await instance.db;
    return db!.delete('orders');
  }

  Future<int> getTrackingCount() async {
    var db = await instance.db;
    var result = await db!.rawQuery('SELECT COUNT(*) FROM trackingService');
    int count = result.length;
    print('tracking length' + count.toString());
    return count;
  }

  Future<int> deleteTrackingData() async {
    var db = await instance.db;
    return db!.delete('trackingService');
  }

  Future<Product1> getProduct(int id) async {
    var db = await DatabaseHelper.instance.db;
    List<Map> maps =
        await db!.query('products', where: 'id = ?', whereArgs: [id]);
    return Product1(
        id: maps[0]['id'],
        images: 'assets/images/paint.png',
        colors: maps[0]['colors'],
        title: maps[0]['title'],
        category_id: maps[0]['category_id'],
        sizes: maps[0]['sizes'],
        price: double.parse(maps[0]['price']),
        description: maps[0]['description'],
        isFavourite: true,
        isPopular: true);

    // Product1 = data;
    // return data;
  }

  addCategories(Categories add) async {
    var db = await instance.db;
    print('Abdul added categories');
    var data = await db!.insert(
      'categories',
      add.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(data);
    return data;
  }

  Future<List<Categories>> getCatsFromLocal() async {
    var db = await instance.db;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM categories');

    return List.generate(maps.length, (i) {
      return Categories(
          id: maps[i]['id'].toString(),
          category_name: maps[i]['category_name']);
    });
  }

  Future<List<Routes>> getRoutes(user_id) async {
    var db = await instance.db;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT  r.* FROM user_routes ur  join routes r on r.id = ur.route_id where ur.user_id = ' +
            user_id.toString() +
            '');

    return List.generate(maps.length, (i) {
      return Routes(
          id: maps[i]['id'].toString(), route_name: maps[i]['route_name']);
    });
  }

  addUsers(Users add) async {
    var db = await instance.db;
    print('Abdul added users');
    var data = await db!.insert(
      'users',
      add.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(data);
    return data;
  }

  addOrders(Orders add) async {
    var db = await instance.db;
    print('Abdul Uploaded Orders');
    var data = await db!.insert(
      'orders',
      add.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(data);
    return data;
  }

  Future<Users> login(String email, String pass) async {
    var db = await instance.db;
    print('User Login');
    print("SELECT * FROM users where email = '$email' and password = '$pass'");
    List<Map> maps = await db!.rawQuery(
        "SELECT * FROM users where email = '$email' and password = '$pass'");
    return Users(
        id: maps[0]['id'].toString(),
        name: maps[0]['name'],
        privilege: maps[0]['privilege'],
        login: maps[0]['login'],
        password: maps[0]['password'],
        status: maps[0]['status'],
        description: maps[0]['description'],
        address: maps[0]['address'],
        telephone: maps[0]['telephone'],
        email: maps[0]['email'],
        routeId: maps[0]['route_id'],
        duty_in: maps[0]['duty_in'],
        duty_out: maps[0]['duty_out'],
        interval: maps[0]['interval'],
        fieldAgent: maps[0]['field_agent']);
  }

  Future<Users> getUserById(id) async {
    var db = await instance.db;
    print('User Login');
    print("SELECT * FROM users where id = '$id'");
    List<Map> maps = await db!.rawQuery("SELECT * FROM users where id = '$id'");
    return Users(
        id: maps[0]['id'].toString(),
        name: maps[0]['name'],
        privilege: maps[0]['privilege'],
        login: maps[0]['login'],
        password: maps[0]['password'],
        status: maps[0]['status'],
        description: maps[0]['description'],
        address: maps[0]['address'],
        telephone: maps[0]['telephone'],
        email: maps[0]['email'],
        routeId: maps[0]['route_id'],
        duty_in: maps[0]['duty_in'],
        duty_out: maps[0]['duty_out'],
        interval: maps[0]['interval'],
        fieldAgent: maps[0]['field_agent']);
  }

  postAddress() async {
    var db = await instance.db;
    print("SELECT * FROM address where status = 0");
    int maps = await db!
        .rawUpdate('UPDATE address SET status = ? WHERE status = ?', [1, 0]);
    return maps;
  }

  Future<List<Address>> getAddress1() async {
    var db = await instance.db;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM address WHERE status = 0');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('id');
    return List.generate(maps.length, (i) {
      return Address(
          id: maps[i]['id'].toString(),
          user_id: maps[i]['user_id'],
          first_name: maps[i]['first_name'],
          last_name: maps[i]['last_name'],
          address_a: maps[i]['address_a'],
          address_b: maps[i]['address_b'],
          state: maps[i]['state'],
          city: maps[i]['city'],
          post_code: maps[i]['post_code'],
          country: maps[i]['country'],
          email: maps[i]['email'],
          phone: maps[i]['phone'],
          created_by: user_id.toString(),
          status: maps[i]['status']);
    });
  }

  Future<int> deleteOneLocation(id) async {
    var db = await instance.db;
    var del = db!.delete('trackingService', where: 'id = ?', whereArgs: [id]);
    print('Deleting' + del.toString());
    return del;
  }
}
