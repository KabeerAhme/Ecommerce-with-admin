import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edpic_eccommerce_app/services/database.dart';
import 'package:edpic_eccommerce_app/services/shared_preferences.dart';
import 'package:edpic_eccommerce_app/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? email;

  getthesharedpref() async {
    email = await SharedPreferencesHelper().getUserEmail();
    setState(() {});
  }

  Stream? orderStream;

  getontheload() async {
    await getthesharedpref();
    orderStream = await DatabaseMethods().getOrders(email!);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? AnimationLimiter(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 500.0,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: Material(
                              elevation: 3.0,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20.0,
                                    top: 10.0,
                                    bottom: 10.0,
                                    right: 20.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        ds["ProductImage"],
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ds["Product"],
                                          style: AppWidget
                                              .semiBoldTextFieldStyle(),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "\$" + ds["Price"],
                                          style: TextStyle(
                                            color: Color(0xFFfd6f3e),
                                            fontSize: 23.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Status : " + ds["Status"],
                                          style: TextStyle(
                                            color: Color(0xFFfd6f3e),
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
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
        title: Text(
          "Current Orders",
          style: AppWidget.boldTextFieldStyle(),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [Expanded(child: allOrders())],
        ),
      ),
    );
  }
}
