class PackageModel{
  String? documentId;
  String? title;
  String? description;
  String? thumbNail;
  String? price;
  String? discountAmount;
  List<dynamic>? size;
  List<dynamic>? colors;
  List<dynamic>? image;
  String? date;
  String? id;
  String? quantity;
  String? status;
  PackageModel({
    this.documentId,
    this.title,
    this.description,
    this.thumbNail,
    this.discountAmount,
    this.price,
    this.size,
    this.colors,
    this.image,
    this.date,
    this.id,
    this.quantity,
    this.status
  });
}