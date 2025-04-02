import 'package:flutter/cupertino.dart';
import 'package:liftcart/inventory.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'variables.dart';
import 'package:flutter/services.dart';

class EditItem extends StatefulWidget {
  const EditItem({super.key});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  TextEditingController _productname = TextEditingController(text: editpname);
  TextEditingController _stock = TextEditingController(text: editpstock);
  TextEditingController _price = TextEditingController(text: editpprice);
  String image = editpimage;
  String _id = editpid;

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
        image = image + "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxfdafda3123132";
      });
      print("Resized Image Path: ${_image!.path}");
    }
  }

  Future<void> EditItem(String name, String stock, String price) async {
    if (name.isEmpty || stock.isEmpty || price.isEmpty) {
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
        Uri.parse(server + "update_item.php"),
      );

      request.fields['name'] = name;
      request.fields['id'] = _id;
      request.fields['stock'] = stock;
      request.fields['price'] = price;
      request.fields['defaultimage'] = image;

      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _image!.path),
        );

        print(_image!.path);

        print("Image file added: ${_image!.path}");
      }

      request.headers['Content-Type'] = 'multipart/form-data';

      var response = await request.send();

      if (response.statusCode == 200) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text("Product Updated Successfully!"),
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
                "Failed to update product. Status code: ${response.statusCode}",
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
          "Edit Product",
          style: TextStyle(letterSpacing: 1.1, fontWeight: FontWeight.w500),
        ),
      ),

      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Column(
              children: [
                SizedBox(height: 15),

                // Product Name Section
                Row(
                  children: [
                    Text(
                      "Product Name",
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                CupertinoTextField(
                  controller: _productname,
                  placeholder: "Product name",
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1.5,
                      color: CupertinoColors.systemGrey4,
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Quantity Section
                Row(
                  children: [
                    Text(
                      "Quantity",
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                CupertinoTextField(
                  controller: _stock,
                  placeholder: "Quantity",
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1.5,
                      color: CupertinoColors.systemGrey4,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),

                SizedBox(height: 15),

                // Price Section
                Row(
                  children: [
                    Text(
                      "Price",
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                CupertinoTextField(
                  controller: _price,
                  placeholder: "Price",
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1.5,
                      color: CupertinoColors.systemGrey4,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                ),

                SizedBox(height: 25),

                // Image Picker Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Pick Image Button
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

                        // Update Product Button
                        GestureDetector(
                          onTap: () {
                            btnState
                                ? EditItem(
                                  _productname.text,
                                  _stock.text,
                                  _price.text,
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
                              "Update Product",
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
      ),
    );
  }
}
