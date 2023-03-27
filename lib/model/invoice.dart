import 'package:stylish/model/supplier.dart';
import 'customer.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final DateTime date;


  const InvoiceInfo({
    required this.description,
    required this.date,
  });
}

class InvoiceItem {
  final String title;
  final String color;
  final String size;
  final int quantity;
  final double unitPrice;

  const InvoiceItem({
    required this.title,
    required this.color,
    required this.size,
    required this.quantity,
    required this.unitPrice,
  });
}
