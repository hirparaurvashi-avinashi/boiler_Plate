library boilerplate;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'APICalls/ServerCommunicator.dart';
import 'CommonToastUI/ToastMessage.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class LoginPage extends StatefulWidget{

  Image appLogo;
  String loginApiUrl;
  Function afterLoginCallback;

  LoginPage({Key key, @required this.appLogo,@required this.loginApiUrl,@required this.afterLoginCallback}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AnimationController _animationController;
  var mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  onTapButton(){
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      APIProvider().doLogin(mobileController.text,widget.loginApiUrl)
          .then((onValue) {
        if (onValue.flag) {
          setState(() {
            isLoading = false;
          });

          widget.afterLoginCallback(onValue.data.id);
//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) =>
//                  OtpVerification(mobileNumber: mobileController.text,otpHashKey: onValue.data.id,),
//            ),
//          );
        } else {
          setState(() {
            isLoading = false;
          });
          return Toast.show(onValue.message, context);
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F3F6),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              child: ResponsiveGridRow(children: [
                ResponsiveGridCol(
                    xs: 12,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 50, bottom: 50),
                          child: widget.appLogo
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Text("Login with mobile",style: Theme.of(context).textTheme.headline,),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 50),
                          child: Text("Enter your mobile number to get \nverification code",style: Theme.of(context).textTheme.subhead, textAlign: TextAlign.center,),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 16, right: 16),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: mobileController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.stay_current_portrait, size: 18,),
                                  focusedBorder:UnderlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                                  ),
                                  labelText: "Enter mobile number",
                                  focusColor: Colors.blue
                              ),
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Mobile number can't be blank";
                                } else {
                                  if (value.length < 10) {
                                    return "Please enter valid mobile number";
                                  }
                                }
                                return null;
                              },
                            )
                        ),

                        Container(
                            margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                            child: Container(
                              child: Material(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue,
                                child: InkWell(
                                  // When the user taps the button, show a snackbar.
                                  onTap: () {
                                    onTapButton();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                                    child:
                                    isLoading
                                        ? SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 30.0,
                                    )
                                        :
                                    Text("Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ),
                      ],
                    ))
              ]),
            ),
          ),

        ),
      ),
    );

  }

}