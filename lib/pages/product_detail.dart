import 'dart:convert';

import 'package:edpic_eccommerce_app/services/constant.dart';
import 'package:edpic_eccommerce_app/services/database.dart';
import 'package:edpic_eccommerce_app/services/shared_preferences.dart';
import 'package:edpic_eccommerce_app/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  String image, name, detail, price;

  ProductDetail(
      {super.key,
      required this.name,
      required this.image,
      required this.detail,
      required this.price});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String? name, mail, image;
  bool isLoading = false;
  getthesharedpref() async {
    name = await SharedPreferencesHelper().getUserName();
    mail = await SharedPreferencesHelper().getUserEmail();
    image = await SharedPreferencesHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  // Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xfff2f2f2),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Color(0xfff2f2f2),
      body: Container(
        // padding: EdgeInsets.only(top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                //   child: Container(
                //     margin: EdgeInsets.only(left: 20.0),
                //     padding: EdgeInsets.all(10),
                //     decoration: BoxDecoration(
                //       border: Border.all(),
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: Icon(Icons.arrow_back_ios_new_outlined),
                //   ),
                // ),
                Center(
                  child: Image.network(
                    widget.image,
                    height: 400,
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          // style: AppWidget.boldTextFieldStyle(),
                        ),
                        Text(
                          widget.price.toString(),
                          style: TextStyle(
                              color: Color(0xFFfd6f3e),
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    Text(
                      "Details",
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    Text(widget.detail),
                    SizedBox(
                      height: 100.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        // makePayment(widget.price);
                        makePayment();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                            color: Color(0xFFfd6f3e),
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                              : Text(
                                  "Buy Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  makePayment() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> orderInfoMap = {
      "Product": widget.name,
      "Price": widget.price,
      "Name": name,
      "Email": mail,
      "Image": image,
      "ProductImage": widget.image,
      "Status": "On the way",
    };
    await DatabaseMethods().orderDetails(orderInfoMap).then((value) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Center(
            child: Text(
              "Ordered Successfully",
              style: TextStyle(fontSize: 20.0),
            ),
          )));
    });
  }

  // Future<void> makePayment(String amount) async {
  //   try {
  //     paymentIntent = await createPaymentIntent(amount, 'INR');
  //     await Stripe.instance
  //         .initPaymentSheet(
  //             paymentSheetParameters: SetupPaymentSheetParameters(
  //           paymentIntentClientSecret: paymentIntent?['client_secret'],
  //           style: ThemeMode.dark,
  //           merchantDisplayName: "Kabeer",
  //         ))
  //         .then((value) {});

  //     displayPaymentSheet();
  //   } catch (e, s) {
  //     print('exception:$e$s');
  //   }
  // }

  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) async {
  //       showDialog(
  //           context: context,
  //           builder: (_) => AlertDialog(
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Icon(
  //                           Icons.check_circle,
  //                           color: Colors.green,
  //                         ),
  //                         Text("Payment Successfully Done"),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ));
  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       print("Error is :----> $error $stackTrace");
  //     });
  //   } on StripeException catch (e) {
  //     print("Error is:---> $e");
  //     showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //               content: Text("Payment Has been Canceled"),
  //             ));
  //   } catch (e) {
  //     print("$e");
  //   }
  // }

  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //       'payment_method_types[]': 'card'
  //     };

  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer $secretKey',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       body: body,
  //     );
  //     return jsonDecode(response.body);
  //   } catch (err) {
  //     print("err charging user: ${err.toString()}");
  //   }
  // }

  // calculateAmount(String amount) {
  //   final calculatedAmount = (int.parse(amount) * 100);
  //   return calculatedAmount.toString();
  // }
}
