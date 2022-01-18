import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:krash_company/DatabaseConnection/create_client_data.dart';
import 'package:krash_company/timedate.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'home_screen.dart';

class AddressPicker extends StatefulWidget {
  String _country_code = "";
  String _mobile_no = "";

  String uid = "";

  AddressPicker(this._country_code, this._mobile_no, this.uid);

  _AddressPicker createState() =>
      _AddressPicker(_country_code, _mobile_no, uid);
}

class _AddressPicker extends State<AddressPicker> {
  String _country_code = "+91";
  String _mobile_no = "";
  String uid;

  Completer<GoogleMapController> _controller = Completer();
  LatLng ll;
  final Set<Marker> _markers = {};
  final _formKey = GlobalKey<FormState>();

  TextEditingController _textEditingController;

  String location = "location ";
  String newAddress = "";
  CameraPosition _cameraPosition =
      new CameraPosition(target: LatLng(10, 10), zoom: 11);

  _AddressPicker(this._country_code, this._mobile_no, this.uid);
  Location currentLocation = Location();

  @override
  void initState() {
    _textEditingController = new TextEditingController();
    
    setState(() {
      getLocation();
    });
    Future<Position> p = _determinePosition();
    p.whenComplete(() => {
          p.then((value) {
            print(value.latitude);
            print(value.longitude);
            setState(() {
              //  _cameraPosition = new CameraPosition(
              //      target: ll != null ? ll : LatLng(1, 1), zoom: 11);
              // ll = new LatLng(value.latitude, value.longitude);

              // _markers.clear();
              // _markers.add(Marker(
              //     markerId: MarkerId(ll.toString()),
              //     position: ll,
              //     infoWindow: InfoWindow(title: "sasa", snippet: "sasasa"),
              //     icon: BitmapDescriptor.defaultMarker));
              // _goToPosition(ll);
            });
          })
        });
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _goToPosition(LatLng l) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: l, bearing: 192.83, tilt: 10.55, zoom: 15.0)));
  }

  String address = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onTap: (ll) {
                setState(() {
                  _markers.clear();
                  _markers.add(Marker(
                      markerId: MarkerId(ll.toString()),
                      position: ll,
                      infoWindow: InfoWindow(title: "sasa", snippet: "sasasa"),
                      icon: BitmapDescriptor.defaultMarker));
                  location = Geocoder.local
                      .findAddressesFromCoordinates(
                          Coordinates(ll.latitude, ll.longitude))
                      .then((value) {
                    setState(() {
                      location =
                          "${value.first.addressLine} : ${value.first.coordinates}";
                    });
                    _goToPosition(ll);
                  }) as String;
                });
              },
              mapType: MapType.normal,
              initialCameraPosition: _cameraPosition,
              markers: _markers,
              onCameraMove: (cameraPosition) {},
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            Material(
              elevation: 10,
              child: Container(
                height: 128,
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 5, 0),
                              child: Icon(
                                Icons.location_on,
                                size: 20,
                                color: Color.fromRGBO(102, 0, 0, 102),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 15, 15, 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: TextFormField(
                                  controller: _textEditingController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (val) {
                                    newAddress = val;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      focusColor: Color.fromRGBO(52, 73, 94, 1),
                                      hintText: "enter your location",
                                      suffix: IconButton(
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              
                                                  searchWithAddress(newAddress);
                                              // print("sa");
                                              // p.whenComplete(() => (){
                                              //   p.then((value){
                                              //     setState(() {
                                              //       print("sahil");
                                              //       _markers.clear();
                                              //
                                              //       ll = new LatLng(value.latitude, value.longitude);
                                              //       print("jj"+ll.toString());
                                              //       _markers.add(Marker(markerId: MarkerId(ll.toString()),position: ll,infoWindow: InfoWindow(title: "sasa",snippet: "sasasa"),icon: BitmapDescriptor.defaultMarker));
                                              //       _goToPosition();
                                              //     });
                                              //   });
                                              // });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.search,
                                            size: 20,
                                            color:
                                                Color.fromRGBO(52, 73, 94, 1),
                                          ))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 102, 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                              height: 18,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "images/location_icon.png"))),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.11,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(location,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  height: 80,
                  width: 140,
                  decoration: BoxDecoration(),
                  child: RaisedButton(
                    onPressed: () {
                      createUser();
                    },
                    elevation: 5,
                    color: Color.fromRGBO(0, 0, 102, 1),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "next",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Icon(
                          Icons.navigate_next_sharp,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 0, 102, 1),
        child: Icon(Icons.location_on),
        onPressed: () {
          setState(() {
            _markers.clear();
            getLocation();
          });
        },
      ),
    );
  }

  void getLocation() async {
    var location2 = await currentLocation.getLocation();
    //currentLocation.onLocationChanged.listen((LocationData loc) async {
    //});
    print(location2.latitude);
      print(location2.longitude);
      final coordinates = new Coordinates(location2.latitude, location2.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      setState(() {
        location = "${first.addressLine} : ${first.coordinates}";
        _markers.add(Marker(
            markerId: MarkerId('Home'),
            position: LatLng(location2.latitude ?? 0.0, location2.longitude ?? 0.0),
            infoWindow: InfoWindow(title: "sasa", snippet: "sasasa"),
            icon: BitmapDescriptor.defaultMarker));
        _goToPosition(LatLng(location2.latitude,location2.longitude));
      });
  }

  Future<Position> _determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permantly denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return Future.error(
              'Location permissions are denied (actual value: $permission).');
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          //desiredAccuracy: LocationAccuracy.bestForNavigation
          );
     // debugPrint('location: ${position.latitude}');
      // final coordinates =
      //     new Coordinates(position.latitude, position.longitude);
      // var addresses =
      //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // var first = addresses.first;
      setState(() {
        //location = "${first.featureName} : ${first.addressLine}";

       // ll = new LatLng(position.latitude, position.longitude);

        print(location);
      });
      return await Geolocator.getCurrentPosition(
          //desiredAccuracy: LocationAccuracy.bestForNavigation
          );
    } catch (e) {
      print(e);
    }
    return null;
  }

  var first;
  Future<void> searchWithAddress(String address) async {
    var addresses =
        await Geocoder.local.findAddressesFromQuery(address).then((value) {
      setState(() {
        first = value.first;
        // Position p = new Position(latitude: first.coordinates.latitude,longitude: first.coordinates.longitude);
        // print("${first.featureName} : ${first.coordinates}");
        var newll = new LatLng(value.first.coordinates.latitude,
            value.first.coordinates.longitude);

        location = "${value.first.featureName} : ${value.first.coordinates}";

        ll = new LatLng(value.first.coordinates.latitude,
            value.first.coordinates.longitude);
        _markers.clear();
        _markers.add(Marker(
            markerId: MarkerId(newll.toString()),
            position: newll,
            infoWindow: InfoWindow(title: "here", snippet: "here"),
            icon: BitmapDescriptor.defaultMarker));
        _goToPosition(newll);
      });
    });
  }

  void createUser() {
    CreateClientData ccd = new CreateClientData();

    ccd
        .create(
            uid,
            "name",
            "mail",
            location,
            ll.latitude.toString(),
            ll.longitude.toString(),
            _country_code + " " + _mobile_no,
            getCurrentTime(),
            getCurrentDate(),
            "profile")
        .then((value) {
      print("done");

      CreateClientData ccd = new CreateClientData();

      ccd.check(uid).then((value) {
        if (value.exists) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(value.data())));
        }
      }).catchError((onError) {
        print(onError);
      });
    }).catchError((onError) {
      print(onError);
    });
    // CreateClientData ccd = CreateClientData("id","name","mail",location,ll.latitude.toString(),ll.longitude.toString(),_country_code+_mobile_no,"time","date","profile","true");
    // ccd.create().then((value){
    //   if(value != null)
    //   {
    //     Fluttertoast.showToast(
    //       msg: "User created succesfully",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Color.fromRGBO(0, 0, 102, 1),
    //       textColor: Colors.white,
    //       fontSize: 16.0,
    //     );
    //
    //     Timer(Duration(
    //       seconds: 1,),(){
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => HomeScreen(value)),
    //       );
    //     });
    //   }
    //   else{
    //     Timer(Duration(
    //       seconds: 1,),(){
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => HomeScreen(value)),
    //       );
    //     });
    //     Fluttertoast.showToast(
    //       msg: "!Something problem",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Color.fromRGBO(0, 0, 102, 1),
    //       textColor: Colors.white,
    //       fontSize: 16.0,
    //     );
    //   }
    // });
  }
}
