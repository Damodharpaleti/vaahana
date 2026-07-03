class addDriverDetailsModel {
  String? mobileNumber;
  String? emailId;
  String? firstName;
  String? lastName;
  String? location;
  String? address;
  String? transporterMobNum;
  String? state;
  String? pinCode;
  String? dlNumber;

  addDriverDetailsModel(
      {this.mobileNumber,
      this.emailId,
      this.firstName,
      this.lastName,
      this.location,
      this.address,
      this.transporterMobNum,
      this.state,
      this.pinCode,
      this.dlNumber});

  addDriverDetailsModel.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    emailId = json['emailId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    location = json['location'];
    address = json['address'];
    transporterMobNum = json['transporterMobNum'];
    state = json['state'];
    pinCode = json['pinCode'];
    dlNumber = json['dlNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobileNumber'] = this.mobileNumber;
    data['emailId'] = this.emailId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['location'] = this.location;
    data['address'] = this.address;
    data['transporterMobNum'] = this.transporterMobNum;
    data['state'] = this.state;
    data['pinCode'] = this.pinCode;
    data['dlNumber'] = this.dlNumber;
    return data;
  }
}











// class addDriverDetailsModel {
//   String transPortMobNumber;
//   String driverMobNumber;
//   String dlNumber;

//   addDriverDetailsModel(
//       {this.transPortMobNumber, this.driverMobNumber, this.dlNumber});

//   addDriverDetailsModel.fromJson(Map<String, dynamic> json) {
//     transPortMobNumber = json['TransPortMobNumber'];
//     driverMobNumber = json['driverMobNumber'];
//     dlNumber = json['dlNumber'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['TransPortMobNumber'] = this.transPortMobNumber;
//     data['driverMobNumber'] = this.driverMobNumber;
//     data['dlNumber'] = this.dlNumber;
//     return data;
//   }
// }
