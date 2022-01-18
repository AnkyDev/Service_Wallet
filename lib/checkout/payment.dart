import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget
{
  String price ;

  Payment(this.price);

  _Payment createState ()=> _Payment(price);
}

class _Payment extends State<Payment>
{
  final razorpay = Razorpay();
  String price;


  _Payment(this.price);

  @override
  void initState() {
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,externalWallet);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,paySucess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,payError);

    getPayment();

    super.initState();
  }

  void paySucess(PaymentSuccessResponse response)
  {
    print(response.paymentId.toString());


  }

  void payError(PaymentFailureResponse response){
    print(response.message + " "+ response.code.toString());
  }

  void externalWallet(ExternalWalletResponse response)
  {
    print(response.walletName);
  }

  getPayment()
  {
    var option = {
      'key': 'rzp_test_sDIvdLAZIYPA11',
      'amount': double.parse(price.trim()) * 100,
      'name': 'Krash Service',
      'profile': {'contact': '8459888289','email':'zala4011@gmail.com' },
    };

    try{
      razorpay.open(option);
    }
    catch(e)
    {
      print("error = $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _pointer == 0 ? CircularProgressIndicator() : Container(),
        ),
      ),
    );
  }


  int _pointer = 0;
}