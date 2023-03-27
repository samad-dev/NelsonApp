class Cart_Check {
  int product_id;
  int variation_id;
  int quantity;
  String remarks;
  Cart_Check(this.product_id, this.quantity,this.variation_id, this.remarks);
  Map toJson() => {
    'product_id': product_id,
    'quantity': quantity,
    'variation_id':variation_id,
    'remarks':remarks,
  };
}