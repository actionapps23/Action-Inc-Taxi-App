class FleetIncomeModel {
  final int fleet1Amt;
  final int fleet2Amt;
  final int fleet3Amt;
  final int fleet4Amt;
  final int totalFleetAmtForChart;
  final int totalFleetAmtForStatsCard;

  const FleetIncomeModel({
    this.fleet1Amt = 0,
    this.fleet2Amt = 0,
    this.fleet3Amt = 0,
    this.fleet4Amt = 0,
    this.totalFleetAmtForChart = 0,
    this.totalFleetAmtForStatsCard = 0,
  });

  FleetIncomeModel copyWith({
    int? fleet1Amt,
    int? fleet2Amt,
    int? fleet3Amt,
    int? fleet4Amt,
    int? totalFleetAmtForChart,
    int? totalFleetAmtForStatsCard,
  }) {
    return FleetIncomeModel(
      fleet1Amt: fleet1Amt ?? this.fleet1Amt,
      fleet2Amt: fleet2Amt ?? this.fleet2Amt,
      fleet3Amt: fleet3Amt ?? this.fleet3Amt,
      fleet4Amt: fleet4Amt ?? this.fleet4Amt,
      totalFleetAmtForChart:
          totalFleetAmtForChart ?? this.totalFleetAmtForChart,
      totalFleetAmtForStatsCard:
          totalFleetAmtForStatsCard ?? this.totalFleetAmtForStatsCard,
    );
  }
}
