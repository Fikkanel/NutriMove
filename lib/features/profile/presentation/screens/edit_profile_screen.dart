import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/nutrimove_text_field.dart';
import '../../../../shared/widgets/nutrimove_button.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _weightCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final prof = context.read<ProfileProvider>();
    _nameCtrl = TextEditingController(text: prof.displayName);
    _heightCtrl = TextEditingController(text: prof.height.toString());
    _weightCtrl = TextEditingController(text: prof.weight.toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    
    await context.read<ProfileProvider>().updateProfile(
      displayName: _nameCtrl.text.trim(),
      height: double.tryParse(_heightCtrl.text),
      weight: double.tryParse(_weightCtrl.text),
    );
    
    if (mounted) {
      setState(() => _isSaving = false);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Profil', showBack: true),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NutriMoveTextField(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama',
                    controller: _nameCtrl,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),
                  NutriMoveTextField(
                    label: 'Tinggi Badan (cm)',
                    hint: 'Contoh: 170',
                    controller: _heightCtrl,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.height_rounded,
                    validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),
                  NutriMoveTextField(
                    label: 'Berat Badan (kg)',
                    hint: 'Contoh: 65',
                    controller: _weightCtrl,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.monitor_weight_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 40),
                  NutriMoveButton(
                    label: 'Simpan',
                    isLoading: _isSaving,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
