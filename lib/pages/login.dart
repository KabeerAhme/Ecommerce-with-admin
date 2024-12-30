import 'package:edpic_eccommerce_app/pages/bottom_nav.dart';
import 'package:edpic_eccommerce_app/pages/home.dart';
import 'package:edpic_eccommerce_app/pages/signup.dart';
import 'package:edpic_eccommerce_app/widget/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isLoading = false;
  String email = "", password = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNav()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "user-not-found",
              style: TextStyle(fontSize: 20.0),
            )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "wrong-password",
              style: TextStyle(fontSize: 20.0),
            )));
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          margin: EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "images/login.png",
                  ),
                  Center(
                    child: Text(
                      "Sign In",
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Text(
                      "Please enter the details below to\ncontinue",
                      textAlign: TextAlign.center,
                      style: AppWidget.lightTextFieldStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    "Email",
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
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Enter Email"),
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
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Enter Password"),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 0.0,
                  // ),
                  CupertinoButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                          password = passwordController.text;
                        });
                      }
                      userLogin();
                    },
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppWidget.lightTextFieldStyle(),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
