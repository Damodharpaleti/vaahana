class User {
  User({
    this.name,
    this.nearbyCity,
    this.address,
    this.city,
    this.state,
    this.pinCode,
    this.dlNumber,
    this.mobileNumber,
    this.acessCode,
  });

  String? name;
  String? nearbyCity;
  String? address;
  String? city;
  String? state;
  String? pinCode;
  String? dlNumber;
  String? mobileNumber;
  String? acessCode;

  factory User.fromJson(Map<String, dynamic> json) => User(
      name: json["name"],
      nearbyCity: json["nearbyCity"],
      address: json["address"],
      city: json["city"],
      state: json["state"],
      pinCode: json["pinCode"],
      dlNumber: json["dlNumber"],
      mobileNumber: json["mobileNumber"],
      acessCode: json["acessCode"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> userjson = {};
    userjson.addAll({
      "name": name,
      "nearbyCity": nearbyCity,
      "address": address,
      "city": city,
      "dlNumber": dlNumber,
      "state": state,
      "pinCode": pinCode,
      "mobileNumber": mobileNumber,
      "acessCode": acessCode,

      // "roleDetails": List<dynamic>.from(roleDetails.map((x) => x.toJson())),
    });
    return userjson;
  }
}

class RoleDetail {
  RoleDetail({
    this.name = "ROLE_SUYOGA",
    this.id = 4,
    this.roleDescription = "suyoga User",
  });

  String name = "ROLE_SUYOGA";
  int id = 4;
  String roleDescription = "suyoga User";

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "roleDescription": roleDescription,
      };
}
