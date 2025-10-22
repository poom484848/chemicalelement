import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/chemical_element.dart';
import '../data/element_provider.dart';

class ElementFormPage extends StatefulWidget {
  final ChemicalElement? editing;
  const ElementFormPage({super.key, this.editing});

  @override
  State<ElementFormPage> createState() => _ElementFormPageState();
}

class _ElementFormPageState extends State<ElementFormPage> {
  final _f = GlobalKey<FormState>();
  final _z = TextEditingController();
  final _symbol = TextEditingController();
  final _nameEn = TextEditingController();
  final _nameTh = TextEditingController();
  final _period = TextEditingController();
  final _group = TextEditingController();
  final _mass = TextEditingController();
  final _note = TextEditingController();

  ElementCategory _category = ElementCategory.nonmetal;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _z.text = e.atomicNumber.toString();
      _symbol.text = e.symbol;
      _nameEn.text = e.nameEn;
      _nameTh.text = e.nameTh;
      _period.text = e.period.toString();
      _group.text = e.group?.toString() ?? '';
      _mass.text = e.atomicMass?.toString() ?? '';
      _note.text = e.note ?? '';
      _category = e.category;
    }
  }

  @override
  void dispose() {
    for (final c in [_z,_symbol,_nameEn,_nameTh,_period,_group,_mass,_note]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_f.currentState!.validate()) return;
    final e = ChemicalElement(
      id: widget.editing?.id,
      atomicNumber: int.parse(_z.text),
      symbol: _symbol.text.trim(),
      nameEn: _nameEn.text.trim(),
      nameTh: _nameTh.text.trim(),
      period: int.parse(_period.text),
      group: _group.text.trim().isEmpty ? null : int.parse(_group.text),
      category: _category,
      atomicMass: _mass.text.trim().isEmpty ? null : double.parse(_mass.text),
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
    final prov = context.read<ElementProvider>();
    if (widget.editing == null) { await prov.create(e); } else { await prov.update(e); }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.editing != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'แก้ไขธาตุ' : 'เพิ่มธาตุ')),
      body: Form(
        key: _f,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _num('เลขอะตอม (Z)', _z),
            _text('สัญลักษณ์ (Symbol)', _symbol),
            _text('ชื่ออังกฤษ', _nameEn),
            _text('ชื่อไทย', _nameTh),
            _num('คาบ (Period)', _period),
            _num('หมู่ (Group, ว่างได้)', _group, required: false),
            _num('มวลอะตอม (u, ว่างได้)', _mass, required: false),
            const SizedBox(height: 8),
            DropdownButtonFormField<ElementCategory>(
              value: _category,
              items: ElementCategory.values.map((c) =>
                DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (v) => setState(()=> _category = v!),
              decoration: const InputDecoration(
                labelText: 'หมวดหมู่ (Category)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            _text('หมายเหตุ (Optional)', _note, required: false),
            const SizedBox(height: 14),
            FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('บันทึก')),
          ],
        ),
      ),
    );
  }

  Widget _text(String label, TextEditingController c, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: required ? (v)=> (v==null || v.trim().isEmpty) ? 'กรอก$label' : null : null,
      ),
    );
  }
  Widget _num(String label, TextEditingController c, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: required ? (v)=> (v==null || v.trim().isEmpty) ? 'กรอก$label' : null : null,
      ),
    );
  }
}
