class UserLogin {

  String? mobilenumber;
   String? emailaddress;
   String? password;
  UserLogin(
      {

        this.mobilenumber,
         this.emailaddress,
         this.password,

      });

  UserLogin.fromJson(Map<String, dynamic> json) {


    mobilenumber = json['mobilenumber'];
     emailaddress =json['emailaddress'];

     password =json['password'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();


    data['mobilenumber'] = this.mobilenumber;
     data['emailaddress'] = this.emailaddress;
    data['password'] = this.password;




    return data;
  }
}



