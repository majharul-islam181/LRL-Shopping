import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lrl_shopping/core/language/app_language.dart';
import '../core/theme/theme.dart';
import '../feature/auth/presentation/cubit/login_cubit.dart';
import '../feature/auth/presentation/pages/login_page.dart';
import 'flavors.dart';
import '../pages/my_home_page.dart';
import 'package:lrl_shopping/core/injection/dependency_injection.dart' as di;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return el.EasyLocalization(
      supportedLocales: AppLanguage.all,
      path: AppLanguage.path,
      fallbackLocale: AppLanguage.english,
      startLocale: AppLanguage.english,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Flavors.title,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: _flavorBanner(
          // child: const MyHomePage(),
          child: BlocProvider<LoginCubit>(
            create: (_) => di.sl<LoginCubit>(), // Inject LoginCubit
            child: LoginPage(), // LoginPage widget
          ),
          show: kDebugMode,
        ),
      ),
    );
  }

  Widget _flavorBanner({
    required Widget child,
    bool show = true,
  }) =>
      show
          ? Banner(
              location: BannerLocation.topStart,
              message: Flavors.name,
              color: Colors.green.withOpacity(0.6),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  letterSpacing: 1.0),
              textDirection: TextDirection.ltr,
              child: child,
            )
          : Container(
              child: child,
            );
}
