class LoginResponse {
  LoginResponse({
    this.company,
    this.emailId,
    this.employeeId,
    this.firstName,
    this.lastName,
    this.location,
    this.middleName,
    this.mobileNumber,
    this.telephoneNumber,
    this.resetPassword,
    this.address,
    this.token,
  });

  String company;
  String emailId;
  String employeeId;
  String firstName;
  String lastName;
  String location;
  String middleName;
  String mobileNumber;
  String telephoneNumber;
  String resetPassword;
  Address address;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        company: json["company"],
        emailId: json["emailId"],
        employeeId: json["employeeId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        location: json["location"],
        middleName: json["middleName"],
        mobileNumber: json["mobileNumber"],
        telephoneNumber: json["telephoneNumber"],
        resetPassword: json["resetPassword"],
        address: Address.fromJson(json["address"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "company": company,
        "emailId": emailId,
        "employeeId": employeeId,
        "firstName": firstName,
        "lastName": lastName,
        "location": location,
        "middleName": middleName,
        "mobileNumber": mobileNumber,
        "telephoneNumber": telephoneNumber,
        "resetPassword": resetPassword,
        "address": address.toJson(),
        "token": token,
      };
}

class Address {
  Address({
    this.address1,
    this.address2,
    this.city,
    this.pinCode,
    this.state,
  });

  String address1;
  String address2;
  String city;
  int pinCode;
  String state;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address1: json["address1"],
        address2: json["address2"],
        city: json["city"],
        pinCode: json["pinCode"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "address1": address1,
        "address2": address2,
        "city": city,
        "pinCode": pinCode,
        "state": state,
      };
}

class UserdatafromDB {
  String firstName, lastName, mobileNumber, address1, address2, city, state;
  String token;
  int pinCode;
  dynamic id;

  UserdatafromDB(
      this.id,
      this.firstName,
      this.lastName,
      this.address1,
      this.address2,
      this.state,
      this.city,
      this.pinCode,
      this.mobileNumber,
      this.token);

  UserdatafromDB.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    firstName = map["firstName"];
    lastName = map["lastName"];
    address1 = map["address1"];
    address2 = map["address2"];
    state = map["state"];
    city = map["city"];
    pinCode = map["pinCode"];
    mobileNumber = map["mobileNumber"];
    token = map["token"];
  }
}
