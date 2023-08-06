import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '/BloCLayer/UserBloc.dart';
import '/DataLayer/Services/SignInMethods.dart';

class PhoneSignIn extends StatefulWidget {
  @override
  _PhoneSignInState createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  int? index;
  final String _countryCode = "+91";
  GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

  FocusNode _phoneFocus = FocusNode();
  FocusNode _otpFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    return Container(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            // height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    // height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: IndexedStack(
                        index: index,
                        children: [
                          Form(
                            key: _phoneFormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        autofocus: true,
                                        focusNode: _phoneFocus,
                                        controller: _phoneNumberController,
                                        maxLength: 10,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                              RegExp("[0-9]")),
                                        ],
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter your phone number";
                                          } else if (value!.length != 10) {
                                            return "Please enter 10 digits";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onFieldSubmitted: (_) {
                                          if (_phoneFormKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              index = 1;
                                            });

                                            SignInMethods.autoVerifyPhone(
                                              userBloc: userBloc,
                                              countryCode: _countryCode,
                                              phoneNumber:
                                                  _phoneNumberController.text,
                                            ).then((_) {
                                              FocusScope.of(context)
                                                  .requestFocus(_otpFocus);
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                          errorStyle:
                                              TextStyle(color: Colors.white),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "10-digit mobile number",
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    CircleAvatar(
                                      child: IconButton(
                                        icon: Icon(Icons.keyboard_arrow_right),
                                        onPressed: () async {
                                          if (_phoneFormKey.currentState!
                                              .validate()) {
                                            await SignInMethods.autoVerifyPhone(
                                              userBloc: userBloc,
                                              countryCode: _countryCode,
                                              phoneNumber:
                                                  _phoneNumberController.text,
                                            );
                                            setState(() {
                                              index = 1;
                                            });
                                            FocusScope.of(context)
                                                .requestFocus(_otpFocus);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: _otpFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        focusNode: _otpFocus,
                                        controller: _otpController,
                                        maxLength: 6,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                              RegExp("[0-9]")),
                                        ],
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter OTP";
                                          } else if (value!.length != 6) {
                                            return "Incomplete OTP";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onFieldSubmitted: (_) {
                                          if (_otpFormKey.currentState!
                                              .validate()) {
                                            SignInMethods.phoneWithOTP(
                                              userBloc: userBloc,
                                              otp: _otpController.text,
                                            );
                                          }
                                        },
                                        decoration: InputDecoration(
                                          errorStyle:
                                              TextStyle(color: Colors.white),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "6-digit OTP",
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    CircleAvatar(
                                      child: IconButton(
                                        icon: Icon(Icons.done),
                                        onPressed: () {
                                          if (_otpFormKey.currentState!
                                              .validate()) {
                                            SignInMethods.phoneWithOTP(
                                              userBloc: userBloc,
                                              otp: _otpController.text,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                TextButton(
                                  child: Text("Change Phone Number"),
                                  onPressed: () {
                                    setState(() {
                                      index = 0;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
