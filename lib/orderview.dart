import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:liftcart/cart.dart';
import 'package:liftcart/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<int> quantities = [];

  @override
  Future<void> getData() async {
    try {
      setState(() {
        serverError = false;
        systemLoading = true;
      });

      Timer(Duration(seconds: 3), () {
        setState(() {
          serverError = true;
        });
      });

      final response = await http.get(Uri.parse("${server}product_view.php"));

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          systemLoading = false;
          serverError = false;
        });
        print(response.body);

        if (systemLoading != true && serverError != true) {
          addcartSuccess
              ? showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    content: Text("Item Added to Cart"),
                    actions: [
                      CupertinoButton(
                        child: Text(
                          "Close",
                          style: TextStyle(
                            color: CupertinoColors.destructiveRed,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            addcartSuccess = false;
                            btnState = true;
                          });
                        },
                      ),
                    ],
                  );
                },
              )
              : null;
        }
        print(response.body);
        print(products[0]);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        serverError = true;
      });
      print("Error occurred: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return systemLoading
        ? CupertinoPageScaffold(
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 250),

                  serverError
                      ? Column(
                        children: [
                          Text(
                            "System Error",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Check your internet Connection",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: getData,
                            child: Text(
                              "Retry",
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          Text(
                            "System Loading...",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15),
                          CircularProgressIndicator(),
                        ],
                      ),
                ],
              ),
            ),
          ),
        )
        : CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                CupertinoIcons.chevron_back,
                color: CupertinoColors.white,
              ),
              onPressed: () {
                btnState
                    ? Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) => HomePage()),
                    )
                    : null;
              },
            ),

            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      CupertinoIcons.cart_fill,
                      color: CupertinoColors.white,
                    ),
                    onPressed: () {
                      btnState
                          ? Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(builder: (context) => Cart()),
                          )
                          : null;
                    },
                  ),

                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      color: CupertinoColors.white,
                    ),
                    onPressed: () {
                    },
                  ),
                ],
              ),
            ),
          ),

          child: SafeArea(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, int index) {
                final item = products;

                Future<void> addtoCart() async {
                  try {
                    final response = await http.post(
                      Uri.parse("${server}addtocart.php"),
                      body: {
                        "productid": item[index]["id"],
                        "stock": quantities[index].toString(),
                      },
                    );

                    if (response.statusCode == 200) {
                      getData();
                      setState(() {
                        addcartSuccess = true;
                      });
                    }
                  } catch (e) {
                    print("Error occurred: $e");

                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          content: Text(
                            "An error occurred. Please try again.",
                            style: TextStyle(fontSize: 15),
                          ),
                          actions: [
                            CupertinoButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: CupertinoColors.destructiveRed,
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
                  }
                }

                DateTime now = DateTime.now();

                String displaydate = DateFormat(
                  'MMMM dd, yyyy hh:mm a',
                ).format(now);
                String purchasedate = DateFormat(
                  'yyyy-MM-dd kk:mm:ss',
                ).format(now);

                if (quantities.length <= index) {
                  quantities.add(1);
                }
                int stock = int.parse(item[index]["stock"]);
                double totalprice =
                    double.parse(item[index]["price"]) * quantities[index];

                Future<void> buy() async {
                  final response = await http.post(
                    Uri.parse("${server}buy.php"),
                    body: {
                      "productid": item[index]["id"],
                      "name": item[index]["name"],
                      "quantity": quantities[index].toString(),
                      "purchasedate": purchasedate,
                      "price": item[index]["price"],
                      "totalprice": totalprice.toString(),
                    },
                  );
                  print(response.body);

                  if (response.statusCode == 200) {
                    print("Success");
                    setState(() {
                      productReceipt = item[index]["name"];
                      priceReceipt = item[index]["price"];
                      priceTotal = totalprice.toString();
                      quantityReceipt = quantities[index].toString();
                      dateReceipt = displaydate;
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

                    Timer(Duration(seconds: 1), () {
                      Navigator.of(context).pop();
                      setState(() {
                        btnState = true;
                      });
                      Timer(Duration(seconds: 1), () {
                      });
                    });

                    quantities[index] = 1;
                  } else {
                    setState(() {
                      btnState = true;
                    });
                    print("Failed");
                  }
                }

                return CupertinoListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 140,
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
                                      server + products[index]["productimage"],
                                      height: 50,
                                      width: 50,
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
                                            if (int.parse(
                                                  products[index]["stock"],
                                                ) !=
                                                quantities[index]) {
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
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  products[index]["name"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "₱" + products[index]["price"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white70,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                stock != 0
                                    ? Text(
                                      "Stk: $stock",
                                      style: const TextStyle(
                                        color: Colors.white70,
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
                                        const Text(
                                          'Add to',
                                          style: TextStyle(
                                            color: CupertinoColors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Text(
                                          'Cart',
                                          style: TextStyle(
                                            color: CupertinoColors.black,
                                            fontSize: 15,
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
                                                title: Text(
                                                  "Add  ${products[index]["name"]} to your cart?",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),

                                                actions: [
                                                  CupertinoButton(
                                                    child: Text(
                                                      "Confirm",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      addtoCart();
                                                      setState(() {
                                                        btnState = false;
                                                      });
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
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
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

                                const SizedBox(height: 20),
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.2,
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGreen,
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
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
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
                                                      buy();
                                                      setState(() {
                                                        btnState = false;
                                                      });
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
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
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
