import 'dart:io';
import 'package:intl/intl.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish/api/pdf_api.dart';

import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id")!;
    // DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String now = dateFormat.format(DateTime.now());

    final pdf = Document();
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final total = netTotal;
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                padding: const EdgeInsets.all(3.0),
                width: 17 * PdfPageFormat.cm,
                decoration:
                    BoxDecoration(border: Border.all(color: PdfColors.black)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Estimated_NO # CHLN${id}-${now.replaceAll(RegExp('[^A-Za-z0-9]'), '')}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                  Text("Messers: ${invoice.customer.address}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                  SizedBox(height: 3),
                                ]),
                            VerticalDivider(
                              width: 20*PdfPageFormat.point,
                              thickness: 1,
                              indent: 20,
                              endIndent: 0,
                              color: PdfColors.black,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${invoice.supplier.name}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal)),
                              ]
                            )
                          ])
                    ]),
              ),
            ]),
        /*Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                padding: const EdgeInsets.all(3.0),
                width: 8.5 * PdfPageFormat.cm,
                decoration:
                    BoxDecoration(border: Border.all(color: PdfColors.black)),
                child: Row(children: [
                  Column(children: [
                    Row(children: [
                      Text("Estimate_No #CHLN-2121",
                          style: TextStyle(fontWeight: FontWeight.normal)),
                      SizedBox(width: 10),
                      Text("Date ${DateFormat.yMd().format(invoice.info.date)}",
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ]),
                    SizedBox(height: 3),
                    Row(children: [
                      Text("Messers",
                          style: TextStyle(fontWeight: FontWeight.normal)),
                      SizedBox(width: 10),
                      Text("${invoice.customer.address}",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 12)),
                    ])
                  ])
                ]),
              ),
            ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    padding: const EdgeInsets.all(3.0),
                    width: 8.5 * PdfPageFormat.cm,
                    decoration: BoxDecoration(
                        border: Border.all(color: PdfColors.black)),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 1 * PdfPageFormat.cm),
                                      SizedBox(width: 6 * PdfPageFormat.cm),
                                      Text(invoice.supplier.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal)),
                                    ]),
                                SizedBox(height: 3),
                              ])
                        ]),
                  ),
                ])

            // buildInvoiceInfo(invoice.info),
          ],
        ),*/
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                padding: const EdgeInsets.all(3.0),
                width: 17 * PdfPageFormat.cm,
                decoration:
                    BoxDecoration(border: Border.all(color: PdfColors.black)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Remarks: ${invoice.supplier.address}",
                          style: TextStyle(fontWeight: FontWeight.normal)),

                    ]),
              ),
            ]),
        // SizedBox(height: 1 * PdfPageFormat.cm),
        // buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),

        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(children: [
                Text("Drums", style: TextStyle(fontWeight: FontWeight.normal)),
                Text(
                    invoice.items
                        .where((element) => element.size == 'Drm')
                        .map((element) => element.quantity)
                        .fold<int>(0, (sum, quantity) => sum + quantity)
                        .toString(),
                    style: TextStyle(fontWeight: FontWeight.normal)),
                SizedBox(height: 3),
              ]),
              SizedBox(width: 10),
              Column(children: [
                Text("Gallons",
                    style: TextStyle(fontWeight: FontWeight.normal)),
                Text(
                    invoice.items
                        .where((element) => element.size == 'Gln')
                        .map((element) => element.quantity)
                        .fold<int>(0, (sum, quantity) => sum + quantity)
                        .toString(),
                    style: TextStyle(fontWeight: FontWeight.normal)),
                SizedBox(height: 3),
              ]),
              SizedBox(width: 10),
              Column(children: [
                Text("Quarter",
                    style: TextStyle(fontWeight: FontWeight.normal)),
                Text(
                    invoice.items
                        .where((element) => element.size == 'Qtr')
                        .map((element) => element.quantity)
                        .fold<int>(0, (sum, quantity) => sum + quantity)
                        .toString(),
                    style: TextStyle(fontWeight: FontWeight.normal)),
                SizedBox(height: 3),
              ]),
              SizedBox(width: 3 * PdfPageFormat.inch),
              Column(children: [
                Row(children: [
                  Text("Total",
                      style: TextStyle(fontWeight: FontWeight.normal)),
                  SizedBox(width: 1 * PdfPageFormat.cm),
                  Text(" Rs.${NumberFormat.decimalPattern().format(total)}",
                      style: TextStyle(fontWeight: FontWeight.normal)),
                  SizedBox(height: 3),
                ])
              ]),
            ]),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                padding: const EdgeInsets.all(3.0),
                width: 17 * PdfPageFormat.cm,
                decoration:
                    BoxDecoration(border: Border.all(color: PdfColors.black)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Amount In Words",
                          style: TextStyle(fontWeight: FontWeight.normal)),
                      Text(
                          NumberToWordsEnglish.convert(
                              int.parse(total.toStringAsFixed(0))),
                          style: TextStyle(fontWeight: FontWeight.normal)),
                      SizedBox(height: 3),
                    ]),
              ),
            ]),
        // buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.info),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: PdfColors.black)),
                child: Text("Estimated",
                    style: TextStyle(fontWeight: FontWeight.normal)),
              ),
              // buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(InvoiceInfo customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Printing Date:- ${DateFormat('yyyy-MM-dd kk:mm').format(customer.date)}",
              style: TextStyle(fontWeight: FontWeight.normal)),
          // Text(customer.address),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.description}';
    final titles = <String>[
      'Order Date:',
    ];
    final data = <String>[
      Utils.formatDate(info.date),
      paymentTerms,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimated Order',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Product', 'Pack', 'Qty', 'Rate', 'Net Amt'];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity;

      return [
        item.title,
        item.size,
        '${item.quantity}',
        '${NumberFormat.decimalPattern().format(item.unitPrice)}',
        'Rs.${NumberFormat.decimalPattern().format(total)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final total = netTotal;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          // Spacer(flex: 3),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Generated By"', value: invoice.customer.name),
          // SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
