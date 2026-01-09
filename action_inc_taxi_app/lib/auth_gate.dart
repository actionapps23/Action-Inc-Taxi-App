import 'package:action_inc_taxi_app/core/routes/app_routes.dart';
import 'package:action_inc_taxi_app/core/storage/local_storage.dart';
import 'package:action_inc_taxi_app/features/close_procedure/procedure_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_detail_main_screen.dart';
import 'package:action_inc_taxi_app/features/entry_section/vehicle_inspection_panel.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
final Widget? child;
  final RouteSettings? routeSettings;

  const AuthGate({super.key, this.child, this.routeSettings});

  

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
            return FutureBuilder<bool>(
              future: LocalStorage.wasReloaded(),
              builder: (context, wasReloadedSnapshot) {
                if (!wasReloadedSnapshot.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (wasReloadedSnapshot.data!) {
                  clearWasReloaded();
                  if (lastRouteSnapshot.data == AppRoutes.vehicleInspectionPanel ||
                      lastRouteSnapshot.data == AppRoutes.newCarDetails ||
                      lastRouteSnapshot.data == AppRoutes.carDetail ||
                      lastRouteSnapshot.data == AppRoutes.franchiseTransfer ||
                      lastRouteSnapshot.data == AppRoutes.vehicleViewSelection ||
                      lastRouteSnapshot.data == AppRoutes.purchase) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacementNamed(context, AppRoutes.selection);
                    });
                    return const SizedBox.shrink();
                  }
                }
                if(routeSettings != null){
                  if(routeSettings!.name == AppRoutes.vehicleInspectionPanel){
                    final args = routeSettings!.arguments as VehicleInspectionRouteArgs?;
                    if (args == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, AppRoutes.selection);
                      });
                      return const SizedBox.shrink();
                    }
                    return AuthGate(
                      child: VehicleInspectionPanel(viewName: args.viewName, mapKey: args.mapKey),
                    );
                  }
                  else if(routeSettings!.name == AppRoutes.carDetail){
                    final args = routeSettings!.arguments as CarDetailRouteArgs?;
                    if(args == null){
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, AppRoutes.selection);
                      });
                      return const SizedBox.shrink();
                    }
                    return AuthGate(child: CarDetailScreen(fetchDetails: args.fetchDetails));
                  }
                  else if(routeSettings!.name == AppRoutes.procedure){
                    final args = routeSettings!.arguments as ProcedureRouteArgs?;
                    if(args == null){
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, AppRoutes.selection);
                      });
                      return const SizedBox.shrink();
                    }
                    return AuthGate(child: ProcedureScreen(procedureType: args.procedureType));
                  }
                }
                return child!;
              },
            );
          },
        );
      },
    );
  }
}

void clearWasReloaded() async{
                    await LocalStorage.clearWasReloaded();
                    debugPrint("Cleared wasReloaded flag");
                    final wasReloaded = await LocalStorage.wasReloaded();
                    debugPrint("wasReloaded after clearing: $wasReloaded");

}