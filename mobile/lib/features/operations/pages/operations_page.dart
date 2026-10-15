import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/page_container.dart';
import '../../../core/widgets/section_title.dart';
import '../../../data/repositories/operations_repository.dart';
import '../../../data/services/api_service.dart';
import '../../../models/operation.dart';
import '../widgets/module_notice_card.dart';
import '../widgets/operation_card.dart';

class OperationsPage extends StatefulWidget {
  const OperationsPage({super.key});

  @override
  State<OperationsPage> createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  final _repository = OperationsRepository();

  List<Operation> _operations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOperations();
  }

  Future<void> _loadOperations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final operations = await _repository.fetchPreview();
      if (!mounted) return;
      setState(() => _operations = operations);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Ocorreu um erro inesperado.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Operações')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingState(message: 'Carregando operações...');
    }

    if (_errorMessage != null) {
      return ErrorState(message: _errorMessage!, onRetry: _loadOperations);
    }

    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Operações logísticas', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Acompanhe o transporte de cargas entre os centros de distribuição.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionTitle(
              title: 'Operações recentes',
              subtitle: 'Prévia das últimas movimentações registradas',
            ),
            _buildPreview(),
            const SizedBox(height: AppSpacing.xl),
            const ModuleNoticeCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_operations.isEmpty) {
      return const EmptyState(
        icon: Icons.local_shipping_outlined,
        title: 'Nenhuma operação registrada',
        message: 'As operações aparecerão aqui assim que forem registradas.',
      );
    }

    return Column(
      spacing: AppSpacing.md,
      children: [
        for (final operation in _operations) OperationCard(operation: operation),
      ],
    );
  }
}
