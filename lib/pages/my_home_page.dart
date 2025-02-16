// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:lrl_shopping/app/flavors.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Flavors.title),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            FirebaseCrashlytics.instance.crash();
          },
          child: Text(
            'Hello ${Flavors.title}',
            style: TextStyle(),
          ),
        ),
      ),
    );
  }
}