import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edpic_eccommerce_app/pages/product_detail.dart';
import 'package:edpic_eccommerce_app/services/database.dart';
import 'package:flutter/material.dart';

import '../widget/support_widget.dart';

class CategoryProduct extends StatefulWidget {
  String category;
  CategoryProduct({required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream? CategoryStream;

  getontheload() async {
    CategoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allProducts() {
    return StreamBuilder(
        stream: CategoryStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            ds["Image"],
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            ds["Name"],
                            style: AppWidget.semiBoldTextFieldStyle(),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text(
                                "\$" + ds["Price"].toString(),
                                style: TextStyle(
                                    color: Color(0xFFfd6f3e),
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetail(
                                              name: ds["Name"],
                                              image: ds["Image"],
                                              detail: ds["Detail"],
                                              price: double.parse(ds["Price"])
                                                  .toString())));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFfd6f3e),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
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
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [Expanded(child: allProducts())],
        ),
      ),
    );
  }
}
