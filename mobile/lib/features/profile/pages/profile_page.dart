import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/page_container.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/services/api_service.dart';
import '../../../models/employee.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_row.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _repository = ProfileRepository();

  Employee? _employee;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final employee = await _repository.fetchProfile();
      if (!mounted) return;
      setState(() => _employee = employee);
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

  /// Abre a tela de edição e, se o usuário salvar, exibe o perfil atualizado.
  Future<void> _openEditProfile() async {
    final updatedEmployee = await Navigator.of(context).push<Employee>(
      MaterialPageRoute(
        builder: (context) => EditProfilePage(employee: _employee!),
      ),
    );

    if (updatedEmployee == null || !mounted) return;

    setState(() => _employee = updatedEmployee);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingState(message: 'Carregando perfil...');
    }

    if (_errorMessage != null) {
      return ErrorState(message: _errorMessage!, onRetry: _loadProfile);
    }

    final employee = _employee!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            ProfileHeader(employee: employee),
            const SizedBox(height: AppSpacing.xl),
            Card(
              child: Column(
                children: [
                  ProfileInfoRow(
                    icon: Icons.mail_outline,
                    label: 'E-mail corporativo',
                    value: employee.email,
                  ),
                  const Divider(),
                  ProfileInfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Telefone',
                    value: employee.phone?.isNotEmpty == true
                        ? employee.phone!
                        : 'Não informado',
                  ),
                  const Divider(),
                  ProfileInfoRow(
                    icon: Icons.badge_outlined,
                    label: 'Matrícula',
                    value: employee.registration,
                  ),
                  const Divider(),
                  ProfileInfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Unidade',
                    value: employee.unit ?? 'Não vinculada',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              label: 'Editar perfil',
              icon: Icons.edit_outlined,
              onPressed: _openEditProfile,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              '${AppConstants.appName} · versão ${AppConstants.appVersion}',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
