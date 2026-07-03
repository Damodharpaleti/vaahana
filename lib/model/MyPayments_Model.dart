import 'package:vaahana/model/PickupOrdersModel.dart';

class Myorders {
  Myorders({
    this.orderId,
    this.orderUserId,
    this.orderNumber,
    this.orderInvoiceNumber,
    this.orderStatus,
    this.orderFullPrice,
    this.orderDate,
    this.orderType,
    this.productList,
    this.address,
    this.timeslot,
  });

  int? orderId;
  String? orderUserId;
  String? orderNumber;
  String? orderInvoiceNumber;
  String? orderStatus;
  double? orderFullPrice;
  String? orderDate;
  String? orderType;
  String? address;
  String? timeslot;
  List<ProductList>? productList;

  factory Myorders.fromJson(Map<String, dynamic> json) => Myorders(
        orderId: json["orderId"],
        orderUserId: json["orderUserId"],
        orderNumber: json["orderNumber"],
        orderInvoiceNumber: json["orderInvoiceNumber"],
        orderStatus: json["orderStatus"],
        orderFullPrice: json["orderFullPrice"],
        orderDate: json["orderDate"],
        orderType: json["orderType"],
        address: json["address"],
        timeslot: json["timeslot"],
        productList: List<ProductList>.from(
            json["productList"].map((x) => ProductList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderUserId": orderUserId,
        "orderNumber": orderNumber,
        "orderInvoiceNumber": orderInvoiceNumber,
        "orderStatus": orderStatus,
        "orderFullPrice": orderFullPrice,
        "orderDate": orderDate,
        "orderType": orderType,
        "address": address,
        "timeslot": timeslot,
        "productList": productList?.map((x) => x.toJson()).toList() ?? [],
      };
}
