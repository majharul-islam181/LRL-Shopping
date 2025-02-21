import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entites/user.dart';
import '../../../auth/presentation/cubit/login_cubit.dart';
import '../../../auth/presentation/cubit/login_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/presentation/pages/widgets/home_bottom_navbar.dart';
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
            MaterialPageRoute(builder: (context) =>  LoginPage()),
          );
        }
      },
      child: user == null
          ? const Scaffold(body: Center(child: CircularProgressIndicator())) // ✅ Loading state
          : HomeBottomNavBar(user: user!), 
    );
  }
}
