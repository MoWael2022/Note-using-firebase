import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Loading(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      });
}
