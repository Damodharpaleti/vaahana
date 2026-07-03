class GetvehicleDetailsModel {
  String? transportName;
  String? vehicleNumber;
  String? driverName;
  String? vehicleName;
  String? rcNumber;
  bool? isActive;

  GetvehicleDetailsModel(
      {this.transportName,
      this.vehicleNumber,
      this.driverName,
      this.vehicleName,
      this.rcNumber,
      this.isActive});

  GetvehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    transportName = json['transportName'];
    vehicleNumber = json['vehicleNumber'];
    driverName = json['driverName'];
    vehicleName = json['vehicleName'];
    rcNumber = json['rcNumber'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transportName'] = this.transportName;
    data['vehicleNumber'] = this.vehicleNumber;
    data['driverName'] = this.driverName;
    data['vehicleName'] = this.vehicleName;
    data['rcNumber'] = this.rcNumber;
    data['isActive'] = this.isActive;
    return data;
  }
}
