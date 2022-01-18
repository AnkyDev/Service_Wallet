//created by sahil zala

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home/home_screen.dart';
import 'login_signup.dart';

Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // navigation bar color
    statusBarColor: Color.fromRGBO(0,0,102, 1), // status bar color
  ));
  await runApp(

      MaterialApp(
          home: SplashScreen()));
}

class SplashScreen extends StatefulWidget
{
  _SplashScreen createState() => _SplashScreen();
}
class _SplashScreen extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    if(FirebaseAuth.instance.currentUser != null)
    {
      FirebaseFirestore.instance.collection("users").get().then((value){
        print(value.docs.length);
        value.docs.forEach((e){
          if(e['userid'] == FirebaseAuth.instance.currentUser.uid) {
           // print("found");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(e.data())),
            );
          }

        });
      }).catchError((onError){
        print(onError);
        print("Eerrr");
      });
    }
    else {
      _configureAmplify();
    }

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 90,
                width: 220,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("images/logo.png"),fit: BoxFit.fill),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _configureAmplify() async {



    FirebaseFirestore.instance.collection("demo").doc("1").set({'sasa':'sasa'}).catchError((onError){
      print(onError);
    }).then((value){
      print("done");
    });

    Timer(Duration(seconds: 3),
            () =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                    LoginSignup()
                )
            )
    );

  }



}