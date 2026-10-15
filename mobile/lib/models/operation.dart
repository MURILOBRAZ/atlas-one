/// Situação de uma operação logística.
///
/// O [code] é o valor armazenado no banco de dados e enviado pela API.
/// O [label] é o texto exibido para o usuário.
enum OperationStatus {
  awaitingPickup('awaiting_pickup', 'Aguardando coleta'),
  inTransit('in_transit', 'Em trânsito'),
  delayed('delayed', 'Atrasada'),
  completed('completed', 'Finalizada'),
  unknown('unknown', 'Indefinido');

  const OperationStatus(this.code, this.label);

  final String code;
  final String label;

  static OperationStatus fromCode(String? code) {
    return OperationStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => OperationStatus.unknown,
    );
  }
}

/// Operação de transporte de carga entre dois pontos.
class Operation {
  const Operation({
    required this.id,
    required this.code,
    required this.origin,
    required this.destination,
    required this.status,
    required this.scheduledDate,
  });

  final String id;

  /// Código de negócio da operação (ex.: OP-1048).
  final String code;
  final String origin;
  final String destination;
  final OperationStatus status;
  final DateTime scheduledDate;

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      id: json['id'] as String,
      code: json['code'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      status: OperationStatus.fromCode(json['status'] as String?),
      scheduledDate: DateTime.parse(json['scheduledDate'] as String).toLocal(),
    );
  }
}
