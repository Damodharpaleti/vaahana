class Config {
  static String imageurl = "http://images.suyoga.co.in/grocery/";
  //Dev
  //static String url = "http://44.192.46.200:8084/samarpanaService/";
  //production
  static String url = "http://13.233.187.96:8084/samarpanaService/";
  static String orders = 'Order/v1/getOrdersByuser';
  static String ordersatus = 'Order/v1/updateInvoice';

  //dev Login

  //static String loginUrl = "http://44.192.46.200:8081/loginService/";
  //production Login
  static String loginUrl = "http://13.233.187.96:8081/loginService/";
  static String dashboardImage =
      "http://images.suyoga.co.in/Company_website_images";
  static String login = "authenticate";
  static String otp = "user/v1/otp";
  static String forgotPassword = "user/v1/forgotPassword";
}
