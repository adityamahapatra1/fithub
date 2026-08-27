import 'package:flutter/material.dart';
import '../../models/body_composition_model.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';

class BfCalculatorScreen extends StatefulWidget {
  const BfCalculatorScreen({super.key});
  @override
  State<BfCalculatorScreen> createState() => _BfCalculatorScreenState();
}

class _BfCalculatorScreenState extends State<BfCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _waist = TextEditingController();
  final _neck = TextEditingController();
  final _height = TextEditingController();
  final _hip = TextEditingController();
  bool isMale = true;
  BodyCompositionResult? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Fat Estimator (Navy Method)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Male')),
                  ButtonSegment(value: false, label: Text('Female')),
                ],
                selected: {isMale},
                onSelectionChanged: (s) => setState(() => isMale = s.first),
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _waist, decoration: const InputDecoration(labelText: 'Waist (cm)'), validator: (v) => Validators.validateNumber(v, 'Waist')),
              const SizedBox(height: 12),
              TextFormField(controller: _neck, decoration: const InputDecoration(labelText: 'Neck (cm)'), validator: (v) => Validators.validateNumber(v, 'Neck')),
              const SizedBox(height: 12),
              TextFormField(controller: _height, decoration: const InputDecoration(labelText: 'Height (cm)'), validator: (v) => Validators.validateNumber(v, 'Height')),
              if (!isMale) ...[
                const SizedBox(height: 12),
                TextFormField(controller: _hip, decoration: const InputDecoration(labelText: 'Hip (cm)'), validator: (v) => Validators.validateNumber(v, 'Hip')),
              ],
              const SizedBox(height: 24),
              CustomButton(label: 'Calculate', onPressed: _calculate),
              if (result != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('${result!.bodyFatPercent.toStringAsFixed(1)}% Body Fat', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text(result!.category, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      if (isMale) {
        result = BodyCompositionResult.calculateMale(
          waistCm: double.parse(_waist.text),
          neckCm: double.parse(_neck.text),
          heightCm: double.parse(_height.text),
        );
      } else {
        result = BodyCompositionResult.calculateFemale(
          waistCm: double.parse(_waist.text),
          neckCm: double.parse(_neck.text),
          heightCm: double.parse(_height.text),
          hipCm: double.parse(_hip.text),
        );
      }
    });
  }
}