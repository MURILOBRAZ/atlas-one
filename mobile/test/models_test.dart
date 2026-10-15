import 'package:atlas_one/models/dashboard_summary.dart';
import 'package:atlas_one/models/distribution_center.dart';
import 'package:atlas_one/models/employee.dart';
import 'package:atlas_one/models/operation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Operation.fromJson', () {
    test('converte o status enviado pela API', () {
      final operation = Operation.fromJson({
        'id': '1',
        'code': 'OP-1048',
        'origin': 'Santos',
        'destination': 'Campinas',
        'status': 'in_transit',
        'scheduledDate': '2026-09-17T14:30:00.000Z',
      });

      expect(operation.code, 'OP-1048');
      expect(operation.status, OperationStatus.inTransit);
      expect(operation.status.label, 'Em trânsito');
    });

    test('usa "unknown" quando o status não é reconhecido', () {
      expect(OperationStatus.fromCode('cancelled'), OperationStatus.unknown);
    });
  });

  group('Employee', () {
    const employee = Employee(
      id: '1',
      name: 'Lucas Almeida',
      email: 'lucas.almeida@atlaslogistics.com',
      jobTitle: 'Operador Logístico',
      registration: 'ATL-2847',
    );

    test('retorna o primeiro nome', () {
      expect(employee.firstName, 'Lucas');
    });

    test('retorna as iniciais do nome', () {
      expect(employee.initials, 'LA');
    });
  });

  test('DashboardSummary.fromJson converte os centros de distribuição', () {
    final summary = DashboardSummary.fromJson({
      'employeeFirstName': 'Lucas',
      'activeOperations': 24,
      'deliveriesToday': 17,
      'incidents': 3,
      'onTimePercentage': 92,
      'distributionCenters': [
        {
          'id': '1',
          'code': 'CD-CPS',
          'name': 'Centro de Distribuição Campinas',
          'city': 'Campinas',
          'state': 'SP',
          'status': 'attention',
        },
      ],
    });

    expect(summary.activeOperations, 24);
    expect(summary.distributionCenters.single.status, DistributionCenterStatus.attention);
    expect(summary.distributionCenters.single.location, 'Campinas - SP');
  });
}
