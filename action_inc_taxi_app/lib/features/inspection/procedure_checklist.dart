import 'package:action_inc_taxi_app/core/models/section_model.dart';

class ProcedureChecklists {
  static const List<CategoryModel> openProcedureChecklist = [
    CategoryModel(
      categoryName: 'Engine Compartment',
      fields: [
        FieldModel(fieldName: 'Check oil level', fieldKey: 'check_oil_level'),
        FieldModel(
          fieldName: 'Check coolant level',
          fieldKey: 'check_coolant_level',
        ),
        FieldModel(
          fieldName: 'Inspect belts and hoses',
          fieldKey: 'inspect_belts_hoses',
        ),
        FieldModel(
          fieldName: 'Check battery condition',
          fieldKey: 'check_battery_condition',
        ),
      ],
    ),
    CategoryModel(
      categoryName: 'Taxi Office',
      fields: [
        FieldModel(fieldName: 'Turn On lights', fieldKey: 'turn_on_lights'),
        FieldModel(
          fieldName: 'Start computer systems',
          fieldKey: 'start_computer_systems',
        ),
        FieldModel(
          fieldName: 'Check communication devices',
          fieldKey: 'check_communication_devices',
        ),
        FieldModel(
          fieldName: 'Verify cash float',
          fieldKey: 'verify_cash_float',
        ),
      ],
    ),
    CategoryModel(
      categoryName: 'Interior Inspection',
      fields: [
        FieldModel(fieldName: 'Check seat belts', fieldKey: 'check_seat_belts'),
        FieldModel(
          fieldName: 'Inspect upholstery',
          fieldKey: 'inspect_upholstery',
        ),
        FieldModel(
          fieldName: 'Test air conditioning',
          fieldKey: 'test_air_conditioning',
        ),
        FieldModel(
          fieldName: 'Ensure cleanliness',
          fieldKey: 'ensure_cleanliness',
        ),
      ],
    ),
  ];

  static const List<CategoryModel> closeProcedureChecklist = [
    CategoryModel(
      categoryName: 'Taxi Office',
      fields: [
        FieldModel(fieldName: 'Close Window', fieldKey: 'close_window'),
        FieldModel(fieldName: 'Close Door', fieldKey: 'close_door'),
      ],
    ),
    CategoryModel(
      categoryName: 'Car Wash',
      fields: [
        FieldModel(fieldName: 'Open Gates', fieldKey: 'open_gates'),
        FieldModel(fieldName: 'Get Wash Done', fieldKey: 'get_wash_done'),
        FieldModel(fieldName: 'Get Regs', fieldKey: 'get_regs'),
      ],
    ),
    CategoryModel(
      categoryName: 'Mechanics',
      fields: [
        FieldModel(fieldName: 'Set Up Soap', fieldKey: 'set_up_soap'),
        FieldModel(fieldName: 'Set Up Pump', fieldKey: 'set_up_pump'),
      ],
    ),
    CategoryModel(
      categoryName: 'Parts Store',
      fields: [
        FieldModel(
          fieldName: 'Collect everything',
          fieldKey: 'collect_everything',
        ),
      ],
    ),
  ];
}
