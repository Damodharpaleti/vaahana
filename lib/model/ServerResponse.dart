class ServerResponse {
  ServerResponse({
    this.message,
    this.statusCode,
  });

  String? message;
  int? statusCode;

  factory ServerResponse.fromJson(Map<String, dynamic> json) => ServerResponse(
        message: json["message"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "statusCode": statusCode,
      };
}
