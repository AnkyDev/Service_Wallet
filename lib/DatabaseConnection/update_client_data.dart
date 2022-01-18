import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';


class UpdateClientData
{
  String mobileno,userid,address,lat,log,date,time,id;


  UpdateClientData(this.mobileno, this.userid, this.address, this.lat, this.log,
      this.date, this.time, this.id);

  Future<void> updateData()
  async {
    return FirebaseFirestore.instance.collection("users").doc(userid).update({
      'lat': lat,
      'log': log,
      'address': address
    });

  }
}