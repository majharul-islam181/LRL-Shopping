// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:lrl_shopping/app/flavors.dart';


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Flavors.title),
      ),
      body: Center(
        child: Text(
          'Hello ${Flavors.title}',
        ),
      ),
    );
  }
}
