import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lrl_shopping/feature/auth/presentation/cubit/login_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings".tr())),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read<LoginCubit>().logoutUser(),
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
