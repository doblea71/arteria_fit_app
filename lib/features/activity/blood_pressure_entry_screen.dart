import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/database_service.dart';
import '../../core/providers/exercise_provider.dart';

class BloodPressureEntryScreen extends ConsumerStatefulWidget {
  const BloodPressureEntryScreen({super.key});

  @override
  ConsumerState<BloodPressureEntryScreen> createState() => _BloodPressureEntryScreenState();
}

class _BloodPressureEntryScreenState extends ConsumerState<BloodPressureEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();
  final _noteController = TextEditingController();
  
  bool _isSaving = false;

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveReading() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final db = DatabaseService();
      await db.insertBloodPressure(
        systolic: int.parse(_systolicController.text),
        diastolic: int.parse(_diastolicController.text),
        pulse: int.parse(_pulseController.text),
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );

      if (mounted) {
        // Notificamos que algo cambió para que el dashboard sepa
        ref.read(exerciseCompletedProvider.notifier).increment(); 
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro guardado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Tensión'),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Introduce tus valores actuales',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Asegúrate de estar en reposo al menos 5 minutos antes de la medición.',
                style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: 'Sistólica',
                      hint: '120',
                      controller: _systolicController,
                      icon: LucideIcons.arrowUpCircle,
                      suffix: 'mmHg',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      label: 'Diastólica',
                      hint: '80',
                      controller: _diastolicController,
                      icon: LucideIcons.arrowDownCircle,
                      suffix: 'mmHg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Pulso',
                hint: '72',
                controller: _pulseController,
                icon: LucideIcons.heart,
                suffix: 'ppm',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Nota (opcional)',
                hint: 'Ej: Después de caminar',
                controller: _noteController,
                icon: LucideIcons.stickyNote,
                isNumeric: false,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveReading,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Guardar Registro',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    String? suffix,
    bool isNumeric = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          validator: (value) {
            if (isNumeric) {
              if (value == null || value.isEmpty) return 'Requerido';
              if (int.tryParse(value) == null) return 'Inválido';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            suffixText: suffix,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
