import 'dart:io';
import 'package:edpic_eccommerce_app/pages/login.dart';
import 'package:edpic_eccommerce_app/services/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import '../services/auth.dart';
import '../widget/support_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getthesharedpref() async {
    image = await SharedPreferencesHelper().getUserImage();
    name = await SharedPreferencesHelper().getUserName();
    email = await SharedPreferencesHelper().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadItem();
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferencesHelper().saveUserImage(downloadUrl);
    }
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
          "Profile",
          style: AppWidget.boldTextFieldStyle(),
        ),
        centerTitle: true,
      ),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                children: [
                  selectedImage != null
                      ? GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                selectedImage!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                image!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 3.0,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 35.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: AppWidget.lightTextFieldStyle(),
                                ),
                                Text(
                                  name!,
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 3.0,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail_outline,
                              size: 35.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: AppWidget.lightTextFieldStyle(),
                                ),
                                Text(
                                  email!,
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await AuthMethods().SignOut().then((value) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                size: 35.0,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "LogOut",
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await AuthMethods().deleteUser().then((value) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outlined,
                                size: 35.0,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Delete Account",
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                              )
                            ],
                          ),
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
