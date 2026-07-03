class GetPinocodeListModel {
  GetPinocodeListModel({
    this.id,
    this.postalcode,
    this.mobileNumber,
    this.vendorName,
    this.partnerName,
    this.partnerMobNum,
    this.address,
  });

  int? id;
  String? postalcode;
  String? mobileNumber;
  String? vendorName;
  String? partnerName;
  String? partnerMobNum;
  String? address;

  factory GetPinocodeListModel.fromJson(Map<String, dynamic> json) =>
      GetPinocodeListModel(
        id: json["id"],
        postalcode: json["postalcode"],
        mobileNumber: json["mobileNumber"],
        vendorName: json["vendorName"],
        partnerName: json["PartnerName"],
        partnerMobNum: json["PartnerMobNum"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postalcode": postalcode,
        "mobileNumber": mobileNumber,
        "vendorName": vendorName,
        "PartnerName": partnerName,
        "PartnerMobNum": partnerMobNum,
        "address": address,
      };
}
