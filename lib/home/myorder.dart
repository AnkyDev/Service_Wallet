import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyOrder extends StatefulWidget
{
  Map userdata,orderdata;
  _MyOrder createState () => _MyOrder(userdata,orderdata);

  MyOrder(this.userdata, this.orderdata);
}
class _MyOrder extends State<MyOrder>
{

  Map userdata,orderdata;

  _MyOrder(this.userdata, this.orderdata);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${orderdata['servicename']}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      ),

                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      "${orderdata['cartype']}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      "${orderdata['address']}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${orderdata['ondate']}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20
                            ),
                          ),

                        ),

                        Expanded(
                          child: Text(
                            "${orderdata['ontime']}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20
                            ),
                          ),

                        )
                      ],
                    ),

                    SizedBox(
                        height: 30,),

                    Text(
                      "Taken By - ",
                      style: TextStyle(
                          color: Colors.black,
                        fontSize: 30
                      ),

                    ),

                    SizedBox(
                      height: 20,
                    ),


                    Text(
                      takenby != null ? "${takenby['name']}" : "nonne",

                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25
                      ),
                    ),


                    SizedBox(
                      height: 10,
                    ),


                    Text(
                      takenby != null ? "${takenby['address']}" : "nonne",

                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),


                    Row(
                      children: [
                        Text(
                          "Code - ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Text(
                            "${code}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 30
                            ),
                          ),
                        )
                      ],
                    ),







                  ],
                )
              ),

              appBar: AppBar(
                backgroundColor: Color.fromRGBO(0, 0, 102, 1),
                elevation: 0,
                title: Text(
                  "Orders",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,

                  ),
                ),
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Container(

                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),

                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.5),
                        //     spreadRadius:/ 5,
                        //     blurRadius: 7,
                        //     offset: Offset(0, 3), // changes position of shadow
                        //   ),
                        // ],
                      ),
                      child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        minWidth: MediaQuery.of(context).size.width,

                        onPressed: () async {
                          },


                        child: Text(
                          "${orderdata['status']}",
                          textScaleFactor: 0.9, style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                        ),
                        color: Colors.grey,
                        elevation: 0,
                      ),
                    ) ,
                  ),
                ],
              ),
            ) ,
          ],
        )
    );
  }

  @override
  void initState() {

    var rng = new Random();
    code = rng.nextInt(900000) + 100000;
    
    
    
    FirebaseFirestore.instance.collection("orders").doc(orderdata['orderid']).update({
      'code': code.toString(),
    });


    FirebaseFirestore.instance.collection("vendor").doc(orderdata['takenbyid']).get().then((value){
      Map data = value.data();
      setState(() {
        takenby = data;
      });
    });
  }

  var code = 0;
  Map takenby = null;
}