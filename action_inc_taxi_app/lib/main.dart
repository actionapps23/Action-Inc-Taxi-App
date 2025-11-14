import 'package:action_inc_taxi_app/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider<SelectionCubit>(
          create: (_) => SelectionCubit(),
          child: MaterialApp(
            title: 'Action Inc Taxi',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.dark(
                primary: Colors.green[400] ?? Colors.green,
                surface: Colors.black,
              ),
            ),
            // Switch between LoginScreen() and CarDetailScreen() for testing
            home: LoginScreen(),
            // home: CarDetailScreen()
          ),
        );
      },
    );
  }
}
