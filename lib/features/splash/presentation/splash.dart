import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
import '../../auth/domain/logout_repo.dart';
import '../../auth/presentation/pages/login_screen.dart';
import '../../home/presentation/pages/home_page.dart';
import 'bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Session session = Session();
  GetLoginRepo userRepo = GetLoginRepo();

  // String token='';
  @override
  void initState() {
    context.read<SplashBloc>().add(GetCompanyListEvent());

    Future.delayed(const Duration(seconds: 3), () => checkLoginStatus());

    super.initState();
  }

  Future<void> checkLoginStatus() async {
    try {
      LoginModel? responseModel = await userRepo.getUserLoginResponse();
      if (responseModel != null) {
        String token = await session.tokenExpired();
        if (token.isEmpty) {
          await Logoutrepo().logout(context);
          return;
        }
        navigateToScreen(const HomePage());
      } else {
        navigateToScreen(const LoginScreen());
      }
    } catch (e) {
      navigateToScreen(const LoginScreen());
    }
  }

  void navigateToScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            if (state is SplashLoading) {
              return Center(child: Image.asset("assets/images/appLogo.jpeg"));
            } else if (state is SplashLoaded) {
              var data = state.companyList;
              print(data.length);
              return Center(child: Image.asset("assets/images/appLogo.jpeg"));
            } else if (state is SplashError) {
              return const Icon(Icons.error);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
