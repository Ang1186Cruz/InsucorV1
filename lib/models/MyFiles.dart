import 'package:flutter/material.dart';
import 'package:flutter_shop_app/constants.dart';

class CloudStorageInfo {
  final String? svgSrc, title, cantidadCliente;
  final int? totaltarea, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.cantidadCliente,
    this.totaltarea,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "TAREAS",
    totaltarea: 4,
    svgSrc: "assets/icons/drop_box.svg",
    cantidadCliente: "10 ",
    color: primaryColor,
    percentage: 40,
  ),
];
