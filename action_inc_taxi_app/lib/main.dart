import 'package:action_inc_taxi_app/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
        return MaterialApp(
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
        );
      },
    );
  }
}

//
// RenewalDatesDataTable(
//             renewalRows: [
//               {
//                 'renewal': 'Sealing',
//                 'taxi': 'Taxi No. 05, 06, 07',
//                 'status': 'Repaired',
//                 'date': '01 June, 2024',
//               },
//               {
//                 'renewal': 'LTEFB',
//                 'taxi': 'Taxi No. 05, 06, 07',
//                 'status': 'Applied',
//                 'date': '08 August, 2024',
//               },
//               {
//                 'renewal': 'Registration',
//                 'taxi': 'Taxi No. 05, 06, 07',
//                 'status': 'On Process',
//                 'date': '01 July, 2024',
//               },
//               {
//                 'renewal': 'Driving Licence',
//                 'taxi': 'Taxi No. 05, 06, 07',
//                 'status': 'On Process',
//                 'date': '01 July, 2024',
//               },
//               {
//                 'renewal': 'LTO',
//                 'taxi': 'Taxi No. 05, 06, 07',
//                 'status': 'On Process',
//                 'date': '01 July, 2024',
//               },
//               {
//                 'renewal': 'Car Insurance',
//                 'taxi': 'Taxi No. 05, 06, 07',
//                 'status': 'On Process',
//                 'date': '01 July, 2024',
//               },
//             ],
//           ),
//
