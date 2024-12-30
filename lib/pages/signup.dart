import 'package:edpic_eccommerce_app/pages/bottom_nav.dart';
import 'package:edpic_eccommerce_app/pages/login.dart';
import 'package:edpic_eccommerce_app/services/database.dart';
import 'package:edpic_eccommerce_app/services/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import '../widget/support_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, email, password;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null && name != null && email != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Registered Successfully",
                style: TextStyle(fontSize: 20.0),
              )),
        );
        String Id = randomAlphaNumeric(10);
        await SharedPreferencesHelper().saveUserEmail(emailController.text);
        await SharedPreferencesHelper().saveUserId(Id);
        await SharedPreferencesHelper().saveUserName(nameController.text);
        await SharedPreferencesHelper().saveUserImage(
            "https://cdn-icons-png.freepik.com/512/219/219986.png");
        Map<String, dynamic> userInfoMap = {
          "Name": nameController.text,
          "Email": emailController.text,
          "Id": Id,
          "Image": "https://cdn-icons-png.freepik.com/512/219/219986.png"
        };
        await DatabaseMethods().addUserDetails(userInfoMap, Id);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Password is too weak",
                style: TextStyle(fontSize: 20.0),
              )));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Email already exist",
                style: TextStyle(fontSize: 20.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: 20, left: 20.0, right: 20.0, bottom: 20.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "images/login.png",
                ),
                Center(
                  child: Text(
                    "Sign Up",
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
                  "Name",
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
                        return "Please enter your name";
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Enter Name"),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // SizedBox(
                //   height: 40.0,
                // ),
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

                // SizedBox(
                //   height: 30.0,
                // ),
                CupertinoButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        name = nameController.text;
                        email = emailController.text;
                        password = passwordController.text;
                      });
                    }
                    registration();
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
                          "SIGN UP",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "already have an account? ",
                      style: AppWidget.lightTextFieldStyle(),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LogIn(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.green,
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
    );
  }
}
