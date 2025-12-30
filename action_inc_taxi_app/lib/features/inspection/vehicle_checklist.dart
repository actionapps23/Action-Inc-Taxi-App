// import 'package:action_inc_taxi_app/core/models/section_model.dart';

// class VehicleChecklist {
//   /// Front view
//   static const List<CategoryModel> frontViewSections = [
//     CategoryModel(
//       categoryName: 'Mirrors',
//       fields: [
//         FieldModel(
//           fieldName: 'Left side mirror',
//           fieldKey: 'front_mirror_left_side',
//         ),
//         FieldModel(
//           fieldName: 'Right side mirror',
//           fieldKey: 'front_mirror_right_side',
//         ),
//         FieldModel(
//           fieldName: 'Interior rear-view mirror (visible)',
//           fieldKey: 'front_mirror_interior_rear_view',
//         ),
//         FieldModel(
//           fieldName: 'Mirror glass condition',
//           fieldKey: 'front_mirror_glass_condition',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Front lights',
//       fields: [
//         FieldModel(
//           fieldName: 'Headlights (low/high beam)',
//           fieldKey: 'front_light_headlights',
//         ),
//         FieldModel(
//           fieldName: 'Front indicators / turn signals',
//           fieldKey: 'front_light_indicators',
//         ),
//         FieldModel(
//           fieldName: 'Fog lights / DRL',
//           fieldKey: 'front_light_fog_drl',
//         ),
//         FieldModel(
//           fieldName: 'Hazard lights (front)',
//           fieldKey: 'front_light_hazard',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Windshield & wipers (front)',
//       fields: [
//         FieldModel(
//           fieldName: 'Windshield glass condition',
//           fieldKey: 'front_windshield_glass_condition',
//         ),
//         FieldModel(
//           fieldName: 'Washer spray working',
//           fieldKey: 'front_windshield_washer_spray',
//         ),
//         FieldModel(
//           fieldName: 'Wiper blades condition',
//           fieldKey: 'front_windshield_wiper_blades',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Front body & bumper',
//       fields: [
//         FieldModel(
//           fieldName: 'Front bumper / grille damage',
//           fieldKey: 'front_body_bumper_damage',
//         ),
//         FieldModel(
//           fieldName: 'Bonnet / hood latch secure',
//           fieldKey: 'front_body_bonnet_latch',
//         ),
//         FieldModel(
//           fieldName: 'Front number plate visible',
//           fieldKey: 'front_body_number_plate',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Front tyres & area',
//       fields: [
//         FieldModel(
//           fieldName: 'Left front tyre tread / pressure',
//           fieldKey: 'front_tyres_left',
//         ),
//         FieldModel(
//           fieldName: 'Right front tyre tread / pressure',
//           fieldKey: 'front_tyres_right',
//         ),
//         FieldModel(
//           fieldName: 'Leaks / objects under front',
//           fieldKey: 'front_tyres_leaks_under',
//         ),
//       ],
//     ),
//   ];

//   /// Rear view
//   static const List<CategoryModel> rearViewSections = [
//     CategoryModel(
//       categoryName: 'Rear lights',
//       fields: [
//         FieldModel(fieldName: 'Tail lights', fieldKey: 'rear_light_tail'),
//         FieldModel(fieldName: 'Brake lights', fieldKey: 'rear_light_brake'),
//         FieldModel(
//           fieldName: 'Rear indicators / turn signals',
//           fieldKey: 'rear_light_indicators',
//         ),
//         FieldModel(fieldName: 'Reverse light', fieldKey: 'rear_light_reverse'),
//         FieldModel(
//           fieldName: 'Number plate light',
//           fieldKey: 'rear_light_number_plate',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Rear body & bumper',
//       fields: [
//         FieldModel(
//           fieldName: 'Rear bumper damage',
//           fieldKey: 'rear_body_bumper_damage',
//         ),
//         FieldModel(
//           fieldName: 'Boot / trunk door closes & locks',
//           fieldKey: 'rear_body_boot_lock',
//         ),
//         FieldModel(
//           fieldName: 'Rear windshield glass condition',
//           fieldKey: 'rear_body_windshield',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Rear tyres & area',
//       fields: [
//         FieldModel(
//           fieldName: 'Left rear tyre tread / pressure',
//           fieldKey: 'rear_tyres_left',
//         ),
//         FieldModel(
//           fieldName: 'Right rear tyre tread / pressure',
//           fieldKey: 'rear_tyres_right',
//         ),
//         FieldModel(
//           fieldName: 'Leaks / objects under rear',
//           fieldKey: 'rear_tyres_leaks_under',
//         ),
//       ],
//     ),
//   ];

//   /// Left side view
//   static const List<CategoryModel> leftSideSections = [
//     CategoryModel(
//       categoryName: 'Left doors & windows',
//       fields: [
//         FieldModel(
//           fieldName: 'Front left door opens / closes',
//           fieldKey: 'left_door_front',
//         ),
//         FieldModel(
//           fieldName: 'Rear left door opens / closes',
//           fieldKey: 'left_door_rear',
//         ),
//         FieldModel(
//           fieldName: 'Left door locks working',
//           fieldKey: 'left_door_locks',
//         ),
//         FieldModel(
//           fieldName: 'Left windows glass condition',
//           fieldKey: 'left_window_glass',
//         ),
//         FieldModel(
//           fieldName: 'Left windows up / down operation',
//           fieldKey: 'left_window_operation',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Left side mirror',
//       fields: [
//         FieldModel(
//           fieldName: 'Left mirror housing damage',
//           fieldKey: 'left_mirror_housing',
//         ),
//         FieldModel(
//           fieldName: 'Left mirror glass condition',
//           fieldKey: 'left_mirror_glass',
//         ),
//         FieldModel(
//           fieldName: 'Left mirror adjustment / folding',
//           fieldKey: 'left_mirror_adjustment',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Left body panels',
//       fields: [
//         FieldModel(
//           fieldName: 'Left front fender condition',
//           fieldKey: 'left_body_front_fender',
//         ),
//         FieldModel(
//           fieldName: 'Left rear quarter panel condition',
//           fieldKey: 'left_body_rear_quarter',
//         ),
//         FieldModel(
//           fieldName: 'Left side scratches / dents / rust',
//           fieldKey: 'left_body_scratches',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Left tyres & wheels',
//       fields: [
//         FieldModel(
//           fieldName: 'Left front tyre tread / pressure',
//           fieldKey: 'left_tyres_front',
//         ),
//         FieldModel(
//           fieldName: 'Left rear tyre tread / pressure',
//           fieldKey: 'left_tyres_rear',
//         ),
//         FieldModel(
//           fieldName: 'Left tyre sidewall damage / bulge',
//           fieldKey: 'left_tyres_sidewall',
//         ),
//         FieldModel(
//           fieldName: 'Left wheel rim condition',
//           fieldKey: 'left_wheel_rim',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Left side extras',
//       fields: [
//         FieldModel(
//           fieldName: 'Left side step / running board secure',
//           fieldKey: 'left_extras_step',
//         ),
//         FieldModel(
//           fieldName: 'Left side sensors / camera clean',
//           fieldKey: 'left_extras_sensors',
//         ),
//       ],
//     ),
//   ];

//   /// Right side view
//   static const List<CategoryModel> rightSideSections = [
//     CategoryModel(
//       categoryName: 'Right doors & windows',
//       fields: [
//         FieldModel(
//           fieldName: 'Front right door opens / closes',
//           fieldKey: 'right_door_front',
//         ),
//         FieldModel(
//           fieldName: 'Rear right door opens / closes',
//           fieldKey: 'right_door_rear',
//         ),
//         FieldModel(
//           fieldName: 'Right door locks working',
//           fieldKey: 'right_door_locks',
//         ),
//         FieldModel(
//           fieldName: 'Right windows glass condition',
//           fieldKey: 'right_window_glass',
//         ),
//         FieldModel(
//           fieldName: 'Right windows up / down operation',
//           fieldKey: 'right_window_operation',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Right side mirror',
//       fields: [
//         FieldModel(
//           fieldName: 'Right mirror housing damage',
//           fieldKey: 'right_mirror_housing',
//         ),
//         FieldModel(
//           fieldName: 'Right mirror glass condition',
//           fieldKey: 'right_mirror_glass',
//         ),
//         FieldModel(
//           fieldName: 'Right mirror adjustment / folding',
//           fieldKey: 'right_mirror_adjustment',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Right body panels',
//       fields: [
//         FieldModel(
//           fieldName: 'Right front fender condition',
//           fieldKey: 'right_body_front_fender',
//         ),
//         FieldModel(
//           fieldName: 'Right rear quarter panel condition',
//           fieldKey: 'right_body_rear_quarter',
//         ),
//         FieldModel(
//           fieldName: 'Right side scratches / dents / rust',
//           fieldKey: 'right_body_scratches',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Right tyres & wheels',
//       fields: [
//         FieldModel(
//           fieldName: 'Right front tyre tread / pressure',
//           fieldKey: 'right_tyres_front',
//         ),
//         FieldModel(
//           fieldName: 'Right rear tyre tread / pressure',
//           fieldKey: 'right_tyres_rear',
//         ),
//         FieldModel(
//           fieldName: 'Right tyre sidewall damage / bulge',
//           fieldKey: 'right_tyres_sidewall',
//         ),
//         FieldModel(
//           fieldName: 'Right wheel rim condition',
//           fieldKey: 'right_wheel_rim',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Right side extras',
//       fields: [
//         FieldModel(
//           fieldName: 'Right side step / running board secure',
//           fieldKey: 'right_extras_step',
//         ),
//         FieldModel(
//           fieldName: 'Right side sensors / camera clean',
//           fieldKey: 'right_extras_sensors',
//         ),
//       ],
//     ),
//   ];

//   /// Top / roof view
//   static const List<CategoryModel> topViewSections = [
//     CategoryModel(
//       categoryName: 'Roof & panels',
//       fields: [
//         FieldModel(
//           fieldName: 'Roof panel dents / rust',
//           fieldKey: 'top_roof_panels',
//         ),
//         FieldModel(
//           fieldName: 'Roof rails / racks secure',
//           fieldKey: 'top_roof_rails',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Sunroof / moonroof',
//       fields: [
//         FieldModel(
//           fieldName: 'Sunroof glass condition',
//           fieldKey: 'top_sunroof_glass',
//         ),
//         FieldModel(
//           fieldName: 'Sunroof open / close operation',
//           fieldKey: 'top_sunroof_operation',
//         ),
//         FieldModel(
//           fieldName: 'Sunroof seal / leakage signs',
//           fieldKey: 'top_sunroof_seal',
//         ),
//       ],
//     ),
//   ];

//   /// Bottom / underbody view
//   static const List<CategoryModel> bottomViewSections = [
//     CategoryModel(
//       categoryName: 'Underbody structure',
//       fields: [
//         FieldModel(
//           fieldName: 'Frame / sub-frame rust or damage',
//           fieldKey: 'bottom_underbody_frame',
//         ),
//         FieldModel(
//           fieldName: 'Floor panels condition',
//           fieldKey: 'bottom_underbody_floor',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Suspension & steering (visible)',
//       fields: [
//         FieldModel(
//           fieldName: 'Springs / shocks leaks or damage',
//           fieldKey: 'bottom_suspension_springs',
//         ),
//         FieldModel(
//           fieldName: 'Control arms / bushes obvious damage',
//           fieldKey: 'bottom_suspension_control_arms',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Exhaust system',
//       fields: [
//         FieldModel(
//           fieldName: 'Pipes / muffler secure',
//           fieldKey: 'bottom_exhaust_pipes',
//         ),
//         FieldModel(
//           fieldName: 'No major leaks or hanging parts',
//           fieldKey: 'bottom_exhaust_no_leaks',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Fluid leaks',
//       fields: [
//         FieldModel(
//           fieldName: 'Engine oil leak signs',
//           fieldKey: 'bottom_fluid_engine_oil',
//         ),
//         FieldModel(
//           fieldName: 'Transmission / other fluid leaks',
//           fieldKey: 'bottom_fluid_transmission',
//         ),
//         FieldModel(fieldName: 'Fuel line leaks', fieldKey: 'bottom_fluid_fuel'),
//       ],
//     ),
//   ];

//   /// Engine bay (top with bonnet open)
//   static const List<CategoryModel> engineBaySections = [
//     CategoryModel(
//       categoryName: 'Fluids',
//       fields: [
//         FieldModel(fieldName: 'Engine oil level', fieldKey: 'engine_oil_level'),
//         FieldModel(
//           fieldName: 'Coolant level',
//           fieldKey: 'engine_coolant_level',
//         ),
//         FieldModel(
//           fieldName: 'Brake fluid level',
//           fieldKey: 'engine_brake_fluid',
//         ),
//         FieldModel(
//           fieldName: 'Power steering / washer fluid level',
//           fieldKey: 'engine_power_steering_fluid',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Battery & belts',
//       fields: [
//         FieldModel(
//           fieldName: 'Battery terminals clean / tight',
//           fieldKey: 'engine_battery_terminals',
//         ),
//         FieldModel(
//           fieldName: 'Drive belts condition',
//           fieldKey: 'engine_drive_belts',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'General engine bay',
//       fields: [
//         FieldModel(
//           fieldName: 'Loose wiring / hoses',
//           fieldKey: 'engine_wiring_hoses',
//         ),
//         FieldModel(
//           fieldName: 'Unusual noises or smells on start',
//           fieldKey: 'engine_unusual_noises',
//         ),
//       ],
//     ),
//   ];

//   /// Interior view
//   static const List<CategoryModel> interiorSections = [
//     CategoryModel(
//       categoryName: 'Driver controls & safety',
//       fields: [
//         FieldModel(fieldName: 'Horn working', fieldKey: 'interior_horn'),
//         FieldModel(
//           fieldName: 'Steering wheel free play normal',
//           fieldKey: 'interior_steering',
//         ),
//         FieldModel(
//           fieldName: 'Foot brake pedal operation',
//           fieldKey: 'interior_foot_brake',
//         ),
//         FieldModel(
//           fieldName: 'Parking brake operation',
//           fieldKey: 'interior_parking_brake',
//         ),
//         FieldModel(
//           fieldName: 'Clutch pedal operation (if manual)',
//           fieldKey: 'interior_clutch_pedal',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Dashboard & instruments',
//       fields: [
//         FieldModel(
//           fieldName: 'Warning lights off after start',
//           fieldKey: 'interior_dashboard_warning_lights',
//         ),
//         FieldModel(
//           fieldName: 'Speedometer working',
//           fieldKey: 'interior_dashboard_speedometer',
//         ),
//         FieldModel(
//           fieldName: 'Fuel gauge working',
//           fieldKey: 'interior_dashboard_fuel_gauge',
//         ),
//         FieldModel(
//           fieldName: 'Indicator / hazard switches working',
//           fieldKey: 'interior_dashboard_indicators',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Seats & seatbelts',
//       fields: [
//         FieldModel(
//           fieldName: 'Driver seat adjustment & lock',
//           fieldKey: 'interior_seats_driver',
//         ),
//         FieldModel(
//           fieldName: 'Passenger seats secure',
//           fieldKey: 'interior_seats_passenger',
//         ),
//         FieldModel(
//           fieldName: 'All seatbelts latch & retract',
//           fieldKey: 'interior_seatbelts',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Interior environment',
//       fields: [
//         FieldModel(
//           fieldName: 'AC / heater operation',
//           fieldKey: 'interior_ac_heater',
//         ),
//         FieldModel(
//           fieldName: 'Front / rear defogger',
//           fieldKey: 'interior_defogger',
//         ),
//         FieldModel(
//           fieldName: 'Interior lights working',
//           fieldKey: 'interior_lights',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Interior locks & windows',
//       fields: [
//         FieldModel(
//           fieldName: 'Door locks from inside',
//           fieldKey: 'interior_locks_inside',
//         ),
//         FieldModel(
//           fieldName: 'Power window switches inside',
//           fieldKey: 'interior_window_switches',
//         ),
//         FieldModel(
//           fieldName: 'Child lock (if applicable)',
//           fieldKey: 'interior_child_lock',
//         ),
//       ],
//     ),
//   ];

//   /// Mechanical sections
//   static const List<CategoryModel> mechanicalSections = [
//     CategoryModel(
//       categoryName: 'Engine',
//       fields: [
//         FieldModel(
//           fieldName: 'Engine starts easily',
//           fieldKey: 'mechanical_engine_starts',
//         ),
//         FieldModel(
//           fieldName: 'Engine sound is normal',
//           fieldKey: 'mechanical_engine_sound',
//         ),
//         FieldModel(
//           fieldName: 'Engine oil level is okay',
//           fieldKey: 'mechanical_engine_oil_level',
//         ),
//         FieldModel(
//           fieldName: 'Coolant / water level is okay',
//           fieldKey: 'mechanical_coolant_level',
//         ),
//         FieldModel(
//           fieldName: 'No oil or water dripping from engine',
//           fieldKey: 'mechanical_no_leaks',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Gears & drive',
//       fields: [
//         FieldModel(
//           fieldName: 'Gear change is smooth',
//           fieldKey: 'mechanical_gears_smooth',
//         ),
//         FieldModel(
//           fieldName: 'No jerks while changing gear',
//           fieldKey: 'mechanical_gears_no_jerks',
//         ),
//         FieldModel(
//           fieldName: 'No strange sound from gears while driving',
//           fieldKey: 'mechanical_gears_no_strange_sound',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Brakes',
//       fields: [
//         FieldModel(
//           fieldName: 'Brake pedal works properly',
//           fieldKey: 'mechanical_brakes_pedal',
//         ),
//         FieldModel(
//           fieldName: 'Vehicle does not move when handbrake is applied',
//           fieldKey: 'mechanical_brakes_handbrake',
//         ),
//         FieldModel(
//           fieldName: 'No unusual sound when braking',
//           fieldKey: 'mechanical_brakes_no_sound',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Steering & suspension',
//       fields: [
//         FieldModel(
//           fieldName: 'Steering moves easily',
//           fieldKey: 'mechanical_steering_moves',
//         ),
//         FieldModel(
//           fieldName: 'Vehicle goes straight on flat road',
//           fieldKey: 'mechanical_steering_straight',
//         ),
//         FieldModel(
//           fieldName: 'No hard knocking sound on speed breakers',
//           fieldKey: 'mechanical_steering_no_knock',
//         ),
//       ],
//     ),
//     CategoryModel(
//       categoryName: 'Exhaust & leaks',
//       fields: [
//         FieldModel(
//           fieldName: 'Silencer / exhaust is tight, not hanging',
//           fieldKey: 'mechanical_exhaust_silencer',
//         ),
//         FieldModel(
//           fieldName: 'Exhaust sound is normal',
//           fieldKey: 'mechanical_exhaust_sound',
//         ),
//         FieldModel(
//           fieldName: 'No oil or other liquid under the vehicle',
//           fieldKey: 'mechanical_exhaust_no_leak',
//         ),
//       ],
//     ),
//   ];
// }
