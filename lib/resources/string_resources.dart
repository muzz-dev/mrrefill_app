class StringRes{
  static const String appname = "Mr.Refill";
  static const String apptitle = "Mr.Refill";
  static const String login = "Sign In";
  static const String username = "Username";
  static const String password = "Password";
  static const String email = "Email-Id";
  static const String mobileNumber = "Mobile Number";
  static const String companyname = "Company Name";
  static const String areaId = "Area Name";
  static const String gstnumber = "GST Number";
  static const String amount = "Amount";
  static const String paynow = "Pay Now";


  static const String myprofile = "My Profile";
  static const String changepassword = "Change Password";
  static const String confirmpassword = "Confirm Password";
  static const String exchangerequest = "Exchange Request";
  static const String sendrequest = "Send Request";
  static const String cartridgename = "Cartridge Name";
  static const String previousrequest = "Previous Request";
  static const String allocatedrequest = "Allocated Request";
  static const String requestdetails = "Request Details";
  static const String closerequest = "Close Request";
  static const String feedback = "Feedback";

  static const String name = "Name";
  static const String signintocontinue = "Please sign in to continue";
  static const String terms = "By sign in, you agree to our Terms and Conditions";
  static const String userlist = "Users";
  static const String registration = "Sign Up";
  static const String respondtorequest = "Reponse to Request";
  static const String updateusertext = "Update Information";
  static const String viewalluserstext = "View All User";
  static const String updateprofile = "Save Changes";
  static const String submit = "Submit";
}
class FontRes {
  static const String ProximaNova = "ProximaNova";
  static const String SFProText = "SFProText";
}

class Patterns {
  static const Pattern name = r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]';
  static const Pattern email =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const Pattern phonePattern = r'^(?:[+0]9)?[0-9]{9}$';
  static const Pattern moneyPattern = r'^\d*(\.\d{1,2})?$';
  static const Pattern weightKmPattern = r'^\d*(\.\d{1,3})?$';
}