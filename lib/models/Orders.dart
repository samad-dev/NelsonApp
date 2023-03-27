class Orders {
  Orders({
    this.id,
    required this.category_id,
    required this.order_date,
    required this.total,
    required this.address_id,
    required this.payment_method,
    required this.payment_method_title,
    required this.order_items,
    required this.created_by,
    required this.remarks,
  });

  String? id;
  String category_id;
  String order_date;
  String total;
  String address_id;
  String payment_method;
  String payment_method_title;
  String order_items;
  String created_by;
  String remarks;


  factory Orders.fromMap(Map<String, dynamic> json) => Orders(
    id: json["id"],
    category_id: json["category_id"],
    order_date: json["order_date"],
    total: json["total"],
    address_id: json["address_id"],
    payment_method: json["payment_method"],
    payment_method_title: json["payment_method_title"],
    order_items: json["order_items"],
    created_by: json["created_by"],
    remarks: json["remarks"],

  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "category_id": category_id,
    "order_date": order_date,
    "total": total,
    "address_id": address_id,
    "payment_method": payment_method,
    "payment_method_title": payment_method_title,
    "order_items": order_items,
    "created_by": created_by,
    "remarks": remarks,
  };
}
