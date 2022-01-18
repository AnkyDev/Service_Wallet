import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krash_company/DatabaseConnection/create_client_data.dart';
import 'package:krash_company/home/address_picker.dart';
import 'package:krash_company/home/home_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uuid/uuid.dart';

import 'home/new_address_picker.dart';

class OTPVerification extends StatefulWidget{
  String _country_code="+91";
  String _mobile_no = "";
  String verificationId = "";
  _OTPVerification createState() => _OTPVerification(_country_code,_mobile_no,verificationId);

  OTPVerification(this._country_code, this._mobile_no, this.verificationId);
}

class _OTPVerification extends State<OTPVerification>
{
  String _coutry_code,_mobile_no;
  String verficationId;

  _OTPVerification(this._coutry_code, this._mobile_no, this.verficationId);

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(0,0,102, 1),
        title: Text("Login/Signup", style: TextStyle(fontFamily: 'RobotoSlab', letterSpacing: 0.6),),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            Text("Enter verification code ",
              style: TextStyle(
                  color: Color.fromRGBO(0,0,102, 1),
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 15,),
            Text("we have sent you a 4 digit verification code on",
              style: TextStyle(
                  color: Color.fromRGBO(52, 73, 94, 1),
                  fontSize: 15
              ),
            ),

            SizedBox(height: 15,),
            Text(_coutry_code+_mobile_no,
              style: TextStyle(
                  color: Color.fromRGBO(0,0,102, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),


            SizedBox(height: 15,),

            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: _pointer == 0 ? Form(
                child: PinCodeTextField(
                  keyboardType: TextInputType.number,
                  backgroundColor: Colors.transparent,
                  appContext: context, length: 6,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderWidth: 2,
                    borderRadius: BorderRadius.circular(5),
                    activeColor: Color.fromRGBO(0,0,102, 1),
                    inactiveColor: Colors.grey,
                    selectedColor: Colors.black,
                    fieldHeight: 50,
                    fieldWidth: 50,
                  ),mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  onCompleted: (value)
                  async {
                    setState(() {
                      _pointer = 1;
                    });
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(verificationId: verficationId, smsCode: value))
                        .then((value1) async {

                      Fluttertoast.showToast(
                        msg: "Verified",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromRGBO(0, 0, 102, 1),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      CreateClientData ccd = new CreateClientData();

                      ccd.check(value1.user.uid).then((value){
                        if(value.exists)
                        {
                          setState(() {
                            _pointer = 0;
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(value.data())));
                        }
                        else{

                          setState(() {
                            _pointer = 0;
                          });


                          String uid = value1.user.uid;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddressPicker(_coutry_code, _mobile_no,uid)));
                        }
                      });

                      // createNewUser.checkMobile(_coutry_code+" "+_mobile_no).then((value) {
                      //   setState(() {
                      //     _pointer = 0;
                      //   });
                      //
                      //   if(value.data() == null)
                      //   {
                      //     print(value.data());
                      //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profession("${_coutry_code} ${_mobile_no}")));
                      //   }
                      //   else{
                      //     setState(() {
                      //       _pointer = 0;
                      //     });
                      //
                      //     Fluttertoast.showToast(
                      //       msg: "done",
                      //       toastLength: Toast.LENGTH_SHORT,
                      //       gravity: ToastGravity.BOTTOM,
                      //       timeInSecForIosWeb: 1,
                      //       backgroundColor: Color.fromRGBO(0, 0, 102, 1),
                      //       textColor: Colors.white,
                      //       fontSize: 16.0,
                      //     );
                      //   }

                        // FetchUserData fud = new FetchUserData();
                        // fud.fetchData(_coutry_code+" "+_mobile_no).then((value) {
                        //   if(value.data() != null)
                        //   {
                        //
                        //     Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => HomeDashbord(value.data())),
                        //     );
                        //   }
                        //});
                 //     });
                    });
                  },
                ),
              ) : Column(
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  int _pointer = 0;
}