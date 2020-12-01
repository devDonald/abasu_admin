import 'dart:async';
import 'dart:io';

import 'package:farmers_market/src/blocs/auth_bloc.dart';
import 'package:farmers_market/src/blocs/product_bloc.dart';
import 'package:farmers_market/src/blocs/admin_bloc.dart';
import 'package:farmers_market/src/models/admin.dart';
import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:farmers_market/src/widgets/button.dart';
import 'package:farmers_market/src/widgets/sliver_scaffold.dart';
import 'package:farmers_market/src/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditAdmin extends StatefulWidget {
  final String adminId;

  EditAdmin({this.adminId});

  @override
  _EditAdminState createState() => _EditAdminState();
}

class _EditAdminState extends State<EditAdmin> {
  StreamSubscription _savedSubscription;
  @override
  void initState() {
    var adminBloc = Provider.of<AdminBloc>(context, listen: false);
    _savedSubscription = adminBloc.adminSaved.listen((saved) {
      if (saved != null && saved == true && context != null) {
        Fluttertoast.showToast(
            msg: "Vendor Saved",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColors.lightblue,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _savedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var vendorBloc = Provider.of<AdminBloc>(context);
    var authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder<Admin>(
      stream: vendorBloc.admin,
      builder: (context, snapshot) {
        if (!snapshot.hasData && widget.adminId != null) {
          return Scaffold(
            body: Center(
                child: (Platform.isIOS)
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator()),
          );
        }

        Admin vendor = snapshot.data;

        if (vendor != null) {
          //Edit Logic
          loadValues(vendorBloc, vendor, authBloc.userId);
        } else {
          //Add Logic
          loadValues(vendorBloc, null, authBloc.userId);
        }

        return (Platform.isIOS)
            ? AppSliverScaffold.cupertinoSliverScaffold(
                navTitle: '',
                pageBody: pageBody(true, vendorBloc, context, vendor),
                context: context)
            : AppSliverScaffold.materialSliverScaffold(
                navTitle: '',
                pageBody: pageBody(false, vendorBloc, context, vendor),
                context: context);
      },
    );
  }

  Widget pageBody(bool isIOS, AdminBloc vendorBloc, BuildContext context,
      Admin existingVendor) {
    var pageLabel = (existingVendor != null) ? 'Edit Profile' : 'Add Profile';
    return ListView(
      children: <Widget>[
        Text(
          pageLabel,
          style: TextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: BaseStyles.listPadding,
          child: Divider(color: AppColors.darkblue),
        ),
        StreamBuilder<String>(
            stream: vendorBloc.name,
            builder: (context, snapshot) {
              return AppTextField(
                hintText: 'Vendor Name',
                cupertinoIcon: FontAwesomeIcons.sign,
                materialIcon: FontAwesomeIcons.sign,
                isIOS: isIOS,
                errorText: snapshot.error,
                initialText:
                    (existingVendor != null) ? existingVendor.name : null,
                onChanged: vendorBloc.changeName,
              );
            }),
        StreamBuilder<String>(
            stream: vendorBloc.position,
            builder: (context, snapshot) {
              return AppTextField(
                hintText: 'Description',
                maxLines: 7,
                cupertinoIcon: FontAwesomeIcons.book,
                materialIcon: FontAwesomeIcons.book,
                isIOS: isIOS,
                errorText: snapshot.error,
                initialText: (existingVendor != null)
                    ? existingVendor.position
                    : null,
                onChanged: vendorBloc.changePosition,
              );
            }),
        StreamBuilder<bool>(
          stream: vendorBloc.isUploading,
          builder: (context, snapshot) {
            return (!snapshot.hasData || snapshot.data == false)
                ? Container()
                : Center(
                    child: (Platform.isIOS)
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator(),
                  );
          },
        ),
        StreamBuilder<String>(
            stream: vendorBloc.imageUrl,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == "")
                return AppButton(
                  buttonType: ButtonType.Straw,
                  buttonText: 'Add Image',
                  onPressed: vendorBloc.pickImage,
                );

              return Column(
                children: <Widget>[
                  Padding(
                    padding: BaseStyles.listPadding,
                    child: Image.network(snapshot.data),
                  ),
                  AppButton(
                    buttonType: ButtonType.Straw,
                    buttonText: 'Change Image',
                    onPressed: vendorBloc.pickImage,
                  )
                ],
              );
            }),
        StreamBuilder<bool>(
            stream: vendorBloc.isValid,
            builder: (context, snapshot) {
              return AppButton(
                buttonType: (snapshot.data == true)
                    ? ButtonType.DarkBlue
                    : ButtonType.Disabled,
                buttonText: 'Save Profile',
                onPressed: vendorBloc.saveVendor,
              );
            }),
      ],
    );
  }

  loadValues(AdminBloc vendorBloc, Admin vendor, String vendorId) {
    vendorBloc.changeAdminId(vendorId);

    if (vendor != null) {
      //Edit
      vendorBloc.changeName(vendor.name);
      vendorBloc.changePosition(vendor.position);
      vendorBloc.changeImageUrl(vendor.imageUrl ?? '');
    } else {
      //Add
      vendorBloc.changeName(null);
      vendorBloc.changePosition(null);
      vendorBloc.changeImageUrl('');
    }
  }
}
