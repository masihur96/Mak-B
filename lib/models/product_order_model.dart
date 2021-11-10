class ProductOrderModel{
  String? id;
  String? Area;
  String? hub;
  String? name;
  String? orderDate;
  String? orderNumber;
  String? phone;
  List<dynamic>? products;
  String? quantity;
  String? state;
  String? totalAmount;
  ProductOrderModel({
    this.id,
    this.Area,
    this.hub,
    this.name,
    this.orderDate,
    this.orderNumber,
    this.phone,
    this.products,
    this.quantity,
    this.state,
    this.totalAmount,
  });

}