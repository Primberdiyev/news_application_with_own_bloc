import 'package:flutter/material.dart';
import 'package:news_application/features/auth/bloc/auth_bloc.dart';
import 'package:news_application/features/home/bloc/home_bloc.dart';
import 'package:news_application/features/home/ui/category/bloc/category_bloc.dart';
import 'package:news_application/features/home/ui/country/bloc/country_bloc.dart';
import 'package:news_application/features/home/ui/profile/bloc/profile_bloc.dart';
import 'package:news_application/features/routes/app_routes.dart';
import 'package:news_application/my_bloc/my_bloc_provider.dart';
import 'package:news_application/splash_page.dart';
import 'package:news_application/features/utils/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyBlocProvider<AuthBloc>(
      create: () => AuthBloc(),
      child: MyBlocProvider<HomeBloc>(
        create: () => HomeBloc(),
        child: MyBlocProvider<ProfileBloc>(
          create: () => ProfileBloc(),
          child: MyBlocProvider<CountryBloc>(
            create: () => CountryBloc(),
            child: MyBlocProvider<CategoryBloc>(
              create: () => CategoryBloc(),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                onGenerateRoute: onGenerateRoute,
                theme: ThemeData(
                  primaryColor: AppColors.white,
                  scaffoldBackgroundColor: AppColors.white,
                ),
                home: SplashPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
