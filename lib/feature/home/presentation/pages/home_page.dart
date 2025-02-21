// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:lrl_shopping/feature/auth/domain/entites/user.dart';
// import 'package:lrl_shopping/feature/auth/presentation/cubit/login_cubit.dart';
// import 'package:lrl_shopping/feature/auth/presentation/cubit/login_state.dart';
// import 'package:lrl_shopping/feature/auth/presentation/pages/login_page.dart';
// import '../../../../core/services/storage_service.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   User? user;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   /// Loads user data from local storage
//   Future<void> _loadUserData() async {
//     final storageService = StorageService();
//     User? storedUser = await storageService.getUserData();
//     if (mounted) {
//       setState(() {
//         user = storedUser;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<LoginCubit, LoginState>(
//       listener: (context, state) {
//         if (state is LoginInitial) {
//           // User logged out, navigate to LoginPage
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => LoginPage()),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Home".tr()),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.logout),
//               onPressed: () => context.read<LoginCubit>().logoutUser(),
//             ),
//           ],
//         ),
//         body: user == null
//             ? const Center(child: CircularProgressIndicator())
//             : Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "title".tr(), // ✅ This should display "LRL-Shopping"
//                       style: const TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     Text("ID: ${user!.id}",
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     Text("Name: ${user!.name}",
//                         style: const TextStyle(fontSize: 16)),
//                     Text("Email: ${user!.email}",
//                         style: const TextStyle(fontSize: 16)),
//                     Text("Mobile: ${user!.mobile}",
//                         style: const TextStyle(fontSize: 16)),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () => context.read<LoginCubit>().logoutUser(),
//                       child: const Text("Logout"),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lrl_shopping/feature/auth/domain/entites/user.dart';
import 'package:lrl_shopping/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:lrl_shopping/feature/auth/presentation/cubit/login_state.dart';
import 'package:lrl_shopping/feature/auth/presentation/pages/login_page.dart';
import '../../../../core/services/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Loads user data from local storage
  Future<void> _loadUserData() async {
    final storageService = StorageService();
    User? storedUser = await storageService.getUserData();
    if (mounted) {
      setState(() {
        user = storedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginInitial) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home".tr()), // ✅ Uses translation
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<LoginCubit>().logoutUser(),
            ),
          ],
        ),
        body: user == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "title".tr(), // ✅ Ensures this text uses translation
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text("ID: ${user!.id}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Name: ${user!.name}",
                        style: const TextStyle(fontSize: 16)),
                    Text("Email: ${user!.email}",
                        style: const TextStyle(fontSize: 16)),
                    Text("Mobile: ${user!.mobile}",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.read<LoginCubit>().logoutUser(),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
