import 'dart:io';
import 'package:edpic_eccommerce_app/services/database.dart';
import 'package:edpic_eccommerce_app/widget/support_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  bool isLoading = false;
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null && nameController.text != "") {
      isLoading = true;
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      String firstletter = nameController.text.substring(0, 1).toUpperCase();

      Map<String, dynamic> addProduct = {
        "Name": nameController.text,
        "Image": downloadUrl,
        "SearchKey": firstletter,
        "UpdatedName": nameController.text.toUpperCase(),
        "Price": priceController.text,
        "Detail": detailController.text,
      };
      await DatabaseMethods()
          .addProduct(addProduct, value!)
          .then((value) async {
        await DatabaseMethods().addAllProducts(addProduct);
        selectedImage = null;
        nameController.text = "";
        detailController.text = "";
        priceController.text = "";
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Product added Succesfully",
              style: TextStyle(fontSize: 20.0),
            )));
      });
    }
  }

  String? value;
  final List<String> categoryitem = [
    "Watch",
    "Laptop",
    "TV",
    "Headphones",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Product",
          style: AppWidget.semiBoldTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Upload the Product Image",
                  style: AppWidget.lightTextFieldStyle(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              selectedImage == null
                  ? GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.black, width: 1.5)),
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.black, width: 1.5)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Product Name",
                style: AppWidget.lightTextFieldStyle(),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Product Price",
                style: AppWidget.lightTextFieldStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Product Detail",
                style: AppWidget.lightTextFieldStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  maxLines: 6,
                  controller: detailController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              Text(
                "Product Category",
                style: AppWidget.lightTextFieldStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: categoryitem
                        .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: AppWidget.semiBoldTextFieldStyle(),
                            )))
                        .toList(),
                    onChanged: (value) => setState(() {
                      this.value = value;
                    }),
                    dropdownColor: Colors.white,
                    hint: Text("Select Category"),
                    iconSize: 36,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: SizedBox(
                  height: 45,
                  width: 160,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        uploadItem();
                      },
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "Add Prodcut",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


// Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20.0),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: Color(0xFFececf8),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(border: InputBorder.none),
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Text(
//                 "Product Price",
//                 style: AppWidget.lightTextFieldStyle(),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20.0),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: Color(0xFFececf8),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: TextField(
//                   controller: priceController,
//                   decoration: InputDecoration(border: InputBorder.none),
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Text(
//                 "Product Detail",
//                 style: AppWidget.lightTextFieldStyle(),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20.0),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: Color(0xFFececf8),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: TextField(
//                   maxLines: 6,
//                   controller: detailController,
//                   decoration: InputDecoration(border: InputBorder.none),
//                 ),
//               ),