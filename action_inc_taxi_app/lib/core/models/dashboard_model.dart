class DashboardModel {
    final int fleet1Amt;
    final int fleet2Amt;
    final int fleet3Amt;
    final int fleet4Amt;
    final int totalFleetAmt;
  final int fleetIncomeTargetValue;
  final int fleetIncomeOptimumTarget;
  final int fleetIncomeTargetCollection;

  final int washIncomeTargetValue;
  final int washIncomeOptimumTarget;
  final int washIncomeTargetCollection;
  final int maintenanceCostTargetValue;
  final int maintenanceCostOptimumTarget;
  final int maintenanceCostTargetCollection;
  final int expensesSavedTargetValue;
  final int expensesSavedOptimumTarget;
  final int expensesSavedTargetCollection;

  final int totalBankedAmount;
  final int totalGCashAmount;
  final int totalCashAmount;
  final int totalAmountPaid;
  final int lastDayBankedAmount;
  final int lastDayGCashAmount;
  final int lastDayCashAmount;
  final int lastDayAmountPaid;

  const DashboardModel({
    this.fleetIncomeTargetValue = 3000,
    this.fleetIncomeOptimumTarget = 2000,
    this.fleetIncomeTargetCollection = 1365,
    this.washIncomeTargetValue = 3000,
    this.washIncomeOptimumTarget = 2000,
    this.washIncomeTargetCollection = 1365,
    this.maintenanceCostTargetValue = 3000,
    this.maintenanceCostOptimumTarget = 2000,
    this.maintenanceCostTargetCollection = 1365,
    this.expensesSavedTargetValue = 3000,
    this.expensesSavedOptimumTarget = 2000,
    this.expensesSavedTargetCollection = 1365,
    this.totalBankedAmount = 0,
    this.totalGCashAmount = 0,
    this.totalCashAmount = 0,
    this.totalAmountPaid = 0,
    this.lastDayBankedAmount = 0,
    this.lastDayGCashAmount = 0,
    this.lastDayCashAmount = 0,
    this.lastDayAmountPaid = 0,
        this.fleet1Amt = 0,
        this.fleet2Amt = 0,
        this.fleet3Amt = 0,
        this.fleet4Amt = 0,
        this.totalFleetAmt = 0,
x  });


  DashboardModel copyWith({
    int? fleetIncomeTargetValue,
    int? fleetIncomeOptimumTarget,
    int? fleetIncomeTargetCollection,
    int? washIncomeTargetValue,
    int? washIncomeOptimumTarget,
    int? washIncomeTargetCollection,
    int? maintenanceCostTargetValue,
    int? maintenanceCostOptimumTarget,
    int? maintenanceCostTargetCollection,
    int? expensesSavedTargetValue,
    int? expensesSavedOptimumTarget,
    int? expensesSavedTargetCollection,
    int? totalBankedAmount,
    int? totalGCashAmount,
    int? totalCashAmount,
    int? totalAmountPaid,
    int? lastDayBankedAmount,
    int? lastDayGCashAmount,
    int? lastDayCashAmount,
    int? lastDayAmountPaid,
    int? fleet1Amt,
    int? fleet2Amt,
    int? fleet3Amt,
    int? fleet4Amt,
    int? totalFleetAmt,
    bool? fleetLoading,
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
      washIncomeTargetCollection:
          washIncomeTargetCollection ?? this.washIncomeTargetCollection,
      maintenanceCostTargetValue:
          maintenanceCostTargetValue ?? this.maintenanceCostTargetValue,
      maintenanceCostOptimumTarget:
          maintenanceCostOptimumTarget ?? this.maintenanceCostOptimumTarget,
      maintenanceCostTargetCollection:
          maintenanceCostTargetCollection ?? this.maintenanceCostTargetCollection,
      expensesSavedTargetValue:
          expensesSavedTargetValue ?? this.expensesSavedTargetValue,
      expensesSavedOptimumTarget:
          expensesSavedOptimumTarget ?? this.expensesSavedOptimumTarget,
      expensesSavedTargetCollection:
          expensesSavedTargetCollection ?? this.expensesSavedTargetCollection,
      totalBankedAmount: totalBankedAmount ?? this.totalBankedAmount,
      totalGCashAmount: totalGCashAmount ?? this.totalGCashAmount,
      totalCashAmount: totalCashAmount ?? this.totalCashAmount,
      totalAmountPaid: totalAmountPaid ?? this.totalAmountPaid,
      lastDayBankedAmount: lastDayBankedAmount ?? this.lastDayBankedAmount,
      lastDayGCashAmount: lastDayGCashAmount ?? this.lastDayGCashAmount,
      lastDayCashAmount: lastDayCashAmount ?? this.lastDayCashAmount,
      lastDayAmountPaid: lastDayAmountPaid ?? this.lastDayAmountPaid,
      fleet1Amt: fleet1Amt ?? this.fleet1Amt,
      fleet2Amt: fleet2Amt ?? this.fleet2Amt,
      fleet3Amt: fleet3Amt ?? this.fleet3Amt,
      fleet4Amt: fleet4Amt ?? this.fleet4Amt,
      totalFleetAmt: totalFleetAmt ?? this.totalFleetAmt,
    );
  }
}
