import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:liftcart/orderview.dart';
import 'dart:convert';
import 'variables.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<int> quantities = [];
  @override
  Future<void> getcartData() async {
    final response = await http.get(Uri.parse("${server}cart.php"));

    setState(() {
      productcart = jsonDecode(response.body);
      print(response.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getcartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.chevron_back,
            color: CupertinoColors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (context) => Products()),
            );
          },
        ),
      ),

      child: SafeArea(
        child: ListView.builder(
          itemCount: productcart.length,
          itemBuilder: (context, int index) {
            final item = productcart;

            Future<void> delete_itemcart() async {
              final response = await http.post(
                Uri.parse("${server}delete_itemcart.php"),
                body: {"id": item[index]["id"]},
              );
              print(response.body);
              if (response.body == "Successful") {
                getcartData();
              }
            }

            int quantity = int.parse(productcart[index]["total_quantity"]);

            if (quantities.length <= index) {
              quantities.add(quantity);
            }

            double totalprice =
                (quantities[index]) * double.parse(item[index]["price"]);

            Future<void> buyNow() async {
              final response = await http.post(
                Uri.parse("${server}cartbuy.php"),
                body: {
                  "cartid": item[index]["cartid"].toString(),
                  "productid": item[index]["id"].toString(),
                  "name": productcart[index]["name"],
                  "quantity": quantity.toString(),
                },
              );
              print(response.body);
              if (response.statusCode == 200) {
                setState(() {
                  productReceipt = item[index]["name"];
                  priceReceipt = item[index]["price"];
                  priceTotal = totalprice.toString();
                  quantityReceipt = quantity.toString();
                });

                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      content: Column(
                        children: [
                          Text(
                            "Processing Purchase",
                            style: TextStyle(fontSize: 15),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CupertinoActivityIndicator(),
                          ),
                        ],
                      ),
                    );
                  },
                );

                Timer(Duration(seconds: 3), () {
                });

                getcartData();
              }
            }

            int stock = int.parse(item[index]["stock"]);

            return CupertinoListTile(
              title: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemFill,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ClipOval(
                                child: Image.network(
                                  server + productcart[index]["productimage"],
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          stock != 0
                              ? Row(
                                children: [
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: const Icon(
                                      CupertinoIcons.minus,
                                      size: 18,
                                      color: CupertinoColors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (quantities[index] > 1) {
                                          quantities[index]--;
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    "${quantities[index]}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: const Icon(
                                      CupertinoIcons.add,
                                      size: 18,
                                      color: CupertinoColors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (quantities[index] < stock) {
                                          quantities[index]++;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              )
                              : Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  0,
                                  0,
                                  10,
                                ),
                                child: Text(
                                  "Out of stock",
                                  style: TextStyle(
                                    color: CupertinoColors.destructiveRed,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                        ],
                      ),

                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  productcart[index]["name"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "₱" + productcart[index]["price"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            stock != 0
                                ? Text(
                                  "Stock: $stock",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    letterSpacing: 1.1,
                                  ),
                                )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.2,
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                              ),
                              child: CupertinoButton(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: CupertinoColors.destructiveRed,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.delete,
                                      color: CupertinoColors.destructiveRed,
                                      size: 15,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        content: Text(
                                          "Are you sure you want to delete this?",
                                        ),

                                        actions: [
                                          CupertinoButton(
                                            child: Text(
                                              "Confirm",
                                              style: TextStyle(
                                                color:
                                                    CupertinoColors
                                                        .destructiveRed,
                                              ),
                                            ),
                                            onPressed: () {
                                              delete_itemcart();
                                              Navigator.pop(context);
                                            },
                                          ),
                                          CupertinoButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color:
                                                    CupertinoColors.systemGreen,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.2,
                              decoration: BoxDecoration(
                                color: CupertinoColors.activeGreen,
                              ),
                              child: CupertinoButton(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Buy Now",
                                      style: TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "$totalprice",
                                      style: TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  stock != 0
                                      ? showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            content: Text(
                                              "Would you like to purchase this item now?",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            actions: [
                                              CupertinoButton(
                                                child: Text(
                                                  "Buy Now",
                                                  style: TextStyle(
                                                    color:
                                                        CupertinoColors
                                                            .activeBlue,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  buyNow(); // Replace with your purchase logic
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoButton(
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color:
                                                        CupertinoColors
                                                            .systemRed,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                      : showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            content: Text(
                                              "Item unavailable or quantity exceeds stock.",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            actions: [
                                              CupertinoButton(
                                                child: Text(
                                                  "Close",
                                                  style: TextStyle(
                                                    color:
                                                        CupertinoColors
                                                            .systemRed,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
