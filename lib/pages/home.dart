import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edpic_eccommerce_app/pages/category_products.dart';
import 'package:edpic_eccommerce_app/pages/product_detail.dart';
import 'package:edpic_eccommerce_app/services/database.dart';
import 'package:edpic_eccommerce_app/services/shared_preferences.dart';
import 'package:edpic_eccommerce_app/widget/support_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  List categories = [
    "images/headphone_icon.png",
    "images/laptop.png",
    "images/watch.png",
    "images/TV.png",
  ];

  List Categoryname = [
    "Headphones",
    "Laptop",
    "Watch",
    "TV",
  ];

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchController = TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    setState(() {
      search = true;
    });

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element["UpdatedName"].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  String? name, image;
  getTheSharedPref() async {
    name = await SharedPreferencesHelper().getUserName();
    image = await SharedPreferencesHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getTheSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hey, " + name!,
                              style: AppWidget.boldTextFieldStyle(),
                            ),
                            Text(
                              getGreeting(),
                              style: TextStyle(
                                fontFamily: "Dancing",
                                letterSpacing: 2.0,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                              ),
                            )
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            image!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      // padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          initiateSearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Products",
                            hintStyle: AppWidget.lightTextFieldStyle(),
                            prefixIcon: search
                                ? CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      search = false;
                                      tempSearchStore = [];
                                      queryResultSet = [];
                                      searchController.text = "";
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                  )
                                : Icon(
                                    Icons.search,
                                    color: Colors.deepOrangeAccent,
                                  )),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    search
                        ? ListView(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList(),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Categories",
                                      style: AppWidget.semiBoldTextFieldStyle(),
                                    ),
                                    Text(
                                      "see all",
                                      style: TextStyle(
                                          color: Color(0xFFfd6f3e),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 130,
                                    padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.only(right: 20.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFD6F3E),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        "All",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 130,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: categories.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return CategoryTile(
                                            image: categories[index],
                                            name: Categoryname[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "All Categories",
                                    style: AppWidget.semiBoldTextFieldStyle(),
                                  ),
                                  Text(
                                    "see all",
                                    style: TextStyle(
                                        color: Color(0xFFfd6f3e),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                height: 240,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 20),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 147, 221, 231),
                                                // Color.fromARGB(255, 201, 108, 173)
                                                Color.fromARGB(
                                                    255, 253, 208, 194),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomLeft)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "images/headphone2.png",
                                            height: 140,
                                            width: 140,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "Headphone",
                                            style: AppWidget
                                                .semiBoldTextFieldStyle(),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "\$100",
                                                style: TextStyle(
                                                    color: Color(0xFFfd6f3e),
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 50.0,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFfd6f3e),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 147, 221, 231),
                                                // Color.fromARGB(255, 201, 108, 173)
                                                Color.fromARGB(
                                                    255, 224, 168, 208)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomLeft)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "images/watch2.png",
                                            height: 140,
                                            width: 140,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "Watches",
                                            style: AppWidget
                                                .semiBoldTextFieldStyle(),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "\$100",
                                                style: TextStyle(
                                                    color: Color(0xFFfd6f3e),
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 50.0,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFfd6f3e),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                    name: data["Name"],
                    image: data["Image"],
                    detail: data["Detail"],
                    price: data["Price"])));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        height: 100,
        child: Row(
          children: [
            Image.network(
              data["Image"],
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              data["Name"],
              style: AppWidget.semiBoldTextFieldStyle(),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  String image, name;
  CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProduct(category: name)));
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              image,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
