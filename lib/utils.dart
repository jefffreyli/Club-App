import 'package:flutter/material.dart';

String appName = 'SciClubs';
TextStyle h3 = const TextStyle(
    color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500);
TextStyle h2 = const TextStyle(
    color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500);
TextStyle h4 = const TextStyle(
    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);

Color blue = const Color(0xff8DBBF1);
Color red = const Color(0xffF9CEDF);
Color yellow = const Color(0xffFDEECB);
Color yellowOrange = const Color(0xffFFECC7);
Color yellowOrangeDark = const Color(0xff6D392F);
Color grey = const Color(0xffD7DDE9);
Color green_1 = const Color(0xff2CA63E);
Color green_2 = const Color(0xff004F43);

String fillerNetworkImage =
    "https://i.seadn.io/gae/2hDpuTi-0AMKvoZJGd-yKWvK4tKdQr_kLIpB_qSeMau2TNGCNidAosMEvrEXFO9G6tmlFlPQplpwiqirgrIPWnCKMvElaYgI-HiVvXc?auto=format&w=1000";

void navigate(BuildContext context, Widget w) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => w),
  );
}
