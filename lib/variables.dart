String server = "https://darkgoldenrod-beaver-652684.hostingersite.com/";

List<dynamic> products = [];
List<dynamic> productcart = [];
List<dynamic> purchased = [];
List<Map<String, dynamic>> receiptItems = [];

String editpname = "";
String editpstock = "";
String editpprice = "";
String editpid = "";
String editpimage = "";

String productReceipt = "";
String priceReceipt = "";
String priceTotal = "";
String quantityReceipt = "";
String dateReceipt = "";

bool systemLoading = false;
bool serverError = false;
bool addcartSuccess = false;

bool btnState = true;
