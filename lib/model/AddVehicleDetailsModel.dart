class AddVehicleDetailsModel {
  String? transportMobNumber;
  String? driverMobNumber;
  String? vehicleName;
  String? vehicleNumber;
  String? rcNumber;

  AddVehicleDetailsModel(
      {this.transportMobNumber,
      this.driverMobNumber,
      this.vehicleName,
      this.vehicleNumber,
      this.rcNumber});

  AddVehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    transportMobNumber = json['transportMobNumber'];
    driverMobNumber = json['driverMobNumber'];
    vehicleName = json['vehicleName'];
    vehicleNumber = json['vehicleNumber'];
    rcNumber = json['rcNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transportMobNumber'] = this.transportMobNumber;
    data['driverMobNumber'] = this.driverMobNumber;
    data['vehicleName'] = this.vehicleName;
    data['vehicleNumber'] = this.vehicleNumber;
    data['rcNumber'] = this.rcNumber;
    return data;
  }
}
