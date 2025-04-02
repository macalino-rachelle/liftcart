import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
  CupertinoApp(
    theme: CupertinoThemeData(brightness: Brightness.dark),
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ),
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> checkdatabase() async {
    final response = await http.get(Uri.parse(server + "dbcon.php"));
    print(response.body);
  }

  @override
  @override
  void initState() {
    checkdatabase();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          child: Icon(CupertinoIcons.settings, color: CupertinoColors.white),
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      'Team Members',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  content: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  "images/maryjoy.jpg",
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Artienda, Mary Joyce",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Developer",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  "images/aaron.jpg",
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Avendano, Aaron Jireh",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Developer",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  "images/joseph.jpg",
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Basilio, Joseph Lee",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Developer",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  "images/joel.jpg",
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dizon, Joel",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Developer",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  "images/rachelle.jpg",
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Macalino, Rachelle Anne",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Developer",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  "images/jomel.jpg",
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Simbillo, Jomel",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Developer",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoButton(
                      child: Text(
                        'Close',
                        style: TextStyle(color: CupertinoColors.destructiveRed),
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

      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 160),
              Text(
                'LIFTCART',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 15),
              Image.asset('images/fitness.png', width: 100, height: 100),
              SizedBox(height: 15),

              Container(
                width: 160,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemFill.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CupertinoButton(
                  child: Text(
                    "Shop",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) => Products()),
                    );
                  },
                ),
              ),
              SizedBox(height: 15),

              Container(
                width: 160,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemFill.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CupertinoButton(
                  child: Text(
                    "Inventory",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
