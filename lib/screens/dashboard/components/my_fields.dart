import 'package:flutter/material.dart';
//import 'package:flutter_shop_app/models/MyFiles.dart';
import 'package:flutter_shop_app/providers/responsive.dart';
import 'package:flutter_shop_app/providers/infoDashboard.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
    this.listRouterInfoShow = const [],
    this.mostrarFecha = false,
  }) : super(key: key);

  final List<RouterInfo> listRouterInfoShow;
  final bool mostrarFecha;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    final String formatter = DateFormat.yMMMMd('es_AR').format(now);

    return Column(
      children: [
        this.mostrarFecha
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatter,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              )
            : Row(),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            listRouterInfoShow11: this.listRouterInfoShow,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(
              listRouterInfoShow11: this.listRouterInfoShow),
          desktop: FileInfoCardGridView(
            listRouterInfoShow11: this.listRouterInfoShow,
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView(
      {Key? key,
      this.listRouterInfoShow11 = const [],
      this.crossAxisCount = 4,
      this.childAspectRatio = 1})
      : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List<RouterInfo> listRouterInfoShow11;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listRouterInfoShow11.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          FileInfoCard(info: listRouterInfoShow11[index]),
    );
  }
}
