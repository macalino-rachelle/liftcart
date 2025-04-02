import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftcart/orderview.dart';
import 'package:liftcart/orderviewreceipt.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'variables.dart';

class Purchased extends StatefulWidget {
  const Purchased({super.key});

  @override
  State<Purchased> createState() => _PurchasedState();
}

class _PurchasedState extends State<Purchased> {
  @override
  Future<void> getpurchasedData() async {
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

      final response = await http.get(Uri.parse(server + "purchased.php"));

      if (response.statusCode == 200) {
        print("FETCHED");
        setState(() {
          purchased = jsonDecode(response.body);
          systemLoading = false;
          serverError = false;
        });

        if (purchased.isNotEmpty) {
          print(purchased[0]);
          print("OKAY");
        } else {
          print("The purchased is empty.");
        }

        print(response.body);
        print(purchased[0]);
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
    getpurchasedData();
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
                            onPressed: getpurchasedData,
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
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => Products()),
                );
              },
            ),
            middle: Text(
              "Completed Orders",
              style: TextStyle(letterSpacing: 1.1, fontWeight: FontWeight.w500),
            ),
          ),

          child: SafeArea(
            child: ListView.builder(
              itemCount: purchased.length,
              itemBuilder: (context, int index) {
                final purchaseditems = purchased;

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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ClipOval(
                                child: Image.network(
                                  server +
                                      purchaseditems[index]["productimage"],
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        5,
                                        20,
                                        10,
                                        0,
                                      ),
                                      child: Text(
                                        purchaseditems[index]["item"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    5,
                                    0,
                                    10,
                                    0,
                                  ),
                                  child: Text(
                                    "Price: ₱" + purchaseditems[index]["price"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    5,
                                    0,
                                    10,
                                    0,
                                  ),
                                  child: Text(
                                    "Total Price: " +
                                        purchaseditems[index]["totalprice"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    5,
                                    0,
                                    10,
                                    0,
                                  ),
                                  child: Text(
                                    "Total: " +
                                        purchaseditems[index]["quantity"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),
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
