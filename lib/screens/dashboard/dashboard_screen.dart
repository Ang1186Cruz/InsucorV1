import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/dashboard/components/my_fields.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

import '../../providers/auth.dart';
import '../../providers/infoDashboard.dart';
import 'components/list_collect.dart';
import 'components/list_routers.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      MyFiles(
                          listRouterInfoShow: listRouterInfo,
                          mostrarFecha: true),
                      SizedBox(
                        height: 50,
                      ),
                      (auth.rolId == '1') ? ListCollects() : ListRouters(),
                      (auth.rolId == '1')
                          ? MyFiles(
                              listRouterInfoShow: listRutasAdminInfo,
                              mostrarFecha: false)
                          : Row(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
