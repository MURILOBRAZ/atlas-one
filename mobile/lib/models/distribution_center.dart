/// Situação operacional de um centro de distribuição.
enum DistributionCenterStatus {
  normal('normal', 'Operação normal'),
  attention('attention', 'Atenção'),
  critical('critical', 'Crítico'),
  unknown('unknown', 'Sem informação');

  const DistributionCenterStatus(this.code, this.label);

  final String code;
  final String label;

  static DistributionCenterStatus fromCode(String? code) {
    return DistributionCenterStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => DistributionCenterStatus.unknown,
    );
  }
}

/// Centro de distribuição (CD) da Atlas Logistics.
class DistributionCenter {
  const DistributionCenter({
    required this.id,
    required this.code,
    required this.name,
    required this.city,
    required this.state,
    required this.status,
  });

  final String id;

  /// Código interno do CD (ex.: CD-SAN).
  final String code;
  final String name;
  final String city;
  final String state;
  final DistributionCenterStatus status;

  String get location => '$city - $state';

  factory DistributionCenter.fromJson(Map<String, dynamic> json) {
    return DistributionCenter(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      status: DistributionCenterStatus.fromCode(json['status'] as String?),
    );
  }
}
