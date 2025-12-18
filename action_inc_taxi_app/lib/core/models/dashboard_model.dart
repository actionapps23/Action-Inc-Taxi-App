class DashboardModel {
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
  });
}
