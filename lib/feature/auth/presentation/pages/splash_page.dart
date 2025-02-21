// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lrl_shopping/feature/auth/presentation/cubit/login_cubit.dart';
// import 'package:lrl_shopping/feature/home/presentation/pages/home_page.dart';
// import 'login_page.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkAuthentication();

//   }

//   void _checkAuthentication() async {
//     final loginCubit = context.read<LoginCubit>();
//     final token = await loginCubit.storageService.getToken();

//     Future.delayed(const Duration(seconds: 2), () {
//       if (token != null) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Image.asset(
//           'assets/icons/dev-icon.png', 
//           width: 150,
//           height: 150,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lrl_shopping/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:lrl_shopping/feature/home/presentation/pages/home_page.dart';
import 'package:lrl_shopping/feature/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lrl_shopping/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:lrl_shopping/feature/home/presentation/pages/home_page.dart';
import 'package:lrl_shopping/feature/auth/presentation/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _imageLoaded = true; // Default to true

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating loading time

    if (!mounted) return; // Ensure widget is still in the tree

    final loginCubit = context.read<LoginCubit>();
    final token = await loginCubit.storageService.getToken();

    if (!mounted) return; // Check again before navigation

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => token != null ? const HomePage() :  LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageLoaded
                ? Image.asset(
                    'assets/icons/dev-icon.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      print("❌ ERROR: Unable to load dev-icon.png"); // Debugging
                      setState(() {
                        _imageLoaded = false;
                      });
                      return const Icon(Icons.error, size: 50, color: Colors.red);
                    },
                  )
                : const Text("Image not found", style: TextStyle(color: Colors.red, fontSize: 16)),
            const SizedBox(height: 20),
            Text(
              "title".tr(), // ✅ Ensures localization works in SplashScreen
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
