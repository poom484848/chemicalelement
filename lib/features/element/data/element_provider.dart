import 'package:flutter/foundation.dart';
import '../../../core/element_repository.dart';
import 'chemical_element.dart';

class ElementProvider extends ChangeNotifier {
  final ElementRepository repo;
  ElementProvider({ElementRepository? repo}) : repo = repo ?? ElementRepository();

  List<ChemicalElement> items = [];
  bool loading = false;
  String query = '';

  Future<void> load() async {
    loading = true; notifyListeners();
    items = await repo.getAll(q: query);
    loading = false; notifyListeners();
  }

  void setQuery(String q) {
    query = q;
    load();
  }

  Future<void> create(ChemicalElement e) async {
    await repo.insert(e);
    await load();
  }

  Future<void> update(ChemicalElement e) async {
    await repo.update(e);
    await load();
  }

  Future<void> remove(int id) async {
    await repo.delete(id);
    await load();
  }
}
