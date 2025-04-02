import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftcart/inventory.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'variables.dart';
import 'package:flutter/services.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController _newprodname = TextEditingController();
  TextEditingController _newprodstock = TextEditingController();
  TextEditingController _newprodprice = TextEditingController();
  File? _image;

  Future<File> resizeImage(File originalImage) async {
    final rawImage = img.decodeImage(await originalImage.readAsBytes());
    final resizedImage = img.copyResize(rawImage!, width: 800);
    final resizedFile = File(originalImage.path)
      ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));
    return resizedFile;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File resizedImage = await resizeImage(File(pickedFile.path));
      setState(() {
        _image = resizedImage;
      });
      print("Resized Image Path: ${_image!.path}");
    }
  }

  Future<void> AddItem(String name, String stock, String price) async {
    if (name.isEmpty || stock.isEmpty || price.isEmpty || _image == null) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Missing Information"),
            content: Text("Please fill in all the fields before submitting."),
            actions: [
              CupertinoButton(
                child: Text(
                  "Close",
                  style: TextStyle(color: CupertinoColors.destructiveRed),
                ),
                onPressed: () {
                  setState(() {
                    btnState = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(server + "add_item.php"),
      );

      request.fields['name'] = name;
      request.fields['stock'] = stock;
      request.fields['price'] = price;

      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _image!.path),
        );
        print("Image file added: ${_image!.path}");
      }

      request.headers['Content-Type'] = 'multipart/form-data';

      var response = await request.send();

      if (response.statusCode == 200) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text("Product Added Successfully!"),
              actions: [
                CupertinoButton(
                  child: Text(
                    "Close",
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  onPressed: () {
                    setState(() {
                      btnState = true;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );

        var responseData = await response.stream.bytesToString();
        print("Server response: $responseData");
      } else {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text(
                "Failed to add product. Status code: ${response.statusCode}",
              ),
              actions: [
                CupertinoButton(
                  child: Text(
                    "Close",
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  onPressed: () {
                    setState(() {
                      btnState = true;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );

        var responseData = await response.stream.bytesToString();
        print("Error details: $responseData");
      }
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text("Error adding product: $e"),
            actions: [
              CupertinoButton(
                child: Text(
                  "Close",
                  style: TextStyle(color: CupertinoColors.destructiveRed),
                ),
                onPressed: () {
                  setState(() {
                    btnState = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
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
            btnState
                ? Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => InventoryManagement(),
                  ),
                )
                : null;
          },
        ),
        middle: Text(
          "Add Product",
          style: TextStyle(letterSpacing: 1.1, fontWeight: FontWeight.w500),
        ),
      ),

      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container to hold everything in a clean, card-like style
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Title for Product Name
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Product Name",
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Product Name Input Field with clean, borderless style
                        CupertinoTextField(
                          controller: _newprodname,
                          placeholder: "Enter product name",
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemFill,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1.5,
                              color: CupertinoColors.systemGrey4,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Title for Quantity
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Quantity",
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Quantity Input Field with clean, borderless style
                        CupertinoTextField(
                          controller: _newprodstock,
                          placeholder: "Enter quantity",
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemFill,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1.5,
                              color: CupertinoColors.systemGrey4,
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        SizedBox(height: 20),

                        // Title for Price
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Price",
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Price Input Field with clean, borderless style
                        CupertinoTextField(
                          controller: _newprodprice,
                          placeholder: "Enter price",
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemFill,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1.5,
                              color: CupertinoColors.systemGrey4,
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[0-9.,]'),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),

                        // Image Picker Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Display Selected Image or Placeholder in Circular Avatar
                            SizedBox(width: 30),

                            // Column for Image Picker and Add Product Button
                            Column(
                              children: [
                                // Pick Image Button styled as a modern button
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 25,
                                    ),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.activeBlue,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Text(
                                      "Pick Image",
                                      style: TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),

                                // Add Product Button with modern look
                                GestureDetector(
                                  onTap: () {
                                    btnState
                                        ? AddItem(
                                          _newprodname.text,
                                          _newprodstock.text,
                                          _newprodprice.text,
                                        )
                                        : null;

                                    setState(() {
                                      btnState = false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 25,
                                    ),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.activeGreen,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Text(
                                      "Add Product",
                                      style: TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
