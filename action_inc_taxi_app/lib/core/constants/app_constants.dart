import 'package:action_inc_taxi_app/core/models/field_entry_model.dart';

class AppConstants {
  static const String openProcedure = 'open_procedure';
  static const String closeProcedure = 'close_procedure';
  AppConstants._();

  // App Text
  static const String appNameAction = 'action';
  static const String appNameInc = 'inc';

  // Login Screen
  static const String enterEmployId = 'Enter Employ Id';
  static const String enterPassword = 'Enter Password';
  static const String loginButton = 'Log In';

  // messages
  static const String genericErrorMessage =
      'Something went wrong. Please try again later.';
  static const String noCarFoundErrorMessage =
      'No car found with the provided identifiers.';

  static const String inventoryLoadSuccessMessage =
      'Inventory loaded successfully.';

  static const String addFieldsToCategorySuccessMessage =
      'Fields added to category successfully.';

  static const addCategorySuccessMessage = 'Category added successfully.';
  static const String filePickerError = 'Failed to pick the file.';
  static const String fillAllFieldsError = 'Please fill all the fields.';
  static const String maintainanceLoadError =
      'Failed to load maintenance requests.';

  static const String maintainanceEmptyMessage =
      'No maintenance requests available.';

  static const String procedureSubmissionError =
      'Failed to submit procedure record. Please try again.';

  static const String procedureChecklistUpdateError =
      'Failed to update procedure checklist. Please try again.';

  static const String procedureRecordSubmissionError =
      'Failed to submit procedure record. Please try again.';

  static const String procedureFetchError =
      'Failed to fetch procedure checklist. Please try again.';

  // Input Styling
  static const double inputBorderRadius = 8.0;
  static const double buttonBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;

  // Spacing
  static const double spacingXS = 8.0;
  static const double spacingS = 16.0;
  static const double spacingM = 24.0;
  static const double spacingL = 32.0;
  static const double spacingXL = 48.0;

  // Font Sizes
  static const double fontSizeTitle = 24.0;
  static const double fontSizeButton = 16.0;
  static const double fontSizeInput = 14.0;

  static List<String> mechanics = [
    'John Doe',
    'Jane Smith',
    'Mike Johnson',
    'Emily Davis',
  ];

  static List<FieldEntryModel> items = [
    FieldEntryModel(
      id: '123',
      isCompleted: true,
      title: "Muneeb Masood",
      SOP: 1000,
      fees: 2000,
      timeline: DateTime.now(),
      lastUpdated: DateTime.now(),
    ),

    FieldEntryModel(
      id: '123',
      isCompleted: false,
      title: "Muneeb Masood",
      SOP: 1000,
      fees: 2000,
      timeline: DateTime.now(),
      lastUpdated: DateTime.now(),
    ),
    FieldEntryModel(
      id: '124',
      isCompleted: true,
      title: "Muneeb Masood",
      SOP: 1000,
      fees: 2000,
      timeline: DateTime.now(),
      lastUpdated: DateTime.now(),
    ),

    FieldEntryModel(
      id: '125',
      title: "Muneeb Masood",
      SOP: 1000,
      fees: 2000,
      isCompleted: false,
      timeline: DateTime.now(),
      lastUpdated: DateTime.now(),
    ),
  ];

  static const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // collections
  static final String lftrbForFranchiseTransferCollection =
      'ltfrb_franchise_transfer';
  static final String pnpForFranchiseTransferCollection =
      'pnp_franchise_transfer';
  static final String ltoForFranchiseTransferCollection =
      'lto_franchise_transfer';
  static final String purchaseCollection = 'purchase';
  static final String newCarEquipmentCollection = 'new_car_equipments';
  static final String lftrbCollectionForNewCar = 'ltfrb_process';
  static final String ltoCollectionForNewCar = 'lto_process';
  static final String futurePurchaseCollection = 'future_purchases';
  static final String fieldEntryCollectionName = 'field_entries';
}
