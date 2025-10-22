import 'package:sqflite/sqflite.dart';
import '../features/element/data/chemical_element.dart';
import 'db_helper.dart';

class ElementRepository {
  static const table = 'chemical_element';

  Future<List<ChemicalElement>> getAll({String? q}) async {
    final db = await DBHelper().database;
    List<Map<String, Object?>> rows;
    if (q == null || q.isEmpty) {
      rows = await db.query(table, orderBy: 'atomic_number ASC');
    } else {
      rows = await db.query(
        table,
        where: 'symbol LIKE ? OR name_en LIKE ? OR name_th LIKE ?',
        whereArgs: ['%$q%','%$q%','%$q%'],
        orderBy: 'atomic_number ASC',
      );
    }
    return rows.map((e) => ChemicalElement.fromMap(e)).toList();
  }

  Future<int> insert(ChemicalElement e) async {
    final db = await DBHelper().database;
    return db.insert(table, e.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<int> update(ChemicalElement e) async {
    final db = await DBHelper().database;
    return db.update(table, e.toMap(), where: 'id = ?', whereArgs: [e.id]);
  }

  Future<int> delete(int id) async {
    final db = await DBHelper().database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<ChemicalElement?> getById(int id) async {
    final db = await DBHelper().database;
    final rows = await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return ChemicalElement.fromMap(rows.first);
  }
}
