import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/providers/auth_provider.dart';
import '../../../chatbot/data/ollama_service.dart';
import '../../../chatbot/providers/chat_provider.dart';
import '../../providers/health_provider.dart';

class SubmitExcuseDialog extends ConsumerStatefulWidget {
  const SubmitExcuseDialog({super.key});

  @override
  ConsumerState<SubmitExcuseDialog> createState() => _SubmitExcuseDialogState();
}

class _SubmitExcuseDialogState extends ConsumerState<SubmitExcuseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  Uint8List? _imageBytes;
  String? _imageName;
  bool _submitting = false;
  bool _validating = false;
  MedicalImageValidation? _validation;

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Seleccionar imagen'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, ImageSource.camera),
            child: const ListTile(
              leading: Icon(Icons.camera_alt_rounded),
              title: Text('Cámara'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
            child: const ListTile(
              leading: Icon(Icons.photo_library_rounded),
              title: Text('Galería'),
            ),
          ),
        ],
      ),
    );

    if (source == null) return;

    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageName = picked.name;
        _validation = null;
      });
      _validateImage(bytes);
    }
  }

  Future<void> _validateImage(Uint8List bytes) async {
    setState(() => _validating = true);
    try {
      final ollamaService = ref.read(ollamaServiceProvider);
      final result = await ollamaService.validateMedicalImage(bytes);
      if (mounted) {
        setState(() {
          _validation = result;
          _validating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _validation = MedicalImageValidation(
            isValid: false,
            documentType: 'Error',
            reason: 'No se pudo validar la imagen: $e',
            isError: true,
          );
          _validating = false;
        });
      }
    }
  }

  bool get _canSubmit {
    if (_submitting || _validating) return false;
    if (_imageBytes != null && _validation != null && !_validation!.isValid && !_validation!.isError) {
      return false;
    }
    return true;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageBytes != null && _validation != null && !_validation!.isValid && !_validation!.isError) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _submitting = true);

    try {
      await ref.read(medicalExcusesProvider.notifier).submitExcuse(
        studentId: user.id,
        studentName: user.fullName,
        reason: _reasonController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        imageBytes: _imageBytes,
        imageName: _imageName,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Excusa enviada correctamente'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 600;

    return Dialog(
      insetPadding: EdgeInsets.all(isSmall ? 16 : 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medical_services_rounded, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Nueva Excusa Médica', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Adjunta la imagen del certificado o excusa médica. La IA verificará que sea un documento válido.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Motivo *',
                    hintText: 'Ej: Cita médica, incapacidad...',
                    prefixIcon: Icon(Icons.subject_rounded),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el motivo' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notas adicionales',
                    hintText: 'Detalles adicionales (opcional)',
                    prefixIcon: Icon(Icons.notes_rounded),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Text('Imagen del soporte', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                if (_imageBytes != null) ...[
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _imageBytes!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 18),
                            onPressed: _validating || _submitting
                                ? null
                                : () => setState(() {
                                    _imageBytes = null;
                                    _imageName = null;
                                    _validation = null;
                                  }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _imageName ?? 'imagen.jpg',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  _buildValidationStatus(theme),
                ] else
                  InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(12),
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_rounded, size: 40, color: theme.colorScheme.primary),
                          const SizedBox(height: 8),
                          Text('Toca para adjuntar foto', style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          )),
                          const SizedBox(height: 4),
                          Text('Cámara o galería', style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          )),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _submitting || _validating ? null : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _canSubmit ? _submit : null,
                      icon: _submitting
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.send_rounded),
                      label: Text(_submitting ? 'Enviando...' : 'Enviar Excusa'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValidationStatus(ThemeData theme) {
    if (_validating) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'La IA está verificando el documento...',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
      );
    }

    if (_validation == null) return const SizedBox.shrink();

    if (_validation!.isError) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No se pudo verificar', style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.orange.shade800,
                  )),
                  const SizedBox(height: 2),
                  Text(
                    '${_validation!.reason}\nPuedes enviar la excusa, pero será revisada manualmente.',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_validation!.isValid) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✓ Documento médico válido', style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.green.shade800,
                  )),
                  const SizedBox(height: 2),
                  Text(
                    'Tipo: ${_validation!.documentType}\n${_validation!.reason}',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Invalid
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✗ Documento no válido', style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600, color: Colors.red.shade800,
                )),
                const SizedBox(height: 2),
                Text(
                  '${_validation!.reason}\n\nPor favor adjunta una imagen de un documento médico real.',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.red.shade700),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Cambiar imagen'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade300),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
