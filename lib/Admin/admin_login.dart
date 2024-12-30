import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edpic_eccommerce_app/Admin/home_admin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: 20, left: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "images/login.png",
              ),
              Center(
                child: Text(
                  "Admin Panel",
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "User Name",
                style: AppWidget.semiBoldTextFieldStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                  color: Color(0xFFF4F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: userController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Enter Name"),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Password",
                style: AppWidget.semiBoldTextFieldStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                  color: Color(0xFFF4F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Enter Password"),
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  loginAdmin();
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20.0,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()["username"] != userController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Your Id is not Correct",
                style: TextStyle(fontSize: 20.0),
              )));
        } else if (result.data()["password"] !=
            passwordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Your Password is not Correct",
                style: TextStyle(fontSize: 20.0),
              )));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeAdmin()));
        }
      });
    });
  }
}
