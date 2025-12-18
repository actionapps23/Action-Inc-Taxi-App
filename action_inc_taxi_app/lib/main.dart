import 'package:action_inc_taxi_app/cubit/rent/daily_rent_cubit.dart';
import 'package:action_inc_taxi_app/features/dashboard/dashboard.dart';
import 'package:action_inc_taxi_app/features/entry_section/inspection/vehicle_view_selection_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_inspection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:action_inc_taxi_app/core/db_service.dart';

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
        return MultiBlocProvider(
          providers: [
            BlocProvider<SelectionCubit>(create: (_) => SelectionCubit()),
            BlocProvider<DailyRentCubit>(
              create: (_) => DailyRentCubit(DbService()),
            ),
            BlocProvider<VehicleInspectionPanelCubit>(
              create: (_) => VehicleInspectionPanelCubit(),
            ),
          ],
          child: MaterialApp(
            scrollBehavior: ScrollBehavior().copyWith(scrollbars: false),
            title: 'Action Inc Taxi',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Lufga',
              colorScheme: ColorScheme.dark(
                primary: Colors.green[400] ?? Colors.green,
                surface: Colors.black,
              ),
            ),
            home: Dashboard(),
          ),
        );
      },
    );
  }
}
