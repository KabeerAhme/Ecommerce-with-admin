import 'package:edpic_eccommerce_app/Admin/add_product.dart';
import 'package:edpic_eccommerce_app/Admin/all_orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/support_widget.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
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
          "Home Admin",
          style: AppWidget.boldTextFieldStyle(),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 50,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        "Add Product",
                        style: AppWidget.boldTextFieldStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllOrders()));
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 50,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        "All Product",
                        style: AppWidget.boldTextFieldStyle(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
