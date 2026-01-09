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
  static final String lftrbChecklistForFranchiseTransferCollection =
      'ltfrb_franchise_transfer_checklist';
  static final String pnpChecklistForFranchiseTransferCollection =
      'pnp_franchise_transfer_checklist';
  static final String ltoChecklistForFranchiseTransferCollection =
      'lto_franchise_transfer_checklist';

  static final String lftrbRecordForFranchiseTransferCollection =
      'ltfrb_franchise_transfer_records';

  static final String pnpRecordForFranchiseTransferCollection =
      'pnp_franchise_transfer_records';

  static final String ltoRecordForFranchiseTransferCollection =
      'lto_franchise_transfer_records';

  static final String purchaseChecklistCollection = 'purchase_checklist';
  static final String purchaseRecordsCollection = 'purchase_records';
  static final String newCarEquipmentChecklistCollection =
      'new_car_equipments_checklist';
  static final String lftrbChecklistCollectionForNewCar =
      'ltfrb_process_checklist';
  static final String ltoChecklistCollectionForNewCar = 'lto_process_checklist';
  static final String newCarEquipmentRecordCollection =
      'new_car_equipments_records';
  static final String lftrbRecordCollectionForNewCar = 'ltfrb_process_records';
  static final String ltoRecordCollectionForNewCar = 'lto_process_records';
  static final String futurePurchaseChecklistCollection =
      'future_purchases_checklist';
  static final String fieldEntryCollectionName = 'field_entries';
}
