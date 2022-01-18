import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class OrderConnection
{
  Future<void> placeOrder(String orderid,userid,mobileno,address,lat,log,servicename,cartype,price,ontime,ondate,status,takenbyid,time,date,paymentid)
  async{
    return FirebaseFirestore.instance.collection("orders").doc(orderid).set({
      'orderid': orderid,
      'userid': userid,
      'mobileno': mobileno,
      'address': address,
      'lat': lat,
      'log': log,
      'servicename': servicename,
      'cartype': cartype,
      'price': price,
      'ontime': ontime,
      'ondate': ondate,
      'status': status,
      'takenbyid': takenbyid,
      'time': time,
      'date': date,
      'activation': 'true',
      'paymentid': paymentid,
    });
  }
}