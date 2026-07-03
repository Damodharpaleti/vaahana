class ForgotPasswordOTP {
  ForgotPasswordOTP({
    this.mobile,
    this.accessCode,
    this.message,
    this.statusCode,
  });

  String? mobile;
  String? accessCode;
  int? statusCode;
  String? message;

  factory ForgotPasswordOTP.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordOTP(
        mobile: json["mobile"],
        accessCode: json["accessCode"],
        message: json["message"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "accessCode": accessCode,
        "message": message,
        "statusCode": statusCode,
      };
}
