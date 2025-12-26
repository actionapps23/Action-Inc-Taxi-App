import 'package:action_inc_taxi_app/cubit/auth/add_employee_cubit.dart';
import 'package:action_inc_taxi_app/cubit/auth/login_cubit.dart';
import 'package:action_inc_taxi_app/cubit/car_details/car_detail_cubit.dart';
import 'package:action_inc_taxi_app/cubit/future_purchase/future_purchase_cubit.dart';
import 'package:action_inc_taxi_app/cubit/inventory/inventory_cubit.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_cubit.dart';
import 'package:action_inc_taxi_app/cubit/procedure/procedure_cubit.dart';
import 'package:action_inc_taxi_app/cubit/rent/daily_rent_cubit.dart';
import 'package:action_inc_taxi_app/features/auth/login_screen.dart';
import 'package:action_inc_taxi_app/features/dashboard/dashboard_cubit.dart';
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
            BlocProvider<MaintainanceCubit>(create: (_) => MaintainanceCubit()),
            BlocProvider<DashboardCubit>(create: (_) => DashboardCubit()),

            BlocProvider<CarDetailCubit>(create: (_) => CarDetailCubit()),
            BlocProvider<InventoryCubit>(create: (_) => InventoryCubit()),
            BlocProvider<AddEmployeeCubit>(create: (_) => AddEmployeeCubit()),
            BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
            BlocProvider<ProcedureCubit>(create: (_) => ProcedureCubit()),
            BlocProvider<FuturePurchaseCubit>(
              create: (_) => FuturePurchaseCubit(),
            ),
          ],
          child: MaterialApp(
            scrollBehavior: ScrollBehavior().copyWith(scrollbars: false),
            title: 'Action Inc Taxi',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Lufga',
              textTheme: ThemeData.dark().textTheme
                  .apply(
                    fontFamily: 'Lufga',
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  )
                  .copyWith(
                    bodyLarge: TextStyle(
                      fontFamily: 'Lufga',
                      fontWeight: FontWeight.w400,
                    ),
                    bodyMedium: TextStyle(
                      fontFamily: 'Lufga',
                      fontWeight: FontWeight.w400,
                    ),
                    bodySmall: TextStyle(
                      fontFamily: 'Lufga',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              colorScheme: ColorScheme.dark(
                primary: Colors.green[400] ?? Colors.green,
                surface: const Color(0xff0f110f),
              ),
            ),
            home: LoginScreen(),
            // home: MaintainenceScreen(),
          ),
        );
      },
    );
  }
}
