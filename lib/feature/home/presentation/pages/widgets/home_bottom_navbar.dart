import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lrl_shopping/core/language/generated/locale_keys.g.dart';
import 'package:lrl_shopping/feature/auth/domain/entites/user.dart';
import 'package:lrl_shopping/feature/home/presentation/pages/dashboard_page.dart';
import 'package:lrl_shopping/feature/home/presentation/pages/setting_page.dart';
import 'package:lrl_shopping/feature/products/presentation/pages/product_list_page.dart';

class HomeBottomNavBar extends StatefulWidget {
  final User user;

  const HomeBottomNavBar({super.key, required this.user});

  @override
  State<HomeBottomNavBar> createState() => _HomeBottomNavBarState();
}

class _HomeBottomNavBarState extends State<HomeBottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          // ? DashboardPage(user: widget.user)
          ? const ProductListScreen()
          : const SettingsPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: LocaleKeys.title.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: "Settings".tr(),
          ),
        ],
      ),
    );
  }
}
