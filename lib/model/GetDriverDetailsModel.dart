class GetDriverDetailsModel {
  String? transportName;
  String? driverName;
  String? dlNumber;
  String? driverMobNumber;
  bool? isActive;

  GetDriverDetailsModel(
      {this.transportName,
      this.driverName,
      this.dlNumber,
      this.driverMobNumber,
      this.isActive});

  GetDriverDetailsModel.fromJson(Map<String, dynamic> json) {
    transportName = json['transportName'];
    driverName = json['driverName'];
    dlNumber = json['dlNumber'];
    driverMobNumber = json['driverMobNumber'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transportName'] = this.transportName;
    data['driverName'] = this.driverName;
    data['dlNumber'] = this.dlNumber;
    data['driverMobNumber'] = this.driverMobNumber;
    data['isActive'] = this.isActive;
    return data;
  }
}
