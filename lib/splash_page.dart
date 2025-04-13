import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/features/auth/bloc/auth_bloc.dart';
import 'package:news_application/features/home/bloc/home_bloc.dart';
import 'package:news_application/features/home/bloc/home_event.dart';
import 'package:news_application/features/home/models/country_model.dart';
import 'package:news_application/features/routes/name_routes.dart';
import 'package:news_application/features/utils/app_images.dart';
import 'package:news_application/features/utils/sort_components.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final CountryModel defaultCountry = SortComponents.countryComponents.first;

  @override
  void initState() {
    context.read<AuthBloc>().add(CheckUserAuth());
    context.read<HomeBloc>().add(GetTeslaNewEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          if (state.isRegistered == true) {
            Navigator.pushReplacementNamed(context, NameRoutes.home);
          } else {
            Navigator.pushReplacementNamed(context, NameRoutes.signIn);
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(
            AppImages.splash.image,
            height: 200,
          ),
        ),
      ),
    );
  }
}
