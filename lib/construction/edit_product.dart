import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_market/src/screens/admin_menu.dart';
import 'package:farmers_market/src/styles/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:progress_dialog/progress_dialog.dart';

class EditProduct extends StatefulWidget {
  static const String id = 'AddProducts';
  final String productName, weight,
      productDesc,
      category,
      subcategory,
      image,
      productId;
  final int price, availble;
  EditProduct(
      {Key key,
      this.productName,
        this.weight,
      this.productDesc,
      this.category,
      this.subcategory,
      this.price,
      this.availble,
      this.image,
      this.productId})
      : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String userName,
      photoUrl,
      _postID,
      _uploadedImageURL = '',
      error = '',
      onlineImage;
  ProgressDialog pr;
  bool profileImage = false;
  final _productName = TextEditingController();
  final _productDesc = TextEditingController();
  final _price = TextEditingController();
  final _available = TextEditingController();
  final _weight = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  File pickedImage;
  final _picker = ImagePicker();
  getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery

    var image = await _picker.getImage(source: source);

    //Cropping the image

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      pickedImage = croppedFile;
      print(pickedImage.lengthSync());
    });
  }

  void _uploadProduct() async {
    try {
      User _currentUser = await FirebaseAuth.instance.currentUser;
      String uid = _currentUser.uid;
      if (pickedImage != null) {
        pr.show();
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('products/${Path.basename(pickedImage.path)}}');
        UploadTask uploadTask = storageReference.putFile(pickedImage);
        await uploadTask;
        print('File Uploaded');
        storageReference.getDownloadURL().then((fileURL) async {
          _uploadedImageURL = fileURL;
          DocumentReference _docRef = productRef.doc(widget.productId);
          await _docRef.update({
            'productName': _productName.text,
            'subCategory': _subCategory,
            'unitPrice': int.parse(_price.text),
            'availableUnits': int.parse(_available.text),
            'imageUrl': _uploadedImageURL,
            'description': _productDesc.text,
            'weight': _weight.text,
            'category': _category,
          }).then((_) {
            pr.hide();
            Fluttertoast.showToast(
                msg: "Product Successfully added",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            pickedImage = null;
            _productName.clear();
            _price.clear();
            _productDesc.clear();
            _available.clear();
            _weight.clear();
          }).catchError((onError) {
            pr.hide();
            Fluttertoast.showToast(
                msg: "$onError",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          });
        });
      } else {
        DocumentReference _docRef = productRef.doc(widget.productId);
        await _docRef.update({
          'productName': _productName.text,
          'subCategory': _subCategory,
          'unitPrice': int.parse(_price.text),
          'availableUnits': int.parse(_available.text),
          'imageUrl': onlineImage,
          'weight': _weight.text,
          'description': _productDesc.text,
          'category': _category,
        }).then((_) {
          pr.hide();
          Fluttertoast.showToast(
              msg: "Product Successfully updated",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          pickedImage = null;
          _productName.clear();
          _price.clear();
          _productDesc.clear();
          _available.clear();
          _weight.clear();
        }).catchError((onError) {
          pr.hide();
          Fluttertoast.showToast(
              msg: "$onError",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        });
      }
    } catch (e) {}

  }

  String _category, _subCategory;

  @override
  void initState() {
    if (mounted) {
      setState(() {
        _productName.text = widget.productName;
        _productDesc.text = widget.productDesc;
        _price.text = widget.price.toString();
        _available.text = widget.availble.toString();
        _category = widget.category;
        _subCategory = widget.subcategory;
        onlineImage = widget.image;
        _weight.text = widget.weight;
      });
    }
    super.initState();
    //getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait, Updating Product');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 3.0,
        titleSpacing: -3.0,
        title: Text(
          'Update Product',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              offset: Offset(0.0, 2.5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PostLabel(label: 'Product Name'),
              SizedBox(height: 9.5),
              PostTextFeild(
                isBorder: true,
                capitalization: TextCapitalization.sentences,
                hint: 'Type the product name',
                maxLines: 1, //fix
                textController: _productName,
              ),
              SizedBox(height: 9.5),
              PostLabel(label: 'Product Description'),
              SizedBox(height: 9.5),
              PostTextFeild(
                isBorder: true,
                capitalization: TextCapitalization.sentences,
                hint: 'Type the product description',
                maxLines: 3, //fix
                textController: _productDesc,
              ),
              SizedBox(height: 16.5),
              PostLabel(label: 'Product Category'),
              SizedBox(height: 9.5),
              DropdownButtonFormField<String>(
                hint: Text('Select Category'),
                value: _category,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 25.0,
                elevation: 0,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(),
                onChanged: (String newValue) {
                  setState(() {
                    _category = newValue;
                    print(_category);
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.5),
              PostLabel(
                label: 'Product Sub Category',
              ),
              SizedBox(height: 9.5),
              DropdownButtonFormField<String>(
                hint: Text('Select Sub Category'),
                value: _subCategory,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 25.0,
                elevation: 0,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(),
                onChanged: (String newValue) {
                  setState(() {
                    _subCategory = newValue;
                    print(_subCategory);
                  });
                },
                items:
                    subCategories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.5),
              PostLabel(label: 'Product Price'),
              SizedBox(height: 9.5),
              PostTextFeild(
                isBorder: true,
                capitalization: TextCapitalization.sentences,
                hint: 'Product Price',
                keyboardType: TextInputType.number,
                textController: _price,
              ),
              SizedBox(height: 16.5),
              PostLabel(label: 'Quantity Available'),
              SizedBox(height: 9.5),
              PostTextFeild(
                isBorder: true,
                capitalization: TextCapitalization.sentences,
                hint: 'quantity available',
                maxLines: 1, //fix
                keyboardType: TextInputType.number,
                textController: _available,
              ),
              SizedBox(height: 16.5),
              PostLabel(label: 'Weight of Product'),
              SizedBox(height: 9.5),
              PostTextFeild(
                isBorder: true,
                capitalization: TextCapitalization.sentences,
                hint: 'weight in kg',
                maxLines: 1, //fix
                keyboardType: TextInputType.text,
                textController: _weight,
              ),
              SizedBox(height: 16.5),
              DiscussOutlineButton(
                onTap: () {
                  getImageFile(ImageSource.gallery);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Add Photo',
                      style: TextStyle(color: Colors.grey, fontSize: 13.0),
                    ),
                    Icon(
                      Icons.add_a_photo,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 41.5),
              pickedImage != null
                  ? Center(
                      child: Image.file(
                        pickedImage,
                        width: 160,
                        height: 160,
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Image.network(
                          onlineImage,
                          width: 160,
                          height: 160,
                        ),
                      ),
                    ),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: PrimaryButton(
                  width: 120,
                  height: 36.5,
                  blurRadius: 3.0,
                  roundedEdge: 5.0,
                  color: Colors.green,
                  buttonTitle: 'Post Product',
                  onTap: () {
                    if (_productName.text != '' &&
                        _productDesc.text != '' &&
                        _price.text != '' &&
                        _category != '' &&
                        _weight.text!='' &&
                        _available.text != '' &&
                        _subCategory != '') {
                      _uploadProduct();
                    } else {
                      setState(() {
                        error =
                            'Product Name, Description, price and available Quantity cannot be empty';
                      });
                    }
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

class PostDropDownButton extends StatelessWidget {
  const PostDropDownButton({
    Key key,
    this.hint,
    this.onChanged,
    this.items,
    this.value,
    this.isBorder,
  }) : super(key: key);
  final Widget hint;
  final Function onChanged;
  final List<String> items;
  final String value;
  final bool isBorder;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: hint,
      value: value,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 25.0,
      elevation: 0,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        border: (isBorder != null)
            ? (isBorder)
                ? OutlineInputBorder()
                : OutlineInputBorder(borderSide: BorderSide.none)
            : OutlineInputBorder(borderSide: BorderSide.none),
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class PostTextFeild extends StatelessWidget {
  const PostTextFeild(
      {Key key,
      this.hint,
      this.height,
      this.maxLines,
      this.textController,
      bool isBorder,
      this.capitalization,
      this.keyboardType})
      : super(key: key);
  final String hint;
  final double height;
  final int maxLines;
  final TextEditingController textController;
  final TextCapitalization capitalization;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        maxLines: maxLines,
        textCapitalization: capitalization,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        controller: textController,
      ),
    );
  }
}

class PostLabel extends StatelessWidget {
  const PostLabel({
    Key key,
    this.label,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
