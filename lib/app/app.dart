import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lrl_shopping/core/blocs/theme_cubit.dart';
import 'package:lrl_shopping/core/injection/dependency_injection.dart';
import 'package:lrl_shopping/feature/auth/presentation/pages/splash_page.dart';
import 'package:lrl_shopping/feature/products/domain/product_repository.dart';
import 'package:lrl_shopping/feature/products/presentation/cubit/product_cubit.dart';
import '../feature/auth/presentation/cubit/login_cubit.dart';
import 'flavors.dart';
import 'package:lrl_shopping/core/injection/dependency_injection.dart' as di;
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (_) => di.sl<LoginCubit>(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<ProductCubit>(
          create: (_) {
            return ProductCubit(productRepository: sl<ProductRepository>());
          },
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return Builder(
            builder: (context) {
              return Directionality(
                textDirection: ui.TextDirection.ltr,
                child: _flavorBanner(
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: Flavors.title,
                    theme: theme,
                    locale: context.locale,
                    supportedLocales: context.supportedLocales,
                    localizationsDelegates: context.localizationDelegates,
                    home: const SplashScreen(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _flavorBanner({
    required Widget child,
    bool show = true,
  }) {
    return show
        ? Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Banner(
              location: BannerLocation.topStart,
              message: Flavors.name,
              color: Colors.green.withOpacity(0.6),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                letterSpacing: 1.0,
              ),
              textDirection: ui.TextDirection.ltr,
              child: child,
            ),
          )
        : child;
  }
}
