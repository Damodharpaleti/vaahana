class PickupkissanOrders {
  PickupkissanOrders({
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
    this.latitude,
    this.longitude,
    this.status,
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
  String? latitude;
  String? longitude;
  List<ProductList>? productList;
  String? status;

  factory PickupkissanOrders.fromJson(Map<String, dynamic> json) =>
      PickupkissanOrders(
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
        latitude: json["latitude"],
        longitude: json["longitude"],
        productList: List<ProductList>.from(
            json["productList"].map((x) => ProductList.fromJson(x))),
        status: json["status"],
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
        "longitude": longitude,
        "latitude": latitude,
        "productList": productList?.map((x) => x.toJson()).toList() ?? [],
        "status": status,
      };
}

class ProductList {
  ProductList({
    this.productId,
    this.productCode,
    this.productName,
    this.priceId,
    this.price,
    this.marketPrice,
    this.priceMinQuantity,
    this.cityId,
    this.brandname,
    this.numOfItems,
    this.totalPrice,
  });

  int? productId;
  String? productCode;
  String? productName;
  String? price;
  String? marketPrice;
  int? priceMinQuantity;
  String? brandname;
  int? priceId;
  int? cityId;
  String? numOfItems;
  String? totalPrice;

  ProductList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productCode = json['productCode'];
    productName = json['productName'];
    price = json['price'].toString();
    marketPrice = json['marketPrice'].toString();
    priceMinQuantity = json['priceMinQuantity'];
    brandname = json['brandname'];
    priceId = json['priceId'];
    cityId = json['cityId'];
    numOfItems = json['numOfItems'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productCode': productCode,
      'productName': productName,
      'price': price,
      'marketPrice': marketPrice,
      'priceMinQuantity': priceMinQuantity,
      'brandname': brandname,
      'priceId': priceId,
      'cityId': cityId,
      'numOfItems': numOfItems,
      'totalprice': totalPrice
    };
  }
}
