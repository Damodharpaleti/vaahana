import 'package:vaahana/components/globals.dart' as globals;

class Config {
  static String imageurl = "http://images.suyoga.co.in/grocery/";
  //Dev
  // static String url = "http://44.201.67.164:8087/vaahanaService/";
  // static String loginUrl = "http://44.201.67.164:8081/loginService/";
  // static String paymentservice = "http://44.201.67.164:8086/paymentservice/";

  static String addDrivers = "Vehicle/v1/addDriver";
  static String addVehicleDetails = "Vehicle/v1/addVehicleDetails";
  static String getDriversVehicleDetails = "Vehicle/v1/getdrivervehicle";
  static String getDriverDetails =
      "Vehicle/v1/getDriverDetails?userId=" + globals.GlobaluserId;
  static String getvehicleDetails =
      "Vehicle/v1/getvehicleDetails?userId=" + globals.GlobaluserId;

  //Testing keys
  // static String razorpaykey = 'rzp_test_X9fHWKNJQEDLeQ';
  // static String apiSecret = 'qKc8WdYJYmfXFXz8ewnjxryf';

  //production
  static String url = "https://api.suyoga.app/vaahanaService/";
  static String loginUrl = "https://api.suyoga.app/loginService/";
  static String paymentservice = "https://api.suyoga.app/paymentservice/";

//   static String url = "http://3.109.110.183:8087/vaahanaService/";
//   static String loginUrl = "http://3.109.110.183:8081/loginService/";
//   static String paymentservice = "http://3.109.110.183:8086/paymentservice/";

  //Live Production
  static String razorpaykey = 'rzp_live_quQx2b6nphH2AP';
  static String apiSecret = 'MIi5XR0ntDzUyn9JcR4BdXs1';

  static String regOtp = "user/v1/Regotp";
  static String userRegURL = "user/v1/registration";
  static String orders = 'Order/v1/getOrdersByuser';
  static String ordersatus = 'Order/v1/updateInvoice';
  static String cancelorder = 'Order/v1/orderCancel';
  static String dashboardImage =
      "http://images.suyoga.co.in/Company_website_images";
  static String login = "authenticate";
  static String otp = "user/v1/otp";
  static String forgotPassword = "user/v1/forgotPassword";
  static String getSamarpanaProduct = "samarpanaProduct/v1/getProducts";
  static String categoryUrl = "category/v1/details";
  static String useraddress = "user/v1/getuserAddress";
  static String timeslot = "category/v1/timeSolt";
  static String newaddress = "user/v1/adduserAddress";
  static String getOrderDetails = "Order/v1/getOrderDetails";

  static String placeOrderURL = "samarpanaProduct/v1/placeOrder";
  static String validatePincode = "category/v1/validatePostalCode";

  static String getwalbalance = "wallet/v1/getWalletBalance";
  static String rzpContact = "vendor/v1/addContactid";
  static String rzpbankid = "vendor/v1/addbankId";

  static String withdrawmoney = "vendor/v1/WithdrawMoney";
  static String wallethistory = "vendor/v1/getWalletTrasdetails";
  static String getvendorbankdata = "vendor/v1/getaccountdetails";
  static String accountHistory = "vendor/v1/getAccountTrasdetails";
  static String getPicodeList = "Vehicle/v1/getVendorPincodeList";
  static String getPartnercityist = "Vehicle/v1/getPartnerscity";
  static String driverRegister = "Vehicle/v1/addDriver";
  static String addKissanPincode = "Vehicle/v1/addKissanPincode";

  static String updatePassword = "user/v1/updatePassword";
  static String loginOtp = "user/v1/loginotp";
}
