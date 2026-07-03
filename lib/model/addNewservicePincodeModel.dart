class AddNewPincodes {
  String? postalcode;
  String? address1;
  String? mobileNumber;
  String? message;
  int? statusCode;

  AddNewPincodes({
    this.postalcode,
    this.address1,
    this.message,
    this.mobileNumber,
    this.statusCode,
  });

  AddNewPincodes.fromJson(Map<String, dynamic> json) {
    postalcode = json['postalcode'];
    address1 = json['address1'];
    message = json['message'];
    mobileNumber = json['mobileNumber'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postalcode'] = this.postalcode;
    data['address1'] = this.address1;
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['mobileNumber'] = this.mobileNumber;
    return data;
  }
}
