class DashboardModel {
  final int fleet1Amt;
  final int fleet2Amt;
  final int fleet3Amt;
  final int fleet4Amt;
  final int totalFleetAmt;
  final int fleetIncomeTargetValue;
  final int fleetIncomeOptimumTarget;
  final int fleetIncomeTargetCollection;
  final int fleetIncomePreviousPeriod;
  final int totalMaintenanceFeesYesterday;

  final int washIncomeTargetValue;
  final int washIncomeOptimumTarget;
  final int totalCarWashFeesToday;
  final int totalCarWashFeesYesterday;
  final int maintenanceCostTargetValue;
  final int maintenanceCostOptimumTarget;
  final int totalMaintenanceFeesToday;
  final int expensesSavedTargetValue;
  final int expensesSavedOptimumTarget;
  final int expensesSavedTargetCollection;

  final int totalBankedAmountToday;
  final int totalGCashAmountToday;
  final int totalCashAmountToday;
  final int totalAmountPaidToday;

  final int totalBankedAmountYesterday;
  final int totalGCashAmountYesterday;
  final int totalCashAmountYesterday;
  final int totalAmountYesterday;

  const DashboardModel({
    this.fleetIncomeTargetValue = 0,
    this.fleetIncomeOptimumTarget = 0,
    this.fleetIncomeTargetCollection = 1365,
    this.washIncomeTargetValue = 0,
    this.washIncomeOptimumTarget = 0,
    this.totalCarWashFeesToday = 0,
    this.totalCarWashFeesYesterday = 0,
    this.maintenanceCostTargetValue = 0,
    this.maintenanceCostOptimumTarget = 0,
    this.totalMaintenanceFeesToday = 1365,
    this.expensesSavedTargetValue = 3000,
    this.expensesSavedOptimumTarget = 2000,
    this.expensesSavedTargetCollection = 1365,
    this.totalBankedAmountToday = 0,
    this.totalGCashAmountToday = 0,
    this.totalCashAmountToday = 0,
    this.totalAmountPaidToday = 0,
    this.totalBankedAmountYesterday = 0,
    this.totalGCashAmountYesterday = 0,
    this.totalCashAmountYesterday = 0,
    this.totalAmountYesterday = 0,
    this.fleetIncomePreviousPeriod = 0,
    this.fleet1Amt = 0,
    this.fleet2Amt = 0,
    this.fleet3Amt = 0,
    this.fleet4Amt = 0,
    this.totalFleetAmt = 0,
    this.totalMaintenanceFeesYesterday = 0
  });

  DashboardModel copyWith({
    int? fleetIncomeTargetValue,
    int? fleetIncomeOptimumTarget,
    int? fleetIncomeTargetCollection,
    int? washIncomeTargetValue,
    int? washIncomeOptimumTarget,
    int? totalCarWashFeesToday,
    int? maintenanceCostTargetValue,
    int? maintenanceCostOptimumTarget,
    int? totalMaintenanceFeesToday,
    int? expensesSavedTargetValue,
    int? expensesSavedOptimumTarget,
    int? expensesSavedTargetCollection,
    int? totalBankedAmountToday,
    int? totalGCashAmountToday,
    int? totalCashAmountToday,
    int? totalAmountPaidToday,
    int? totalBankedAmountYesterday,
    int? totalGCashAmountYesterday,
    int? totalCashAmountYesterday,
    int? totalAmountYesterday,
    int? fleet1Amt,
    int? fleet2Amt,
    int? fleet3Amt,
    int? fleet4Amt,
    int? totalFleetAmt,
    int? fleetIncomePreviousPeriod,
    bool? fleetLoading,
    int? totalMaintenanceFeesYesterday,
    int? totalCarWashFeesYesterday,
  }) {
    return DashboardModel(
      fleetIncomeTargetValue:
          fleetIncomeTargetValue ?? this.fleetIncomeTargetValue,
      fleetIncomeOptimumTarget:
          fleetIncomeOptimumTarget ?? this.fleetIncomeOptimumTarget,
      fleetIncomeTargetCollection:
          fleetIncomeTargetCollection ?? this.fleetIncomeTargetCollection,
      washIncomeTargetValue:
          washIncomeTargetValue ?? this.washIncomeTargetValue,
      washIncomeOptimumTarget:
          washIncomeOptimumTarget ?? this.washIncomeOptimumTarget,
      totalCarWashFeesToday:
          totalCarWashFeesToday ?? this.totalCarWashFeesToday,
      maintenanceCostTargetValue:
          maintenanceCostTargetValue ?? this.maintenanceCostTargetValue,
      maintenanceCostOptimumTarget:
          maintenanceCostOptimumTarget ?? this.maintenanceCostOptimumTarget,
      totalMaintenanceFeesToday:
          totalMaintenanceFeesToday ??
          this.totalMaintenanceFeesToday,
      expensesSavedTargetValue:
          expensesSavedTargetValue ?? this.expensesSavedTargetValue,
      expensesSavedOptimumTarget:
          expensesSavedOptimumTarget ?? this.expensesSavedOptimumTarget,
      expensesSavedTargetCollection:
          expensesSavedTargetCollection ?? this.expensesSavedTargetCollection,
      totalBankedAmountToday: totalBankedAmountToday ?? this.totalBankedAmountToday,
      totalGCashAmountToday: totalGCashAmountToday ?? this.totalGCashAmountToday,
      totalCashAmountToday: totalCashAmountToday ?? this.totalCashAmountToday,
      totalAmountPaidToday: totalAmountPaidToday ?? this.totalAmountPaidToday,
      totalBankedAmountYesterday: totalBankedAmountYesterday ?? this.totalBankedAmountYesterday,
      totalGCashAmountYesterday: totalGCashAmountYesterday ?? this.totalGCashAmountYesterday,
      totalCashAmountYesterday: totalCashAmountYesterday ?? this.totalCashAmountYesterday,
      totalAmountYesterday: totalAmountYesterday ?? this.totalAmountYesterday,
      fleet1Amt: fleet1Amt ?? this.fleet1Amt,
      fleet2Amt: fleet2Amt ?? this.fleet2Amt,
      fleet3Amt: fleet3Amt ?? this.fleet3Amt,
      fleet4Amt: fleet4Amt ?? this.fleet4Amt,
      totalFleetAmt: totalFleetAmt ?? this.totalFleetAmt,
      fleetIncomePreviousPeriod:
          fleetIncomePreviousPeriod ?? this.fleetIncomePreviousPeriod,
      totalMaintenanceFeesYesterday: totalMaintenanceFeesYesterday ?? this.totalMaintenanceFeesYesterday,
      totalCarWashFeesYesterday: totalCarWashFeesYesterday ?? this.totalCarWashFeesYesterday,
    );
  }
}
