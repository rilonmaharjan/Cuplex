import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingWidget([color, size]) {
  return SpinKitFadingCircle(
    color: color ?? const Color(0xffecc877),
  );
}