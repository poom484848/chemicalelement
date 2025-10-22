import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _i = DBHelper._();
  DBHelper._();
  factory DBHelper() => _i;

  static const _dbName = 'ptable.db';
  static const _dbVersion = 1;

  Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    final base = await getDatabasesPath();
    final path = join(base, _dbName);
    _db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    return _db!;
  }

  Future<void> _onCreate(Database db, int v) async {
    await db.execute('''
      CREATE TABLE chemical_element(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        atomic_number INTEGER NOT NULL,
        symbol TEXT NOT NULL,
        name_en TEXT NOT NULL,
        name_th TEXT NOT NULL,
        period INTEGER NOT NULL,
        grp INTEGER,
        category TEXT NOT NULL,
        atomic_mass REAL,
        electronegativity REAL,
        density REAL,
        melting_k REAL,
        boiling_k REAL,
        note TEXT
      );
    ''');
    await db.execute('CREATE UNIQUE INDEX idx_element_z ON chemical_element(atomic_number);');
    await _seedIfEmpty(db);
  }

  Future<void> _seedIfEmpty(Database db) async {
    final cnt = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM chemical_element'),
    ) ?? 0;
    if (cnt > 0) return;
    final raw = await rootBundle.loadString('assets/elements_seed.json');
    final List list = jsonDecode(raw);
    final batch = db.batch();
    for (final m in list) {
      batch.insert('chemical_element', Map<String, dynamic>.from(m));
    }
    await batch.commit(noResult: true);
  }
}
