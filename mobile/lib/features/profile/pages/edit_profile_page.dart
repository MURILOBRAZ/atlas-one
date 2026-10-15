import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/page_container.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/services/api_service.dart';
import '../../../models/employee.dart';

/// Formulário de edição do perfil.
///
/// Ao salvar, os dados são enviados para a API e gravados no banco.
/// A tela retorna o [Employee] atualizado para quem a abriu.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.employee});

  final Employee employee;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _repository = ProfileRepository();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _jobTitleController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _phoneController = TextEditingController(text: widget.employee.phone ?? '');
    _jobTitleController = TextEditingController(text: widget.employee.jobTitle);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o nome completo.';
    }
    if (value.trim().length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres.';
    }
    return null;
  }

  String? _validateJobTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o cargo ou a descrição profissional.';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final updatedEmployee = await _repository.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(updatedEmployee);
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Não foi possível salvar as alterações.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    hintText: '(13) 99999-9999',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _jobTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Cargo ou descrição profissional',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: _validateJobTitle,
                  onFieldSubmitted: (_) => _save(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'E-mail, matrícula e unidade são gerenciados pelo '
                        'departamento de Recursos Humanos.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                AppPrimaryButton(
                  label: 'Salvar alterações',
                  icon: Icons.check,
                  isLoading: _isSaving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
