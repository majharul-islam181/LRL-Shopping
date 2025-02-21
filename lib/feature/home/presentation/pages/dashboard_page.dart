import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lrl_shopping/core/language/generated/locale_keys.g.dart';
import 'package:lrl_shopping/feature/auth/domain/entites/user.dart';

class DashboardPage extends StatelessWidget {
  final User user; 

  const DashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.title.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.title.tr(), 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("ID: ${user.id}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Name: ${user.name}", style: const TextStyle(fontSize: 16)),
            Text("Email: ${user.email}", style: const TextStyle(fontSize: 16)),
            Text("Mobile: ${user.mobile}", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
