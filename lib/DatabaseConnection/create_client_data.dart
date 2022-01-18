import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';


class CreateClientData
{

  Future<void> create(userid,name,mail,address,lat,log,mobileno,time,date,profile)
  async {
    return FirebaseFirestore.instance.collection("users").doc(userid).set({
      'userid': userid,
      'name': name,
      'mail': mail,
      'address': address,
      'lat': lat,
      'log': log,
      'mobileno': mobileno, 
      'time': time,
      'date': date,
      'profile': profile,
      'activation': 'true'
    });
  }

  Future<DocumentSnapshot> check(userid)
  async => await FirebaseFirestore.instance.collection("users").doc(userid).get();



}

