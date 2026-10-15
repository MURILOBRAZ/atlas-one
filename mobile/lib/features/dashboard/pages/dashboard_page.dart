import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/atlas_logo.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/page_container.dart';
import '../../../core/widgets/section_title.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../data/services/api_service.dart';
import '../../../models/dashboard_summary.dart';
import '../widgets/distribution_center_card.dart';
import '../widgets/greeting_header.dart';
import '../widgets/metrics_grid.dart';
import '../widgets/network_status_banner.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _repository = DashboardRepository();

  DashboardSummary? _summary;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final summary = await _repository.fetchSummary();
      if (!mounted) return;
      setState(() => _summary = summary);
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
      appBar: AppBar(title: const AtlasLogo()),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingState(message: 'Carregando indicadores...');
    }

    if (_errorMessage != null) {
      return ErrorState(message: _errorMessage!, onRetry: _loadDashboard);
    }

    final summary = _summary!;

    return SingleChildScrollView(
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GreetingHeader(firstName: summary.employeeFirstName),
            const SizedBox(height: AppSpacing.xl),
            NetworkStatusBanner(centers: summary.distributionCenters),
            const SizedBox(height: AppSpacing.xl),
            const SectionTitle(title: 'Indicadores do dia'),
            MetricsGrid(summary: summary),
            const SizedBox(height: AppSpacing.xl),
            const SectionTitle(
              title: 'Resumo operacional',
              subtitle: 'Situação dos centros de distribuição',
            ),
            Column(
              spacing: AppSpacing.md,
              children: [
                for (final center in summary.distributionCenters)
                  DistributionCenterCard(center: center),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
