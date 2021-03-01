class StatusUpdate {
  StatusUpdate({
    this.orderNumber,
    this.orderStatus,
    this.mobileNumber,
    this.accessCode,
  });

  String orderNumber;
  String orderStatus;
  String accessCode;
  String mobileNumber;

  factory StatusUpdate.fromJson(Map<String, dynamic> json) => StatusUpdate(
        orderNumber: json["orderNumber"],
        orderStatus: json["orderStatus"],
        mobileNumber: json["mobileNumber"],
        accessCode: json["accessCode"],
      );

  Map<String, dynamic> toJson() => {
        "orderNumber": orderNumber,
        "orderStatus": orderStatus,
        "accessCode": accessCode,
        "mobileNumber": mobileNumber,
      };
}
