import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/page_container.dart';
import '../../../data/repositories/announcements_repository.dart';
import '../../../data/services/api_service.dart';
import '../../../models/announcement.dart';
import '../widgets/announcement_card.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final _repository = AnnouncementsRepository();

  List<Announcement> _announcements = [];
  bool _isLoading = true;
  String? _errorMessage;

  int get _unreadCount =>
      _announcements.where((announcement) => !announcement.isRead).length;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final announcements = await _repository.fetchAnnouncements();
      if (!mounted) return;
      setState(() => _announcements = announcements);
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
      appBar: AppBar(title: const Text('Avisos')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingState(message: 'Carregando avisos...');
    }

    if (_errorMessage != null) {
      return ErrorState(message: _errorMessage!, onRetry: _loadAnnouncements);
    }

    if (_announcements.isEmpty) {
      return const EmptyState(
        icon: Icons.campaign_outlined,
        title: 'Nenhum aviso no momento',
        message: 'Os comunicados da Atlas Logistics aparecerão aqui.',
      );
    }

    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Comunicados internos', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _unreadCount == 0
                  ? 'Você está em dia com os comunicados.'
                  : 'Você tem $_unreadCount ${_unreadCount == 1 ? 'aviso não lido' : 'avisos não lidos'}.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Column(
              spacing: AppSpacing.md,
              children: [
                for (final announcement in _announcements)
                  AnnouncementCard(announcement: announcement),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
