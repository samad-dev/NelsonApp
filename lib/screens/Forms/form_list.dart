import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Database/DatabaseHelper.dart';
import '../../model/inputFormModel.dart';
import '../../widget/const.dart';
import 'formPage.dart';

class OurFormPage extends StatefulWidget {
  const OurFormPage({Key? key}) : super(key: key);

  @override
  State<OurFormPage> createState() => _OurFormPageState();
}

class _OurFormPageState extends State<OurFormPage> {
  int count = 0;
  int ids = -1;
  List selectdata = List<String>.empty(growable: true);
  var mySelection;
  List<TextEditingController> controllerList = [];
  List<String> mobNo = List<String>.empty(growable: true);
  List radiotdata = List<String>.empty(growable: true);


  String kw = '';



  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          backgroundColor: Color(0xfffd80031),
          // actions: [
          //   TextButton(
          //       style: ButtonStyle(
          //           foregroundColor: MaterialStatePropertyAll(Colors.white)),
          //       onPressed: () {
          //         setState(() {});
          //       },
          //       child: Text('Load Forms'))
          // ],
          title: Text('Forms'),
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 500));
            setState(() {
            });
          },
          color: Colors.white,
          backgroundColor: Color(0xfffd80031),
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Column(
              children: [
                /*TextField(
                  onChanged: (value) {
                    setState(() {
                      kw = value;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: 'Search..'),
                ),*/
                Expanded(
                    child: FutureBuilder(
                        future: DatabaseHelper.instance.getInputForms(),
                        builder: (context,
                            AsyncSnapshot<List<InputForms>> snapshot) {
                          if (!snapshot.hasData) {
                            return Text('No Data found');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: ListTile(
                                        title: Center(
                                            child: Text(snapshot
                                                .data![index].formName)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        tileColor: Colors.grey[300],
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OurLocal(
                                                        id: snapshot
                                                            .data![index]
                                                            .formId, name: snapshot.data![index].formName,
                                                      )));
                                        }),
                                  );
                                });
                          }
                        })),
                TextButton(
                  onPressed: () {
                    DatabaseHelper.instance.delDb();
                    setState(() {});
                  },
                  child: Text('Delete DataBase'),
                ),
              ],
            ),
          ),
        ));
  }
}
