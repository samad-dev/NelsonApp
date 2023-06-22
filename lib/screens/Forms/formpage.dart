import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:select_form_field/select_form_field.dart';
import '../../Database/DatabaseHelper.dart';
import '../../model/OPFormModel.dart';
import '../../model/inputFormModel.dart';
import '../../widget/const.dart';


class OurLocal extends StatefulWidget {
  final id;
  final name;

  OurLocal({Key? key, required this.id,required this.name}) : super(key: key);

  @override
  State<OurLocal> createState() => _OurLocalState();
}

class _OurLocalState extends State<OurLocal> {
  int ids = -1;
  List<String> hiddendata = List<String>.empty(growable: true);
  var mySelection;
  var txt;
  var data;
  String _singleValue = "Text alignment right";
   String _verticalGroupValue = '';
  final Map myCategoryDynamic = {};

  List<String> selectedOptions = [];
  late List<InputForms> data2;
  List<TextEditingController> controllerList = [];
  Map<String, dynamic> myText = {};
  Map<String, dynamic> jsonData = {};
  List<Map<String, dynamic>> dataList = [];
  List header = List<String>.empty(growable: true);
  List txt1 = List<String>.empty(growable: true);
  List Buttons = List<String>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    var xyz = widget.id;
    var name = widget.name;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          backgroundColor: Color(0xfffd80031),
          title: Text(name),
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FutureBuilder<List<InputForms>>(
                  future: DatabaseHelper.instance.getOneFor(widget.id),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var abc =
                            json.decode(snapshot.data![index].apiResp);
                            List<dynamic> rellyAStringList = abc;
                            for (var i in rellyAStringList) {
                              controllerList.add(TextEditingController());

                            }
                            return Container(
                              child: SingleChildScrollView(
                                physics: ScrollPhysics(),
                                child: Column(children: [
                                  ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: rellyAStringList.length,
                                      itemBuilder: (context, ind) {
                                        return rowFunction(
                                            fName:
                                            snapshot.data![index].formName,
                                            index: ind,
                                            type: rellyAStringList[ind]['type'],
                                            name: rellyAStringList[ind]['name'],
                                            value: rellyAStringList[ind]
                                            ['value'],
                                            values: rellyAStringList[ind]
                                            ['values'],
                                            subtype: rellyAStringList[ind]
                                            ['subtype'],
                                            label: rellyAStringList[ind]
                                            ['label'],
                                            required: rellyAStringList[ind]
                                            ['required'],
                                            placeholder: rellyAStringList[ind]
                                            ['placeholder'],
                                            submitLabel: rellyAStringList[ind]
                                            ['submitLabel'],
                                            cancelLabel: rellyAStringList[ind]
                                            ['cancelLabel']);
                                      }),
                                ]),
                              ),
                            );
                          });
                    } else {
                      return Text('No data');
                    }
                  }),
                ),
              ),
              TextButton(
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Outputpage()));
                  },
                  child: Text('Check Data'))
            ],
          ),
        ),
      ),
    );
  }

  Widget rowFunction({
    required index,
    required fName,
    required type,
    required name,
    required value,
    required values,
    required subtype,
    required label,
    required required,
    required placeholder,
    required submitLabel,
    required cancelLabel,
  }) {
    if (type == "header") {
      return Container(
        child: Text(
          label,
          style: TextStyle(fontSize: 28,),
        ),
      );
    }
    else if (type == "text") {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label cannot be empty!';
            }
          },
          controller: controllerList[index],
          obscureText: subtype == "password" ? true : false,
          decoration: InputDecoration(
            labelText: label,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          onSaved: (value) {
            myText.addAll({label: controllerList[index].text});
          },
          onFieldSubmitted: (val) {
            myText.addAll({label: controllerList[index].text});
          },
          onChanged: ((value) {
            myText.addAll({label: controllerList[index].text});
            setState(() {});
          }),
        ),
      );
    }
    else if (type == "radio-group") {
      String jsonString = values.toString();
      List<String> sa = [];
      // Remove square brackets at the beginning and end to get the inner content
      String innerJson = jsonString.substring(1, jsonString.length - 1);

      // Split the string into individual key-value pairs
      List<String> keyValuePairs = innerJson.split(',');

      // Extract the values and wrap them in inverted commas
      List<String> val = keyValuePairs.map((pair) {
        // Remove whitespace and curly braces from the key-value pair
        String cleanedPair = pair.trim().replaceAll('{', '').replaceAll('}', '');
        // Split the cleaned pair into key and value
        List<String> parts = cleanedPair.split(':');
        String value = parts[1].trim();
        return '$value';
      }).toList();
      // _verticalGroupValue = List.generate(val.length, (index) =>'Other');
  String value1;
      // print(val.toSet().toList().toString());
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18),
            ),
            RadioGroup<String>.builder(
              groupValue: _verticalGroupValue,
              onChanged: (va) => setState(() {
                _verticalGroupValue = va!;
                // _verticalGroupValue = va! as List<String>;

                // selectedOptions[index] = _verticalGroupValue;
                  myText.addAll({label: va});
                print(myText);
              }),
              items: val.toSet().toList(),
              itemBuilder: (item) => RadioButtonBuilder(
                item,
              ),
            ),
          ],
        ),
      );
    }
    else if (type == "select") {
      var sa = json.encode(values);

      List<Map<String, dynamic>> convertedList = jsonDecode(sa).cast<Map<String, dynamic>>();

      print(convertedList);
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: SelectFormField(
          type: SelectFormFieldType.dropdown,
          decoration: InputDecoration(
            labelText: label,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          labelText: label,
          items: convertedList,
          onChanged: (val) => {
            myText.addAll({label: val})
            },
          onSaved: (val) => {
            myText.addAll({label: val})
          },
        ),
      );
    }
    else if (type == "Buttons") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Constants.mainColor),
            onPressed: myText.isNotEmpty
                ? () {
              dataList.add(myText);
              print(dataList.toString());
              // myText.forEach((key, value) {
              //   jsonData['"$key"'] = value is String ? '"$value"' : value;
              // });
              // String jsonString = jsonEncode(jsonData);

              // print(jsonString);
              DatabaseHelper.instance.addOPForms(
                  OutputForms(formId:widget.id,formname: fName, dataOutput: dataList.toString()),
                  context);
            }
                : () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please Fill All Fields'))),
            child: Text(submitLabel)),
      );
    }
    // else if (type == "image") {
    //   File? image;
    //   Future pickImg(source) async {
    //    final img = await ImagePicker().pickImage(source: source);
    //    if(img == null)
    //      return;
    //    final imgTemp = File(img.path);
    //    image = imgTemp;
    //
    //
    //   }
    //   return Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 10.0),
    //     child: Column(
    //       children: [
    //         ElevatedButton(
    //           style: ElevatedButton.styleFrom(
    //               backgroundColor: Colors.white, ),
    //           onPressed: () => pickImg(ImageSource.camera),
    //           child: Row(
    //             children: [Icon(Icons.camera_alt_outlined),
    //             SizedBox(width: 20,),
    //               Text('Camera')
    //             ],
    //           ),
    //         ),
    //         ElevatedButton(
    //           style: ElevatedButton.styleFrom(
    //               backgroundColor: Colors.white,),
    //           onPressed: () => pickImg(ImageSource.gallery),
    //           child: Row(
    //             children: [Icon(Icons.file_upload_outlined),
    //               SizedBox(width: 20,),
    //               Text('Upload Image')
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }
    else {
      return Text('Form: $name');
    }
  }
}
