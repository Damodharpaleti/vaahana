class GetPartnerscityList {
  int? id;
  String? city;

  GetPartnerscityList({
    this.id,
    this.city,
  });

  GetPartnerscityList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
  }
}
