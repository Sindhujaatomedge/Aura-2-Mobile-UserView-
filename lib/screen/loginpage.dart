import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/loginmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/tokenmodel.dart';
import 'homepage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _loginkey = GlobalKey<FormState>();

  TextEditingController _emailController =TextEditingController();
  TextEditingController _passwordController =TextEditingController();
  TextEditingController _phoneController =TextEditingController();
  bool _isEmailMode = true;
  String _password ='';
  String _emailError = "";
  String _phoneError = "";
  String _message ='';
  String _emailexists ='';
  String _phoneNumberError ='';
  bool showTextField = false;
  bool hidePassword = true;
  UserLogin _userLoginModel = UserLogin();
  TokenModel _tokenModel = TokenModel();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose the FocusNode to avoid memory leaks
    super.dispose();
  }



  String _countryError ='The phone number Must be Country Code + valid';
  int valuecount =0;
  int specialCount =0;
  void clear(){
    _loginkey.currentState?.reset();
    _phoneController.text ='';
    _emailController.text ='';
    _passwordController.text='';
    _emailError='';
    _phoneError='';
    _phoneNumberError='';
    _password='';
    _message='';


  }

  void handleApiErrors(Map<String, dynamic> errors) {
    setState(() {

      _emailError = errors['emailaddress'] ?? "";
      _phoneError = errors['mobile-exists'] ?? "";
      _emailexists=errors['email-exists'] ?? "";
      _phoneNumberError=errors['mobilenumber'] ?? "";
      _password = errors['password'] ?? "";
      _message = errors['message']?? "";
      // _loginkey.currentState?.reset();
      _loginkey.currentState?.validate();

    });
  }
  void handleApi(Map<String, dynamic> errors) {
    setState(() {

      _emailError = errors['emailaddress'] ?? "";
      _phoneError = errors['mobile-exists'] ?? "";
      _emailexists=errors['email-exists'] ?? "";
      _phoneNumberError=errors['mobilenumber'] ?? "";
      _password = errors['password'] ?? "";
      _message = errors['message']?? "";
      //_loginkey.currentState?.reset();
      _loginkey.currentState?.validate();

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _passwordController.addListener(() {
      setState(() {
        _password = "";
        _message="";
      });
    });

    _phoneController.addListener(() {
      setState(() {
        _phoneError = "";
        _phoneNumberError="";
        _message='';
      });
    });

    _emailController.addListener(() {
      setState(() {
        _emailError = "";
        _emailexists = "";
        _message='';
      });

    });


  }
  Future<void> postdata(BuildContext context) async {

    print(_userLoginModel.mobilenumber);
    if ( _loginkey.currentState?.validate() ?? false) {

      final userLogin = UserLogin(
          mobilenumber:_phoneController.text,
          emailaddress: _emailController.text
      );

      // final url = Uri.parse('http://3.110.95.121:8080/verify-identifier');
      final url = Uri.parse('http://192.168.29.232:8080/verify-identifier');
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(userLogin.toJson()),


        );
        print(json.encode(userLogin.toJson()));

        if (response.statusCode == 200) {
          print(response.body);
          final Map<String, dynamic> message = json.decode(response.body);
          String orgid = message.toString();
          // org_id=message.toString();
          final SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString('orgid', orgid);

          //print(org_id);
          Map<String, dynamic> jsonData = json.decode(response.body);


          String orgidValue = jsonData['orgid'];
          // setState(() {
          //   _holidaymodel.orgid=orgidValue;
          // });
          print("details");
          print(orgidValue);
          setState(() {
            _tokenModel.orgid=orgidValue;
          });

          setState(() {
            showTextField = true;
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //        SnackBar(content: Text(response.body)),
          //      );



        } else if(response.statusCode == 400) {
          final Map<String,dynamic> errors = json.decode(response.body);
          // print(errors);
          // String messageString = errors['message'];
          // print("messageString:");
          // print(messageString);
          setState(() {
            handleApiErrors(errors);
          });
          // print(response.body);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(response.body)),
          // );
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
      }
    }
  }

  Future<void> login(BuildContext context) async {

    print(_userLoginModel.mobilenumber);
    if (_loginkey.currentState?.validate() ?? false) {
      final userLogin = UserLogin(
        mobilenumber: _phoneController.text,
        emailaddress: _emailController.text,
        password: _passwordController.text,
      );
      // final url = Uri.parse('http://100.24.56.198:8080/login');
      final url = Uri.parse('http://192.168.29.232:8080/login');
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(userLogin.toJson()),
        );
        print(json.encode(userLogin.toJson()));

        if (response.statusCode == 200) {


          showTextField;
          print(response.body);
          final Map<String, dynamic> message = json.decode(response.body);

          setState(() {
            showTextField = true;
            handleApiErrors(message);
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(response.body)),
          // );
          print(_tokenModel.orgid);


          // Extract the 'message' JSON string
          String messageString = message['message'];
          print("messageString:");
          print(messageString);

          // Decode the 'message' JSON string to get tokens
          Map<String, dynamic> decodedTokens = json.decode(messageString);

          // Extract tokens
          String accessToken = decodedTokens['access-token'];
          String refreshToken = decodedTokens['refresh-token'];
          _tokenModel.accessToken =decodedTokens['access-token'];
          _tokenModel.refreshToken = decodedTokens['refresh-token'];

          setState(() {
            _tokenModel.accessToken=accessToken;
            _tokenModel.refreshToken =refreshToken;
          });
          print("token");
          print(_tokenModel.accessToken );
          print(_tokenModel.refreshToken);

          // Save tokens to SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', accessToken);
          await prefs.setString('refresh_token', refreshToken);
          await prefs.setString('refresh_token', refreshToken);

          print('Tokens saved successfully!');

          // Retrieve tokens from SharedPreferences (Optional)
          String? savedAccessToken = prefs.getString('access_token');
          String? savedRefreshToken = prefs.getString('refresh_token');


          print('Saved Access Token: $savedAccessToken');
          print('Saved Refresh Token: $savedRefreshToken');


          String email= _emailController.text.split('@').first;
          print(email);
          await prefs.setString('emailname', email);
          //Navigator.push(context, MaterialPageRoute(builder: (context) => ViewHoliday(_tokenModel.orgid,savedAccessToken,savedRefreshToken,editholiday,holiday:holiday,)));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewHoliday()));
          _loginkey.currentState?.reset();
          clear();
          showTextField=false;
          // setState(() {
          //   clear();
          // });


          // Navigator.push(context, MaterialPageRoute(builder: (context) => HolidayPage()));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(email)));
           Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateDepartment()));



        }

        else {
          final Map<String, dynamic> message = json.decode(response.body);

          setState(() {
            handleApi(message);
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(response.body)),
          // );
        }
      } catch (e) {
        // Handle exceptions
        print('Error: $e');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFFCFCFC),
          body: SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 120.0, left: 10, right: 10),
          child: Center(
              child: Image.asset(
                              'assets/images/logo.png',
                              width: 102,
                              height: 32,
                            )),
        ),
        Padding(
          padding: const EdgeInsets.only(top:70.0),  // Adds padding around the container
          child: Container(
            width: 500,
            height: 600,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              boxShadow: const [
                BoxShadow(
                  color:Color(0xFF959DA5) ,
                  blurRadius: 1.0,
                  offset: Offset(.5,.5),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top:25.0),
                  child:
                  Text('Login',style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                  ),),
                ),
                const SizedBox(height: 10,),
                const Text("Please Choose Login Method",style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color:Color(0xFFD8D8D8) ,
                  fontWeight: FontWeight.w400,
                ),),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 135,

                      decoration: BoxDecoration(
                        color: Color(0xFFFCFCFC),
                        border: Border.all(color: Color(0xFFEAEAEA),
                        ),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        //  Image.asset('assets/images/gmail.svg'),
                          SvgPicture.asset(
                            'assets/images/gmail.svg',
                          ),
                          SizedBox(width: 10,),
                          const Center(
                            child: Text('Gmail',style: TextStyle(
                              fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF344054)
                            ),),
                          )
                        ],
                      ),


                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 135,
                        decoration: BoxDecoration(
                            color: Color(0xFFFCFCFC),
                          border: Border.all(color: Color(0xFFEAEAEA),),
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           // Image.asset('assets/images/outlook.png'),
                            SvgPicture.asset(
                              'assets/images/outlook.svg',
                            ),
                            SizedBox(width: 10,),
                            const Text('Outlook',style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF344054)
                            ),)
                          ],
                        ),
                      
                      
                      ),
                    )
                  ],

                ),
                SizedBox(height: 20,),
                const Row(children: [
                  Flexible(child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(indent: 4,endIndent: 4,color: Color(0xFFF2F4F7),thickness: 1,),
                  )),
                  Text('or',style: TextStyle(fontFamily: 'Poppins',fontSize: 14,color: Color(0xFF6E6E6E)),),
                  Flexible(child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(indent: 5,endIndent: 5,color: Color(0xFFF2F4F7),thickness: 1,),
                  )),
                ],),
                SizedBox(height: 20,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(

                      decoration: BoxDecoration(
                          color: Color(0xFFE4E7EC),
                          border: Border.all(
                            color: Color(0xFFE4E7EC)
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isEmailMode = true;
                                  showTextField =false;
                                  clear();
                                });
                              },
                              child: Container(width: 155,height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: _isEmailMode ? Colors.white : Colors.transparent,
                                  ),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _isEmailMode ? Icon(Icons.email_outlined,size: 18,color: Color(0xFF004AAD)) :Icon(Icons.email_outlined,size: 18,color: Color(0xFF98A2B3)),
                                      const SizedBox(width: 10,),
                                     _isEmailMode ? Text('Email',style: TextStyle(fontFamily: 'Poppins',fontSize: 14),):Text('Email',style: TextStyle(fontFamily: 'Poppins',fontSize: 14,color: Color(0xFF98A2B3)),),
                                    ],
                                  )),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isEmailMode = false;
                                  showTextField =false;
                                  clear();
                                });
                              },
                              child: Container(width: 155,height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: !_isEmailMode ? Colors.white : Colors.transparent,
                                  ),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      !_isEmailMode ? Icon(Icons.phone_outlined,size: 18,color: Color(0xFF004AAD)) :Icon(Icons.phone_outlined,size: 18,color: Color(0xFF98A2B3)),
                                      const SizedBox(width: 10,),
                                      !_isEmailMode ? Text('Phone',style: TextStyle(fontFamily: 'Poppins',fontSize: 14),):Text('Phone',style: TextStyle(fontFamily: 'Poppins',fontSize: 14,color: Color(0xFF98A2B3)),),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Form(
                  key: _loginkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      if(_isEmailMode) ...[
                        Padding(
                          padding: const EdgeInsets.all(17.0),
                          child:
                          GestureDetector(
                            onTap: (){
                              _focusNode.unfocus();
                            },
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true, // Enables the background color
                                fillColor: Color(0xFFF4F4F4), // Background color of the TextFormField
                                labelText: 'Email',
                                // suffix: TextButton(onPressed: (){}, child: Text('Change',style: TextStyle(fontSize:12,color: Colors.blue),)),
                                floatingLabelStyle: const TextStyle(
                                  color: Color(0xFFC5C5C5),
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400

                                ),
                                labelStyle: const TextStyle(
                                  color: Color(0xFFC5C5C5), // Default label color
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, // Adjust vertical padding for height
                                  horizontal: 15.0, // Adjust horizontal padding
                                ),
                                errorStyle: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFDC897C),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none, // No border when enabled
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF4F4F4), // Border color when focused
                                    width: .5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC897C), // Border color when error occurs
                                    width: 1,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC897C), // Border color when error occurs and focused
                                    width: 1,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black, // Text color for entered text
                                fontSize: 16, // Customize font size
                                fontFamily: 'Poppins', // Customize font family if needed
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email address';
                                }
                                final emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!emailPattern.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                // Handle state to update UI if required
                              },
                            ),
                          )
                          ,
                        ),
                        if(showTextField)

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: hidePassword,
                              validator: (value) {
                                if (_password.isNotEmpty) {
                                  return _password;
                                }
                                if (_message.isNotEmpty) {
                                  return _message;
                                }
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid password';
                                }
                                return null;
                              },

                              decoration: InputDecoration(
                                filled: true, // Enables the background color
                                fillColor: Color(0xFFF4F4F4), // Background color of the TextFormField
                                labelText: 'Password',
                                floatingLabelStyle: const TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400

                                ),
                                labelStyle: const TextStyle(
                                  color: Color(0xFFC5C5C5), // Default label color
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, // Adjust vertical padding for height
                                  horizontal: 12.0, // Adjust horizontal padding
                                ),
                                  suffixIcon: IconButton(
                                    icon: hidePassword
                                        ? Icon(Icons.visibility_off_outlined,)
                                        : Icon(Icons.visibility_outlined, ),
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                  ),

                                errorStyle: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFDC897C),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none, // No border when enabled
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF4F4F4), // Border color when focused
                                    width: .5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC897C), // Border color when error occurs
                                    width: 1,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC897C), // Border color when error occurs and focused
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),


                      ]
                      else
                        ...[
                          Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: TextFormField(
                              controller: _phoneController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9,+]")),
                              ],
                              validator: (value) {
                                if (_message.isNotEmpty) {
                                  return _message;
                                }
                                if (_phoneError.isNotEmpty) {
                                  return _phoneError;
                                }
                                if(_phoneNumberError.isNotEmpty){
                                  return _phoneNumberError;

                                }
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid phone number';
                                }
                                if (!value.startsWith('+')) {
                                  return 'The phone number must start with a \n country code (+)';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true, // Enables the background color
                                fillColor: Color(0xFFF4F4F4), // Background color of the TextFormField
                                labelText: 'Phone',
                                floatingLabelStyle: const TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400

                                ),
                                labelStyle: const TextStyle(
                                  color: Color(0xFFC5C5C5), // Default label color
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, // Adjust vertical padding for height
                                  horizontal: 12.0, // Adjust horizontal padding
                                ),

                                errorStyle: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFDC897C),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none, // No border when enabled
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF4F4F4), // Border color when focused
                                    width: .5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC897C), // Border color when error occurs
                                    width: 1,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC897C), // Border color when error occurs and focused
                                    width: 1,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black, // Text color for entered text
                                fontSize: 16, // Customize font size
                                fontFamily: 'Poppins', // Customize font family if needed
                              ),
                            ),
                          ),

                          if(showTextField)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: hidePassword,
                                    validator: (value) {
                                      if (_password.isNotEmpty) {
                                        return _password;
                                      }
                                      if (_message.isNotEmpty) {
                                        return _message;
                                      }

                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a valid password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      filled: true, // Enables the background color
                                      fillColor: Color(0xFFF4F4F4), // Background color of the TextFormField
                                      labelText: 'Password',
                                      floatingLabelStyle: const TextStyle(
                                          color: Color(0xFFC5C5C5),
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400

                                      ),
                                      labelStyle: const TextStyle(
                                        color: Color(0xFFC5C5C5), // Default label color
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, // Adjust vertical padding for height
                                        horizontal: 10.0, // Adjust horizontal padding
                                      ),
                                      suffixIcon: IconButton(
                                        icon: hidePassword
                                            ? Icon(Icons.visibility_off_outlined,)
                                            : Icon(Icons.visibility_outlined, ),
                                        onPressed: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                      ),

                                      errorStyle: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFDC897C),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide.none, // No border when enabled
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFF4F4F4), // Border color when focused
                                          width: .5,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFDC897C), // Border color when error occurs
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFDC897C), // Border color when error occurs and focused
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(onPressed: (){}, child: const Text("Forget Password"))
                              ],
                            ),





                        ],


                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 340, height: 52),
                    child: ElevatedButton.icon(

                        onPressed: (){
                      if ( _loginkey.currentState!.validate()) {
                        _userLoginModel.emailaddress =
                            _emailController.text.toString();
                        _userLoginModel.mobilenumber=_phoneController.text.toString();
                        !showTextField?postdata(context):login(context);
                        FocusScope.of(context).unfocus();
                        _loginkey.currentState?.reset();

                      }

                    },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF004AAD),
                          elevation: 2,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        label: !showTextField? Center(child: const Text("Next",style: TextStyle(fontFamily:'Poppins',fontSize: 16,fontWeight: FontWeight.w600,color: Colors.white),)):Text("Login",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),)),
                  ),
                ),


              ],
            ),
          ),
        )


      ],
    ),
          ),
        );
  }
}
