import 'package:farmers_market/src/blocs/auth_bloc.dart';
import 'package:farmers_market/src/blocs/admin_bloc.dart';
import 'package:farmers_market/src/models/admin.dart';
import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:farmers_market/src/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(context),
      );
    } else {
      return Scaffold(
        body: pageBody(context),
      );
    }
  }

  Widget pageBody(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    final vendorBloc = Provider.of<AdminBloc>(context);

    return StreamBuilder<Admin>(
        stream: vendorBloc.admin,
        builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                  child: (snapshot.data != null)
                      ? ListView(
                          children: [
                            Padding(
                              padding: BaseStyles.listPadding,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 2,
                                      child: ClipRRect(
                                    child: Image.network(snapshot.data.imageUrl),
                                    borderRadius: BorderRadius.circular(
                                      BaseStyles.borderRadius,
                                    ),
                                  )),
                                  SizedBox(width:15.0),
                                  Flexible(  
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Text(snapshot.data.name,style:TextStyles.listTitle),
                                      Text(snapshot.data.position,style:TextStyles.body)
                                    ],),
                                  )
                                ],
                              ),
                            ),
                            AppButton(buttonText: 'Edit Admin Profile',
                            buttonType: ButtonType.LightBlue,
                            onPressed: () => Navigator.of(context).pushNamed('/editvendor/${authBloc.userId}'),)
                          ],
                        )
                      : Center(
                          child: AppButton(
                            buttonText: 'Create Admin Profile',
                            buttonType: ButtonType.LightBlue,
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/editvendor'),
                          ),
                        )),
              Container(
                  height: 50.0,
                  child: (Platform.isIOS)
                      ? CupertinoButton(
                          child: Text(
                            'Logout',
                            style: TextStyle(color: AppColors.straw),
                          ),
                          onPressed: () => authBloc.logout(),
                        )
                      : FlatButton(
                          child: Text('Logout',
                              style: TextStyle(color: AppColors.straw)),
                          onPressed: () => authBloc.logout(),
                        ))
            ],
          );
        });
  }
}
