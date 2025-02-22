import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lrl_shopping/core/language/app_language.dart';
import 'package:lrl_shopping/feature/auth/domain/entites/user.dart';
import 'package:lrl_shopping/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:lrl_shopping/feature/home-settings/presentation/widgets/setting_title.dart';
import '../../../../core/blocs/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  final User user;
  const SettingsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings".tr(),
          style: GoogleFonts.roboto(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                      const AssetImage("assets/icons/dev-icon.png"),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${"name".tr()}: ${user.name}",
                        style: const TextStyle(fontSize: 16)),
                    Text("${"email".tr()}: ${user.email}".tr(),
                        style: const TextStyle(fontSize: 16)),
                    Text("${"mobile".tr()}: ${user.mobile}",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("general".tr(), context),
          SettingsTile(
            icon: Icons.language,
            title: "language".tr(),
            subtitle: "choose_language".tr(),
            onTap: () => _showLanguageDialog(context),
            iconColor: iconColor,
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("appearance".tr(), context),
          BlocBuilder<ThemeCubit, ThemeData>(
            builder: (context, theme) {
              return SettingsTile(
                icon: theme.brightness == Brightness.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                title: "dark_mode".tr(),
                subtitle: theme.brightness == Brightness.dark
                    ? "currently_enabled".tr()
                    : "currently_disabled".tr(),
                onTap: () => context.read<ThemeCubit>().toggleTheme(),
                trailing: Switch(
                  value: theme.brightness == Brightness.dark,
                  onChanged: (value) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
                iconColor: iconColor,
              );
            },
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("account".tr(), context),
          SettingsTile(
            icon: Icons.logout,
            title: "logout".tr(),
            subtitle: "sign_out".tr(),
            onTap: () => context.read<LoginCubit>().logoutUser(),
            iconColor: iconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.7),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Language".tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                onTap: () {
                  _changeLanguage(context, Language.english);
                },
              ),
              ListTile(
                title: const Text("বাংলা"),
                onTap: () {
                  _changeLanguage(context, Language.bengali);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔥 Function to Change Language
  void _changeLanguage(BuildContext context, Language language) {
    context.setLocale(language.locale);
    Navigator.pop(context);
  }
}
