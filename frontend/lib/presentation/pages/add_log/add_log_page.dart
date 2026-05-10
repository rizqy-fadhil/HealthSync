import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/neubrutalism_theme.dart';
import '../../../core/utils/health_data_store.dart';
import '../../../data/models/health_log.dart';
import '../../widgets/common/neu_card.dart';
import '../../widgets/common/neu_button.dart';

class AddLogPage extends StatefulWidget {
  final VoidCallback? onLogSaved;

  const AddLogPage({super.key, this.onLogSaved});

  @override
  State<AddLogPage> createState() => _AddLogPageState();
}

class _AddLogPageState extends State<AddLogPage> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();

  LogType _selectedType = LogType.water;
  bool _isSaving = false;

  // Color cycling for type chips
  final List<Color> _chipColors = [
    NeuColors.pink,
    NeuColors.yellow,
    NeuColors.mint,
    NeuColors.yellow,
    NeuColors.pink,
  ];

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await Future.delayed(const Duration(milliseconds: 500));

    final value = double.tryParse(_valueController.text.trim()) ?? 0;
    
    int? waterIntake;
    double? sleepDuration;
    double? weight;

    if (_selectedType == LogType.water) waterIntake = value.toInt();
    if (_selectedType == LogType.sleep) sleepDuration = value;
    if (_selectedType == LogType.weight) weight = value;

    await HealthDataStore.addLog(
      HealthLog(
        waterIntake: waterIntake,
        sleepDuration: sleepDuration,
        weight: weight,
        timestamp: DateTime.now(),
      ),
    );

    setState(() => _isSaving = false);
    widget.onLogSaved?.call();

    if (mounted) {
      Navigator.pop(context);
      _showSuccessSnackbar();
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NeuColors.mint,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: Text(
          '✅  LOG SAVED!',
          style: neuText(size: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('SELECT METRIC'),
                      const SizedBox(height: 12),
                      _buildTypeSelector(),
                      const SizedBox(height: 24),
                      _buildValueInputCard(),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: NeuButton(
                          label: 'SAVE LOG',
                          color: NeuColors.mint,
                          fontSize: 18,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          isLoading: _isSaving,
                          onPressed: _save,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: NeuButton(
                          label: 'CANCEL',
                          color: NeuColors.white,
                          fontSize: 15,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: NeuColors.yellow,
        border: Border(
          bottom: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NeuColors.black,
                border: Border.all(color: NeuColors.black, width: 2),
              ),
              child: const Icon(Icons.arrow_back, color: NeuColors.yellow, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '+ ADD LOG',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: NeuColors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Type Chips ───────────────────────────────
  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: LogType.values.asMap().entries.map((entry) {
        final i = entry.key;
        final type = entry.value;
        final isSelected = _selectedType == type;
        final chipColor = _chipColors[i % _chipColors.length];

        return GestureDetector(
          onTap: () => setState(() => _selectedType = type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? NeuColors.black : chipColor,
              border: Border.all(color: NeuColors.black, width: NeuDimens.borderWidth),
              boxShadow: isSelected
                  ? []
                  : [const BoxShadow(color: NeuColors.black, offset: Offset(4, 4))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(type.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  type.label.toUpperCase(),
                  style: neuText(
                    size: 13,
                    color: isSelected ? chipColor : NeuColors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── Value Input Card ────────────────────────
  Widget _buildValueInputCard() {
    return NeuCard(
      color: _selectedType.color,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              color: NeuColors.black,
              border: Border(
                bottom: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
              ),
            ),
            child: Row(
              children: [
                Text(_selectedType.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '${_selectedType.label.toUpperCase()} VALUE',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _selectedType.color,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: NeuColors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '00',
                      hintStyle: GoogleFonts.spaceGrotesk(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: NeuColors.black.withAlpha(60),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter a value';
                      if (double.tryParse(v) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                ),
                Text(
                  _selectedType.unit.toUpperCase(),
                  style: neuText(size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.5,
        color: NeuColors.black,
      ),
    );
  }
}
