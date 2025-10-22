enum ElementCategory {
  alkaliMetal, alkalineEarthMetal, transitionMetal, postTransitionMetal,
  metalloid, nonmetal, halogen, nobleGas, lanthanoid, actinoid, unknown
}

ElementCategory categoryFromString(String s) {
  switch (s) {
    case 'alkaliMetal': return ElementCategory.alkaliMetal;
    case 'alkalineEarthMetal': return ElementCategory.alkalineEarthMetal;
    case 'transitionMetal': return ElementCategory.transitionMetal;
    case 'postTransitionMetal': return ElementCategory.postTransitionMetal;
    case 'metalloid': return ElementCategory.metalloid;
    case 'nonmetal': return ElementCategory.nonmetal;
    case 'halogen': return ElementCategory.halogen;
    case 'nobleGas': return ElementCategory.nobleGas;
    case 'lanthanoid': return ElementCategory.lanthanoid;
    case 'actinoid': return ElementCategory.actinoid;
    default: return ElementCategory.unknown;
  }
}

class ChemicalElement {
  final int? id;              // PK (SQLite)
  final int atomicNumber;     // เลขอะตอม (Z)  ✅
  final String symbol;        // สัญลักษณ์     ✅
  final String nameEn;        // ชื่ออังกฤษ     ✅
  final String nameTh;        // ชื่อไทย
  final int period;           // คาบ           ✅
  final int? group;           // หมู่ (บางตัว null)
  final ElementCategory category; // หมวดหมู่   ✅
  final double? atomicMass;   // มวลอะตอม
  final double? electronegativity;
  final double? density;
  final double? meltingK;
  final double? boilingK;
  final String? note;         // เกร็ด/บันทึกย่อ

  ChemicalElement({
    this.id,
    required this.atomicNumber,
    required this.symbol,
    required this.nameEn,
    required this.nameTh,
    required this.period,
    required this.category,
    this.group,
    this.atomicMass,
    this.electronegativity,
    this.density,
    this.meltingK,
    this.boilingK,
    this.note,
  });

  ChemicalElement copyWith({
    int? id,
    int? atomicNumber,
    String? symbol,
    String? nameEn,
    String? nameTh,
    int? period,
    int? group,
    ElementCategory? category,
    double? atomicMass,
    double? electronegativity,
    double? density,
    double? meltingK,
    double? boilingK,
    String? note,
  }) {
    return ChemicalElement(
      id: id ?? this.id,
      atomicNumber: atomicNumber ?? this.atomicNumber,
      symbol: symbol ?? this.symbol,
      nameEn: nameEn ?? this.nameEn,
      nameTh: nameTh ?? this.nameTh,
      period: period ?? this.period,
      group: group ?? this.group,
      category: category ?? this.category,
      atomicMass: atomicMass ?? this.atomicMass,
      electronegativity: electronegativity ?? this.electronegativity,
      density: density ?? this.density,
      meltingK: meltingK ?? this.meltingK,
      boilingK: boilingK ?? this.boilingK,
      note: note ?? this.note,
    );
  }

  factory ChemicalElement.fromMap(Map<String, dynamic> m) => ChemicalElement(
        id: m['id'] as int?,
        atomicNumber: m['atomic_number'] as int,
        symbol: m['symbol'] as String,
        nameEn: m['name_en'] as String,
        nameTh: m['name_th'] as String,
        period: m['period'] as int,
        group: m['grp'] as int?, // ใช้ชื่อคอลัมน์สั้นหลบ keyword
        category: categoryFromString(m['category'] as String),
        atomicMass: _toD(m['atomic_mass']),
        electronegativity: _toD(m['electronegativity']),
        density: _toD(m['density']),
        meltingK: _toD(m['melting_k']),
        boilingK: _toD(m['boiling_k']),
        note: m['note'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id' : id,
        'atomic_number': atomicNumber,
        'symbol': symbol,
        'name_en': nameEn,
        'name_th': nameTh,
        'period': period,
        'grp': group,
        'category': category.name,
        'atomic_mass': atomicMass,
        'electronegativity': electronegativity,
        'density': density,
        'melting_k': meltingK,
        'boiling_k': boilingK,
        'note': note,
      };

  static double? _toD(Object? x) => x == null ? null : (x as num).toDouble();
}
