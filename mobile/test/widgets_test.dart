import 'package:atlas_one/app/theme/app_colors.dart';
import 'package:atlas_one/app/theme/app_theme.dart';
import 'package:atlas_one/core/widgets/metric_card.dart';
import 'package:atlas_one/core/widgets/status_badge.dart';
import 'package:atlas_one/features/dashboard/widgets/distribution_center_card.dart';
import 'package:atlas_one/features/operations/widgets/operation_card.dart';
import 'package:atlas_one/models/distribution_center.dart';
import 'package:atlas_one/models/employee.dart';
import 'package:atlas_one/models/operation.dart';
import 'package:atlas_one/features/profile/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Envolve o widget com o tema do aplicativo para os testes.
Widget buildTestable(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('StatusBadge exibe o texto informado', (tester) async {
    await tester.pumpWidget(
      buildTestable(const StatusBadge(label: 'Em trânsito', tone: StatusTone.info)),
    );

    expect(find.text('Em trânsito'), findsOneWidget);
  });

  testWidgets('MetricCard exibe valor e rótulo', (tester) async {
    await tester.pumpWidget(
      buildTestable(
        const MetricCard(
          icon: Icons.local_shipping_outlined,
          label: 'Operações ativas',
          value: '24',
          color: AppColors.blue,
        ),
      ),
    );

    expect(find.text('24'), findsOneWidget);
    expect(find.text('Operações ativas'), findsOneWidget);
  });

  testWidgets('cards não estouram o layout em telas estreitas', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildTestable(
        Column(
          children: [
            OperationCard(
              operation: Operation(
                id: '1',
                code: 'OP-1051',
                origin: 'São José dos Campos',
                destination: 'Ribeirão Preto',
                status: OperationStatus.awaitingPickup,
                scheduledDate: DateTime(2026, 9, 17, 14, 30),
              ),
            ),
            const DistributionCenterCard(
              center: DistributionCenter(
                id: '1',
                code: 'CD-GRU',
                name: 'Centro de Distribuição Guarulhos',
                city: 'Guarulhos',
                state: 'SP',
                status: DistributionCenterStatus.normal,
              ),
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Aguardando coleta'), findsOneWidget);
    expect(find.text('Operação normal'), findsOneWidget);
  });

  testWidgets('Editar perfil valida o nome antes de salvar', (tester) async {
    const employee = Employee(
      id: '1',
      name: 'Lucas Almeida',
      email: 'lucas.almeida@atlaslogistics.com',
      jobTitle: 'Operador Logístico',
      registration: 'ATL-2847',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const EditProfilePage(employee: employee),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.tap(find.text('Salvar alterações'));
    await tester.pump();

    expect(find.text('Informe o nome completo.'), findsOneWidget);
  });
}
