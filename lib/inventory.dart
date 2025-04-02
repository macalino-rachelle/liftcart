import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftcart/inventoryadd.dart';
import 'package:liftcart/inventoryedit.dart';
import 'package:liftcart/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'variables.dart';

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({super.key});

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> {
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

      final response = await http.get(Uri.parse(server + "product_view.php"));

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          systemLoading = false;
          serverError = false;
        });

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
            middle: Text(
              "Products Management",
              style: TextStyle(letterSpacing: 1.1, fontWeight: FontWeight.w500),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.add, color: CupertinoColors.white),
              onPressed: () {
                btnState
                    ? Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) => AddItem()),
                    )
                    : null;
              },
            ),
          ),

          child: SafeArea(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, int index) {
                final item = products;

                Future<void> delete_item() async {
                  final response = await http.post(
                    Uri.parse(server + "delete_item.php"),
                    body: {"id": item[index]["id"]},
                  );
                  print(response.body);
                  if (response.statusCode == 200) {
                    getData();
                    setState(() {
                      btnState = true;
                    });
                  }
                }

                return CupertinoFormSection.insetGrouped(
                  header: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 15.0,
                    ),
                    child: Text(
                      products[index]["name"],
                      style:
                          CupertinoTheme.of(
                            context,
                          ).textTheme.navTitleTextStyle,
                    ),
                  ),
                  children: [
                    CupertinoFormRow(
                      prefix: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ClipOval(
                            child: Image.network(
                              server + products[index]["productimage"],
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stock: ${products[index]["stock"]}",
                              style: CupertinoTheme.of(
                                context,
                              ).textTheme.textStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.8,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  "Price: ${products[index]["price"]}",
                                  style: CupertinoTheme.of(
                                    context,
                                  ).textTheme.textStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    CupertinoFormRow(
                      prefix: SizedBox.shrink(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              CupertinoIcons.pencil,
                              color: CupertinoColors.systemGreen,
                            ),
                            onPressed: () {
                              setState(() {
                                editpname = products[index]["name"];
                                editpstock = products[index]["stock"];
                                editpprice = products[index]["price"];
                                editpid = products[index]["id"];
                                editpimage = products[index]["productimage"];
                              });
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => EditItem(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              CupertinoIcons.trash_fill,
                              color: CupertinoColors.destructiveRed,
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
                                                CupertinoColors.destructiveRed,
                                          ),
                                        ),
                                        onPressed: () {
                                          delete_item();
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
                                            color: CupertinoColors.systemGreen,
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
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
  }
}
