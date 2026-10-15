import 'distribution_center.dart';

/// Indicadores exibidos na tela inicial (GET /api/dashboard).
class DashboardSummary {
  const DashboardSummary({
    required this.employeeFirstName,
    required this.activeOperations,
    required this.deliveriesToday,
    required this.incidents,
    required this.onTimePercentage,
    required this.distributionCenters,
  });

  final String employeeFirstName;
  final int activeOperations;
  final int deliveriesToday;
  final int incidents;
  final int onTimePercentage;
  final List<DistributionCenter> distributionCenters;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    final centersJson = json['distributionCenters'] as List<dynamic>;

    return DashboardSummary(
      employeeFirstName: json['employeeFirstName'] as String,
      activeOperations: json['activeOperations'] as int,
      deliveriesToday: json['deliveriesToday'] as int,
      incidents: json['incidents'] as int,
      onTimePercentage: json['onTimePercentage'] as int,
      distributionCenters: centersJson
          .map((item) => DistributionCenter.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
