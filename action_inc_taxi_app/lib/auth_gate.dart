import 'package:action_inc_taxi_app/core/routes/app_routes.dart';
import 'package:action_inc_taxi_app/core/storage/local_storage.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  final Widget child;

  const AuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LocalStorage.isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.data!) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          });
          return const SizedBox.shrink();
        }

        return FutureBuilder<String?>(
          future: LocalStorage.getLastRoute(),
          builder: (context, lastRouteSnapshot) {
            if (!lastRouteSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (
               
                lastRouteSnapshot.data == AppRoutes.vehicleInspectionPanel
            ) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, AppRoutes.selection);
              });
              return const SizedBox.shrink();
            }
            return child;
          },
        );
      },
    );
  }
}
